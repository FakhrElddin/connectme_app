import 'package:connectme_app/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.profileImageUrl,
    super.deviceModel,
    super.osVersion,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      deviceModel: json['deviceModel'] as String?,
      osVersion: json['osVersion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'deviceModel': deviceModel,
      'osVersion': osVersion,
    };
  }
}

/// Design Pattern: Builder Pattern
/// Why applied:
/// Allows step-by-step construction of the [UserModel]. During sign-up,
/// only basic credentials (id, name, email) are supplied, while device
/// details and profile images can be attached later without polluting the constructor.
class UserBuilder {
  String? _id;
  String? _name;
  String? _email;
  String? _profileImageUrl;
  String? _deviceModel;
  String? _osVersion;

  UserBuilder setId(String id) {
    _id = id;
    return this;
  }

  UserBuilder setName(String name) {
    _name = name;
    return this;
  }

  UserBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserBuilder setProfileImageUrl(String? profileImageUrl) {
    _profileImageUrl = profileImageUrl;
    return this;
  }

  UserBuilder setDeviceModel(String? deviceModel) {
    _deviceModel = deviceModel;
    return this;
  }

  UserBuilder setOsVersion(String? osVersion) {
    _osVersion = osVersion;
    return this;
  }

  UserModel build() {
    assert(_id != null, 'User ID is required to build a UserModel');
    assert(_name != null, 'User Name is required to build a UserModel');
    assert(_email != null, 'User Email is required to build a UserModel');

    return UserModel(
      id: _id!,
      name: _name!,
      email: _email!,
      profileImageUrl: _profileImageUrl,
      deviceModel: _deviceModel,
      osVersion: _osVersion,
    );
  }
}
