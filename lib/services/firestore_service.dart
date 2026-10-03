import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/data/models/user_model.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  Future<void> saveUserData(UserModel user) async {
    final docRef = db
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, options) =>
              UserModel.fromJson(snapshot.data()!),
          toFirestore: (userModel, options) => userModel.toJson(),
        )
        .doc(user.id);
    await docRef.set(user);
  }
}
