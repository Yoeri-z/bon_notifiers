# bon_notifiers

`bon_notifiers` is a collection of custom notifiers and mixins that I use in my projects. This package provides various utilities to extend on flutters Notifier principle. Primarily focussing on handling asynchronous operations with less boilerplate.

For a full statemanagement solution you can bundle this package with provider and flutters default notifiers.

## Features

- `AsyncNotifier<T>`: A notifier taylored for handling asynchronous data.
- `AsyncListenableBuilder<T>`: A widget that listens to `AsyncListenable` and rebuilds based on the state changes.
- `mixins`: Reusable functionality for handling different states like loading, error, and result in your custom notifiers.

## Example usage
### Async Notifier
Using asyncnotifier as an object
```dart
final notifier = AsyncNotifier<String>();

// Set value
notifier.set('Data');

// Set error
notifier.setError('Something went wrong');

// Check flags
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
  void editName(String newName) {
    setLoading();
    try{
      final data = await repo.update(result!.copyWith(name: newName));
      set(data);
    }
    catch(e){
      setError(e);
    }
  }
}

final complexNotifier = ComplexAsyncNotifier();

// Using extended functionality
complexNotifier.editName('Alice');
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

### Error Mixin
The error mixin can be used as follows:
```dart
class MyErrorNotifier extends ChangeNotifier with ErrorNotifier {
  // A method to simulate fetching data and setting an error
  void fetchData() {
    try {
      throw Exception("Data fetch failed");
    } catch (error) {
      setError(error);  // Sets error using ErrorNotifier
    }
  }
}

final notifier = MyErrorNotifier();

//The mixin exposes hasError and error getters
if(notifier.hasError){
    print(notifier.error);
}
```
### Loading mixin
The loading mixin can be used as follows:
```dart
class MyLoadingNotifier extends ChangeNotifier with LoadingNotifier {
  // A method to simulate data loading process
  void fetchData() {
    setLoading();  // Starts the loading state using LoadingNotifier

    // Simulating data fetch
    Future.delayed(Duration(seconds: 2), () {
      setNotLoading();  // Ends the loading state once data is fetched
    });
  }
}

final notifier = MyErrorNotifier();

//The mixin exposes a loading boolean flag
print(notifier.isLoading);
```

Everything public class and method in this package is documented, so for more documentation you can go to the sourcecode

## License
This project is licensed under the MIT License - see the LICENSE file for details.
