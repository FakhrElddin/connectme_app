import 'dart:convert';
import 'dart:io';

import 'package:connectme_app/core/widgets/custom_gradient_button.dart';
import 'package:connectme_app/presentation/widgets/picker_button.dart';
import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _newPickedImage;
  final String _userName = 'Bruno Pham';
  final String _userEmail = 'bruno.pham@example.com';
  final String? _profileImageBase64 = null; // سيتم ربطها بـ Firestore لاحقاً

  ImageProvider? _getAvatarImage() {
    if (_newPickedImage != null) {
      return FileImage(_newPickedImage!);
    }
    if (_profileImageBase64 != null && _profileImageBase64!.isNotEmpty) {
      return MemoryImage(base64Decode(_profileImageBase64!));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final headerHeight = screenHeight * 0.185;
    final avatarRadius = screenWidth * 0.133;
    final avatarImage = _getAvatarImage();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          children: [
            SizedBox(
              height: headerHeight + avatarRadius,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: headerHeight,
                    child: Image.asset(
                      'assets/images/profile_header_bg.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.whiteColor,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: AppColors.primaryColor.withValues(
                            alpha: 0.15,
                          ),
                          backgroundImage: avatarImage,
                          child: avatarImage == null
                              ? Text(
                                  _userName.isNotEmpty
                                      ? _userName[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontFamily: 'CircularStd',
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                    fontSize: avatarRadius * 0.8,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showImagePickerBottomSheet(context);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size(34, 34),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.camera_alt_rounded, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // User Full Name
            const Text(
              'Bruno Pham',
              style: TextStyle(
                fontFamily: 'CircularStd',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkTextColor,
              ),
            ),
            const SizedBox(height: 4),
            // User Email
            const Text(
              'bruno.pham@example.com',
              style: TextStyle(
                fontFamily: 'CircularStd',
                fontSize: 14,
                color: AppColors.greyColor,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.homeBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.devices_rounded,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Device Model',
                              style: TextStyle(
                                fontFamily: 'CircularStd',
                                fontSize: 12,
                                color: AppColors.greyColor,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Pixel 7 Pro',
                              style: TextStyle(
                                fontFamily: 'CircularStd',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(height: 40, color: AppColors.greyColor),
                    Row(
                      children: [
                        Icon(
                          Icons.android_rounded,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OS Version',
                              style: TextStyle(
                                fontFamily: 'CircularStd',
                                fontSize: 12,
                                color: AppColors.greyColor,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Android 14',
                              style: TextStyle(
                                fontFamily: 'CircularStd',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_newPickedImage != null) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomGradientButton(
                  text: 'Update Profile Photo',
                  onTap: () {
                    // TODO: Upload image to Firestore in Base64
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparentColor,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontFamily: 'CircularStd',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select a photo from your camera or gallery to update your profile.',
                  style: TextStyle(
                    fontFamily: 'CircularStd',
                    fontSize: 13,
                    color: AppColors.greyColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: PickerButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Camera',
                        onTap: () async {
                          Navigator.pop(context);
                          final picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 25,
                            maxWidth: 400,
                            maxHeight: 400,
                          );
                          if (image != null) {
                            setState(() {
                              _newPickedImage = File(image.path);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PickerButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.whiteColor,
                        borderColor: AppColors.primaryColor,
                        onTap: () async {
                          Navigator.pop(context);
                          final picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 25,
                            maxWidth: 400,
                            maxHeight: 400,
                          );
                          if (image != null) {
                            setState(() {
                              _newPickedImage = File(image.path);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
