import 'dart:async';
import 'dart:collection';

/// A simple semaphore implementation for controlling concurrent operations
class Semaphore {
  final int _maxCount;
  int _currentCount;
  final Queue<Completer<void>> _waitQueue = Queue<Completer<void>>();

  Semaphore(this._maxCount) : _currentCount = _maxCount;

  /// Acquires a permit from this semaphore
  Future<void> acquire() async {
    if (_currentCount > 0) {
      _currentCount--;
      return;
    }

    final completer = Completer<void>();
    _waitQueue.add(completer);
    return completer.future;
  }

  /// Releases a permit, returning it to this semaphore
  void release() {
    if (_waitQueue.isNotEmpty) {
      final completer = _waitQueue.removeFirst();
      completer.complete();
    } else {
      _currentCount++;
    }
  }

  /// Returns the current number of permits available
  int get availablePermits => _currentCount;

  /// Returns the maximum number of permits for this semaphore
  int get maxPermits => _maxCount;
}
