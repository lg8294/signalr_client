typedef OnAbort = void Function();

/// Represents a signal that can be monitored to determine if a request has been aborted.
abstract class IAbortSignal {
  /// Indicates if the request has been aborted.
  bool get aborted;

  /// Set this to a handler that will be invoked when the request is aborted.
  OnAbort onAbort;
}

class AbortController implements IAbortSignal {
  // Properties
  bool _isAborted;

  OnAbort onAbort;

  bool get aborted => this._isAborted;

  IAbortSignal get signal => this;

  // Methods

  AbortController() {
    this._isAborted = false;
  }

  void abort() {
    if (!this._isAborted) {
      this._isAborted = true;
      if (this.onAbort != null) {
        this.onAbort();
      }
    }
  }
}
