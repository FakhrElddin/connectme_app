import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
  });

  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obscureText = false;

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        cursorColor: AppColors.primaryColor,
        style: const TextStyle(
          fontFamily: 'CircularStd',
          fontSize: 16,
          color: AppColors.darkTextColor,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontFamily: 'CircularStd',
            fontSize: 16,
            color: AppColors.greyColor,
            letterSpacing: -0.2,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: toggleObscureText,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SvgPicture.asset(
                      'assets/icons/ic_show.svg',
                      width: 24,
                      height: 24,
                      fit: BoxFit.scaleDown,
                      colorFilter: ColorFilter.mode(
                        obscureText
                            ? AppColors.greyColor
                            : AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
