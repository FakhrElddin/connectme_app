part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final String? profileImage;
  final String name;
  final String email;
  final String deviceModel;
  final String osVersion;

  ProfileSuccess({
    required this.profileImage,
    required this.name,
    required this.email,
    required this.deviceModel,
    required this.osVersion,
  });
}

final class ProfileError extends ProfileState {
  final Failures failures;

  ProfileError({required this.failures});
}

final class BiometricAuthSuccess extends ProfileState {}

final class BiometricAuthFailure extends ProfileState {
  final String title;
  final String message;

  BiometricAuthFailure({
    required this.title,
    required this.message,
  });
}

