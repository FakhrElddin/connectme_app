import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  Future<Either<Failures, Unit>> saveUserData({required UserModel user}) async {
    try {
      final docRef = db
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore: (snapshot, options) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (userModel, options) => userModel.toJson(),
          )
          .doc(user.id);
      await docRef.set(user);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure.fromFirebaseException(e));
    } catch (e) {
      return Left(
        UnexpectedFailure(
          errorMessage:
              'An unexpected database error occurred, Please try again later.',
        ),
      );
    }
  }
}
