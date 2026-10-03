import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/data/models/user_model.dart';
import 'package:connectme_app/services/firestore_service.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<Either<Failures, UserCredential>> signUpUser({
    required String emailAddress,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      final user = UserBuilder()
          .setId(userCredential.user!.uid)
          .setEmail(emailAddress)
          .setName(name)
          .build();
      var either = await _firestoreService.saveUserData(user: user);
      return await either.fold(
        (failure) => Left(failure),
        (_) => Right(userCredential),
      );
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
