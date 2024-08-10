class AuthResponse {
  final AuthResult authResult;
  final String? errorMessage;

  AuthResponse({required this.authResult, required this.errorMessage});
}

enum AuthResult { success, aborted, failure }

extension ResultX on AuthResult {
  bool get isSuccess => this == AuthResult.success;
  bool get isAborted => this == AuthResult.aborted;
  bool get isFailure => this == AuthResult.failure;
}
