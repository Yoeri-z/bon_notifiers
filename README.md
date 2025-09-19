# bon_notifiers

`bon_notifiers` is a collection of custom notifiers and mixins that I use in my projects. This package provides various utilities to extend on flutters Notifier principle. Primarily focussing on handling asynchronous operations with less boilerplate.

For a full statemanagement solution you can bundle this package with provider and flutters default notifiers.

## Features

- `AsyncNotifier`: A ChangeNotifier taylored for handling asynchronous data.
- `AsyncValueNotifier<T>`: A special type of AsyncNotifier that handles only 1 object of data.
- `AsyncListenableBuilder<T>`: A widget that listens to `AsyncListenable`.
- `AsyncValueListenableBuilder<T>`: A widget that listens to `AsyncValueListenable`
- `LoadingNotifierMixin`: Add loading functionality to a regular flutter notifier
- `ErrorNotifierMixin`: Add error handling functionality to a regular flutter notifier

## Async flags
Async notifiers have three main flags:
  1. The `.hasError` flag, indicates wether or not the notifier encountered an error during async operations.
  2. The `.isLoading` flag, indicates wether or not the notifier is currently doing an async operation.
  3. The `.hasData` flag, indicates wether or not the notifier has some valid data.

With these three flags it should always be possible to determine the exact state a notifier is in.

## Async Notifier
Async notifier is similar to a change notifier, but it has a few additional methods:
```dart
//Mark the notifier as loading
notifier.setLoading()
//Mark the notifier as not loading
notifier.setNotLoading()
// set an error
notifier.setError()
//remove any errors
notifier.clearError()
//a method that runs a future and handles all the flag changing for you
final result = runFuture(myFuture)
```

### Example usage
```dart
class MyNotifier extends AsynNotifier<Data> {
  MyNotifier({required this.repo}) {
    _init();
  }

  final ExampleRepository repo;
  int? count;
  
  Future<void> _init(){
    count = runFuture(repo.getCount())
  }

  Future<void> update(int newCount){
    count = runFuture(repo.updateCount())
  }
}

final countNotifier = MyNotifier();

countNotifier.update(3);
```


### AsyncListenableBuilder
```dart
AsyncListenableBuilder<String>(
  //pass the asyncNotifier (or a custom async listenable)
  asyncListenable: notifier,
  //the the builder is executed when the asyncListenable has data
  builder: (context, listenable, child) => Text(result),
  //the errorBuilder is executed when the asyncListenable optains an error
  errorBuilder: (context, error, child) => Text('Error: $error'),
  //a loadingIndicator can be optionally passed, this defaults to CircularProgressIndicator.adaptive
  loadingIndicator: CircularProgressIndicator(),
  //Like the native flutter ListenableBuilders, a static child can be provided if a part of the widget tree is not dependant on the notifier
  child: Text('This is a static widget'),
)
```
## Async Value Notifier
Async value notifier is similar to a value notifier, but instead of having a value flag it has a data flag:
```dart
// setting the data updates flags and notifies listeners
notifier.data = someData

// update the data safely
notifier.update((data) => data)

// all the methods of async notifier are also available
```
### Example usage
```dart
class MyNotifier extends AsyncValueNotifier<Data> {
  MyNotifier({required this.repo}) {
    _init();
  }

  final ExampleRepository repo;
  
  Future<void> _init(){
    data = runFuture(repo.getData())
  }

  Future<void> editName(String newName){
    data = runFuture(repo.updateName(newName))
  }
}

final complexNotifier = ComplexAsyncNotifier();

// Using extended functionality
complexNotifier.editName('Alice');
```

### Async Value Listenable Builder
```dart
AsyncValueListenableBuilder<String>(
  //pass the asyncNotifier (or a custom async listenable)
  asyncListenable: notifier,
  //the the builder is executed when the asyncListenable has data
  resultBuilder: (context, listenable, child) => Text(result),
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
      setError(error, message: 'Failed to fetch data');
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

### Listening for errors:
The AsyncListenable class exposes a listener that can be added to handle or log errors from one place.
```dart
AsyncListenable.errorListener =  (message, error, stackTrace){
  //log errors from one place so we dont have to put logger calls in every notifier
 logger.e(
    '$message in ${notifier.runtimeType}', 
    error: error, 
    stackTrace:  stackTrace
 );
}

```
This method will be called any time `setError`, `runFuture` is called.

Every public class and method in this package is documented, for more documentation see [the api reference](https://pub.dev/documentation/bon_notifiers/latest/bon_notifiers/)
## License
This project is licensed under the MIT License - see the LICENSE file for details.
