part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final String? profileImage;
  final String name;
  final String email;

  ProfileSuccess({required this.profileImage, required this.name, required this.email});
}

final class ProfileError extends ProfileState {
  final Failures failures;

  ProfileError({required this.failures});
}
