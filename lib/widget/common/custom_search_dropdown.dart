import 'package:flutter/material.dart';
import 'colors.dart';
import '../../utils/responsive_utils.dart';

/// Custom search dropdown widget with label and field format
/// Based on design specs: Poppins 400, 18px, #3F3F3F
/// Field: 505px width, 20px height (content area), 5px radius, #F3F3F3 background
/// Optional icon at extreme right/end
class CustomSearchDropdown extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool required;
  final String? errorText;

   final FocusNode?  focusNode; // New add

  const CustomSearchDropdown({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.hint,
    this.validator,
    this.onTap,
    this.width,
    this.height,
    this.required = false,
    this.errorText,
    this.focusNode,  // New add
  });

  @override
  Widget build(BuildContext context) {
    final labelFontSize = IntakeLayoutTokens.inputFont(context);
    final helperFontSize = IntakeLayoutTokens.smallFont(context);
    final fieldHeight = height ?? IntakeLayoutTokens.inputHeight(context);
    final fieldRadius = IntakeLayoutTokens.inputRadius(context);
    final borderWidth = ResponsiveUtils.scaleWidth(context, 1, min: 1, max: 2);
    final labelSpacing = IntakeLayoutTokens.smallSpacing(context);
    final iconSize = IntakeLayoutTokens.iconSize(context);
    final contentPadding = IntakeLayoutTokens.horizontalPadding(context);
    final verticalPadding = IntakeLayoutTokens.mediumSpacing(context);
    final errorSpacing = IntakeLayoutTokens.xSmallSpacing(context);

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with optional red asterisk for required fields
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: labelFontSize,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3F3F3F),
                height: 1.2,
              ),
              children: required
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: labelFontSize,
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
          SizedBox(height: labelSpacing),
          // Text Field with Search/Dropdown functionality
          SizedBox(
            height: fieldHeight,
            child: TextFormField(
              controller: controller,

               focusNode: focusNode,   //New add

              validator: validator,
              readOnly: onTap != null,
              onTap: onTap,
              cursorColor: AppColors.ceoPrimary,
              decoration: InputDecoration(
                // LEFT side icon: use prefixIcon property
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: prefixIcon != null
                      ? Icon(
                          prefixIcon,
                          color: const Color(0xFF9E9E9E),
                          size: iconSize,
                        )
                      : null,
                ),

                // RIGHT side icon: use suffixIcon property
                suffixIcon: suffixIcon != null
                    ? Icon(
                        suffixIcon,
                        color: const Color.fromARGB(255, 221, 23, 23),
                        size: iconSize,
                      )
                    : null,
                hintText: hint,

                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: labelFontSize,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFBDBDBD),
                ),

                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: contentPadding,
                  vertical: verticalPadding,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldRadius),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldRadius),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldRadius),
                  borderSide: BorderSide(
                    color: AppColors.ceoPrimary,
                    width: borderWidth,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldRadius),
                  borderSide: BorderSide(
                    color: AppColors.error,
                    width: borderWidth,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldRadius),
                  borderSide: BorderSide(
                    color: AppColors.error,
                    width: borderWidth,
                  ),
                ),
              ),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: labelFontSize,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3F3F3F),
              ),
            ),
          ),
          // Error text (only shown when errorText is not null)
          if (errorText != null)
            Padding(
              padding: EdgeInsets.only(top: errorSpacing),
              child: Text(
                errorText!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: helperFontSize,
                  fontWeight: FontWeight.w400,
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
