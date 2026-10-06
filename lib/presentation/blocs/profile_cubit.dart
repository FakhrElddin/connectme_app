import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/core/errors/failures.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

      final info = await _fetchDeviceInfo();

      emit(
        ProfileSuccess(
          profileImage: userDoc.data()?['profileImageUrl'],
          name: userDoc.data()?['name'] ?? 'Community Member',
          email: userDoc.data()?['email'] ?? currentUser.email ?? '',
          deviceModel: info['deviceModel']!,
          osVersion: info['osVersion']!,
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

  Future<Map<String, String>> _fetchDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      return {
        'deviceModel': webInfo.browserName.name.toUpperCase(),
        'osVersion': webInfo.userAgent ?? 'Unknown Web Agent',
      };
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return {
        'deviceModel': androidInfo.model,
        'osVersion': 'Android ${androidInfo.version.release}',
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return {
        'deviceModel': iosInfo.name,
        'osVersion': '${iosInfo.systemName} ${iosInfo.systemVersion}',
      };
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return {
        'deviceModel': windowsInfo.computerName,
        'osVersion': windowsInfo.productName,
      };
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      return {
        'deviceModel': macInfo.model,
        'osVersion': 'macOS ${macInfo.osRelease}',
      };
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return {
        'deviceModel': linuxInfo.name,
        'osVersion': linuxInfo.versionId ?? 'Unknown Linux Version',
      };
    } else {
      return {'deviceModel': 'Unknown', 'osVersion': 'Unknown'};
    }
  }
}
