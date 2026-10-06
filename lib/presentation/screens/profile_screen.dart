import 'dart:convert';
import 'dart:io';

import 'package:connectme_app/core/widgets/custom_gradient_button.dart';
import 'package:connectme_app/presentation/blocs/profile_cubit.dart';
import 'package:connectme_app/presentation/widgets/device_info_tile.dart';
import 'package:connectme_app/presentation/widgets/picker_button.dart';
import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _newPickedImage;

  ImageProvider? _getAvatarImage(String? profileImageBase64) {
    if (_newPickedImage != null) {
      return FileImage(_newPickedImage!);
    }
    if (profileImageBase64 != null && profileImageBase64.isNotEmpty) {
      return MemoryImage(base64Decode(profileImageBase64));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final headerHeight = screenHeight * 0.185;
    final avatarRadius = screenWidth * 0.133;

    return BlocProvider(
      create: (context) => ProfileCubit()..getCurrentUserData(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.transparentColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileSuccess) {
                final avatarImage = _getAvatarImage(state.profileImage);
                return Column(
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
                                  backgroundColor: AppColors.primaryColor
                                      .withValues(alpha: 0.15),
                                  backgroundImage: avatarImage,
                                  child: avatarImage == null
                                      ? Text(
                                          state.name.isNotEmpty
                                              ? state.name[0].toUpperCase()
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
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.name,
                      style: const TextStyle(
                        fontFamily: 'CircularStd',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.email,
                      style: const TextStyle(
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
                        child: Column(
                          children: [
                            DeviceInfoTile(
                              icon: Icons.devices_rounded,
                              title: 'Device Model',
                              value: state.deviceModel,
                            ),
                            const Divider(
                              height: 40,
                              color: AppColors.greyColor,
                            ),
                            DeviceInfoTile(
                              icon: Icons.android_rounded,
                              title: 'OS Version',
                              value: state.osVersion,
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
                          onTap: () async {
                            final bytes = await _newPickedImage!.readAsBytes();
                            final base64String = base64Encode(bytes);
                            if (!context.mounted) return;
                            await context
                                .read<ProfileCubit>()
                                .updateProfileImage(base64Image: base64String);
                            setState(() {
                              _newPickedImage = null;
                            });
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                );
              } else if (state is ProfileError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.redColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.wifi_off_rounded,
                            color: AppColors.redColor,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Failed to load Profile Data, Please try again ',
                          style: TextStyle(
                            fontFamily: 'CircularStd',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.failures.errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'CircularStd',
                            fontSize: 14,
                            color: AppColors.greyColor,
                          ),
                        ),
                        const SizedBox(height: 22),
                        ElevatedButton.icon(
                          onPressed: () =>
                              context.read<ProfileCubit>().getCurrentUserData(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          label: const Text(
                            'Try Again',
                            style: TextStyle(
                              fontFamily: 'CircularStd',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }
            },
          ),
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
