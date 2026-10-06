import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/core/errors/failures.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

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

  bool isAuthenticating = false;

  Future<void> authenticateWithBiometrics() async {
    if (isAuthenticating) return;
    isAuthenticating = true;
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show your profile info',
        biometricOnly: true,
      );
      if (didAuthenticate) {
        emit(BiometricAuthSuccess());
      }
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.noBiometricHardware) {
        emit(
          BiometricAuthFailure(
            title: 'Biometrics Not Available',
            message:
                'Your device does not support biometric authentication, or it is currently turned off in your system settings.',
          ),
        );
      } else if (e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
        emit(
          BiometricAuthFailure(
            title: 'Security Lockout',
            message:
                'Too many failed attempts. Biometric login is temporarily disabled. Please unlock your phone using your PIN or lock screen pattern to reset it.',
          ),
        );
      } else {
        emit(
          BiometricAuthFailure(
            title: 'Authentication Failed',
            message:
                'An error occurred during authentication. Please try again or use another method.',
          ),
        );
      }
    } catch (_) {
      emit(
        BiometricAuthFailure(
          title: 'Authentication Failed',
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
    } finally {
      isAuthenticating = false;
    }
  }
}
