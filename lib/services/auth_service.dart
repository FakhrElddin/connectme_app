import 'package:connectme_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<Either<Failures, UserCredential>> signUpUser({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseAuthException(e));
    } catch (e) {
      return Left(
        UnexpectedFailure(
          errorMessage: 'An unexpected error occurred, Please try again later.',
        ),
      );
    }
  }

  Future<Either<Failures, UserCredential>> loginUser({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromFirebaseAuthException(e));
    } catch (e) {
      return Left(
        UnexpectedFailure(
          errorMessage: 'An unexpected error occurred, Please try again later.',
        ),
      );
    }
  }
}
