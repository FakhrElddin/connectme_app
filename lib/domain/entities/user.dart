class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? deviceModel;
  final String? osVersion;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.deviceModel,
    this.osVersion,
  });
}
