# 1.1.1
 - removed `ResultUpdateFunction<T>` typedef as it is replaced by `ActionCallback<T>` typedef.

# 1.1.0
 - made message optional, to allow for not logging every single message
 - made stacktrace parameter in errorListener callback non-nullable.
 - added update method to `AsyncNotifier`.
 - changed min dart sdk version down to 3.0
# 1.0.0
 - made custom loading indicator not constraint in a 40 x 40 box.
 - added requireResult getter to `AsyncListenable` interface, added implementation to `AsynNotifier`

# 0.0.4
 - made `AsyncNotifier` and `ErrorNotifier` setError methods take the same arguments
 - added static `errorListener` to `AsyncNotifier`
# 0.0.3
 - Updated exports

# 0.0.2
 - Added debug BonError

## 0.0.1

 - Added AsyncNotifier
 - Added AsyncListenable Interface
 - Added AsyncListenableBuilder
 - Wrote tests testing AsyncNotifier and AsyncListenableBuilder
 - Added ErrorMixin
 - Added LoadingMixin
