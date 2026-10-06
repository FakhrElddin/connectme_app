import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/core/errors/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getCurrentUserData() async {
    try {
      emit(ProfileLoading());
      final currentUser = FirebaseAuth.instance.currentUser;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      emit(
        ProfileSuccess(
          profileImage: userDoc.data()?['profileImageUrl'],
          name: userDoc.data()?['name'],
          email: userDoc.data()?['email'],
        ),
      );
    } on FirebaseException catch (e) {
      emit(ProfileError(failures: FirestoreFailure.fromFirebaseException(e)));
    } catch (e) {
      emit(
        ProfileError(
          failures: UnexpectedFailure(
            errorMessage: 'There was an error, please try again later',
          ),
        ),
      );
    }
  }

  Future<void> updateProfileImage({required String base64Image}) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'profileImageUrl': base64Image});

      // إعادة جلب البيانات فوراً لظهور الصورة الجديدة
      await getCurrentUserData();
    } on FirebaseException catch (e) {
      emit(ProfileError(failures: FirestoreFailure.fromFirebaseException(e)));
    } catch (e) {
      emit(
        ProfileError(
          failures: UnexpectedFailure(
            errorMessage: 'Failed to update profile photo',
          ),
        ),
      );
    }
  }
}
