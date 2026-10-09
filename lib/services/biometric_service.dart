import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth;

  BiometricService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return canCheck || isDeviceSupported;
  }

  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to show your profile info',
    bool biometricOnly = true,
  }) async {
    return await _auth.authenticate(
      localizedReason: localizedReason,
      biometricOnly: biometricOnly,
    );
  }
}
