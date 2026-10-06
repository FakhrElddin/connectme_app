import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:connectme_app/core/widgets/custom_app_dialog.dart';
import 'package:connectme_app/injection.dart';
import 'package:connectme_app/presentation/blocs/profile_cubit.dart';
import 'package:connectme_app/presentation/screens/profile_screen.dart';
import 'package:connectme_app/presentation/widgets/category_tabs.dart';
import 'package:connectme_app/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeTabAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: AppColors.transparentColor,
      backgroundColor: AppColors.whiteColor,
      title: SizedBox(
        height: 44,
        child: CustomTextFormField(
          hintText: 'Search',
          textInputAction: TextInputAction.done,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/icons/search_ic.svg'),
          ),
        ),
      ),
      actions: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is BiometricAuthSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        getIt<ProfileCubit>()..getCurrentUserData(),
                    child: const ProfileScreen(),
                  ),
                ),
              );
            } else if (state is BiometricAuthFailure) {
              CustomAppDialog.showError(
                context: context,
                title: state.title,
                description: state.message,
              );
            }
          },
          child: IconButton(
            onPressed: () {
              BlocProvider.of<ProfileCubit>(context)
                  .authenticateWithBiometrics();
            },
            icon: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lightGreyColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.primaryColor,
                size: 24,
              ),
            ),
          ),
        ),
      ],
      bottom: const CategoryTabs(),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + CategoryTabs.preferredHeight);
}
