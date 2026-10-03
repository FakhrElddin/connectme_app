import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

/// Design Pattern: Singleton Pattern
/// Why applied:
/// Ensures only a single, shared instance of [FirestoreService] exists throughout
/// the entire app lifecycle, preventing multiple redundant database connections.
class FirestoreService {
  // 1. Private constructor to prevent direct external instantiation
  FirestoreService._();
  // 2. Static final instance representing the single cached object
  static final FirestoreService _instance = FirestoreService._();
  // 3. Factory constructor that always delivers the same cached instance
  factory FirestoreService() => _instance;

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
