import 'package:firebase_auth/firebase_auth.dart';

abstract class Failures {
  final String errorMessage;

  Failures({required this.errorMessage});
}

class UnexpectedFailure extends Failures {
  UnexpectedFailure({required super.errorMessage});
}

class AuthFailure extends Failures {
  AuthFailure({required super.errorMessage});

  factory AuthFailure.fromFirebaseAuthException(
    FirebaseAuthException authException,
  ) {
    switch (authException.code) {
      case 'weak-password':
        return AuthFailure(errorMessage: 'The password provided is too weak.');
      case 'email-already-in-use':
        return AuthFailure(
          errorMessage: 'An account already exists for that email.',
        );
      case 'invalid-email':
        return AuthFailure(errorMessage: 'The email address is not valid.');
      case 'user-not-found':
        return AuthFailure(
          errorMessage: 'No user found for that email address.',
        );
      case 'wrong-password':
        return AuthFailure(
          errorMessage: 'Wrong password provided for that user.',
        );
      case 'user-disabled':
        return AuthFailure(
          errorMessage: 'This user account has been disabled.',
        );
      case 'too-many-requests':
        return AuthFailure(
          errorMessage: 'Too many attempts. Please try again later.',
        );
      case 'network-request-failed':
        return AuthFailure(
          errorMessage: 'Network error. Please check your internet connection.',
        );
      default:
        return AuthFailure(
          errorMessage:
              authException.message ??
              'An unexpected authentication error occurred.',
        );
    }
  }
}

class FirestoreFailure extends Failures {
  FirestoreFailure({required super.errorMessage});
}
