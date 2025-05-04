# bon_notifiers

`bon_notifiers` is a collection of custom notifiers and mixins that I use in my projects. This package provides various utilities to handle state management in Flutter applications, focusing on `AsyncListenable` and `AsyncNotifier` implementations, as well as builders for reactive UI updates.

Everything in this package is well-documented to help you integrate it into your projects easily.

## Features

- `AsyncNotifier<T>`: A state management solution for asynchronous values with loading, error, and result states.
- `AsyncListenableBuilder<T>`: A widget that listens to `AsyncListenable` and rebuilds based on the state changes.
- `mixins`: Reusable functionality for handling different states like loading, error, and result in your custom notifiers.

## Installation

Add `bon_notifiers` as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  bon_notifiers: ^0.0.1
```

## Example usage
### Async Notifier
Using asyncnotifier as an object
```dart
final notifier = AsyncNotifier<String>();

// Set initial value
notifier.set('Initial data');

// Update value
notifier.update((result) => result + ' updated');

// Set error
notifier.setError('Something went wrong');

// Check state
if (notifier.isLoading) {
  // Show loading indicator
} else if (notifier.hasError) {
  // From this point it is safe to acces error
  print(notifier.error!);
} else if (notifier.hasResult) {
  // From this point it is safe to acces result
  print(notifier.result!);
}
```
Extending async notifier
```dart
//For more complex usecases extending AsyncNotifier can be useful
class ComplexAsyncNotifier extends AsyncNotifier<Data> {
  ComplexAsyncNotifier({required this.repo}) {
    _init();
  }

  final ExampleRepository repo;
  
  //add more complex behaviours
  Future<void> _init(){
    try{
        final result = await repo.getData();
        set(result);
    }
    catch(e){
        setError(e);
    }
  }
  //add custom methods
  void swap(Data newData) {
    set(newData);
  }
}

final complexNotifier = ComplexAsyncNotifier();

// Using extended functionality
complexNotifier.swap();
```

### AsyncListenableBuilder
```dart
AsyncListenableBuilder<String>(
  //pass the asyncNotifier (or a custom async listenable)
  asyncListenable: notifier,
  //the resultBuilder is executed when the asyncListenable optains a (new) result
  resultBuilder: (context, result, child) => Text(result),
  //the errorBuilder is executed when the asyncListenable optains an error
  errorBuilder: (context, error, child) => Text('Error: $error'),
  //a loadingIndicator can be optionally passed, this defaults to CircularProgressIndicator.adaptive
  loadingIndicator: CircularProgressIndicator(),
  //Like the native flutter ListenableBuilders, a static child can be provided if a part of the widget tree is not dependant on the notifier
  child: Text('This is a static widget'),
)
```
