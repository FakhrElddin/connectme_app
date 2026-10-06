import 'dart:io';

import 'package:connectme_app/presentation/blocs/post_cubit.dart';
import 'package:connectme_app/presentation/widgets/picker_button.dart';
import 'package:flutter/material.dart';
import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/core/widgets/custom_gradient_button.dart';
import 'package:connectme_app/core/widgets/custom_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostBottomSheet extends StatefulWidget {
  const CreatePostBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    final postCubit = BlocProvider.of<PostCubit>(context);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparentColor,
      builder: (_) => BlocProvider.value(
        value: postCubit,
        child: const CreatePostBottomSheet(),
      ),
    );
  }

  @override
  State<CreatePostBottomSheet> createState() => _CreatePostBottomSheetState();
}

class _CreatePostBottomSheetState extends State<CreatePostBottomSheet> {
  TextEditingController contentController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  File? pickedImage;

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Prevents Scaffold from resizing when keyboard opens:
      // 1. In HomeScreen: keeps the FAB fixed at the bottom.
      // 2. Here: prevents double-shift since we handle keyboard padding manually below.
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.transparentColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Form(
              key: formKey,
              child: Padding(
                // Lifts the bottom sheet just above the keyboard smoothly.
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
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
                            'Create Post',
                            style: TextStyle(
                              fontFamily: 'CircularStd',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkTextColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomTextFormField(
                            controller: contentController,
                            hintText: 'What\'s on your mind? (Required)',
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please write the post content';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          pickedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    pickedImage!,
                                    width: double.infinity,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  height: 300,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.homeBackgroundColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.lightGreyColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 48,
                                        color: AppColors.greyColor,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Select an image to share',
                                        style: TextStyle(
                                          fontFamily: 'CircularStd',
                                          fontSize: 14,
                                          color: AppColors.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: PickerButton(
                                  icon: Icons.camera_alt_rounded,
                                  label: 'Camera',
                                  onTap: () async {
                                    final picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.camera,
                                    );
                                    if (image != null) {
                                      pickedImage = File(image.path);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PickerButton(
                                  icon: Icons.photo_library_rounded,
                                  label: 'Gallery',
                                  onTap: () async {
                                    final picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    if (image != null) {
                                      pickedImage = File(image.path);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<PostCubit, PostState>(
                            listener: (context, state) {
                              if (state is CreatePostError) {
                                showCustomErrorSnackBar(
                                  context,
                                  message: state.failure.errorMessage,
                                );
                              } else if (state is CreatePostSuccess) {
                                Navigator.pop(context);
                              }
                            },
                            builder: (context, state) {
                              return state is CreatePostLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : CustomGradientButton(
                                      text: 'Publish',
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          final content = contentController.text
                                              .trim();
                                          BlocProvider.of<PostCubit>(context)
                                              .createPost(content: content);
                                        }
                                      },
                                    );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showCustomErrorSnackBar(
    BuildContext context, {
    required String message,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3142),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.redColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.redColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'CircularStd',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
