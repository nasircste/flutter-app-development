import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import '../../utils/responsive_utils.dart';

/// Custom text field widget with label and field format
/// Based on design specs: Poppins 400, 18px, #3F3F3F
/// Field: 505px width, 20px height (content area), 5px radius, #F3F3F3 background
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final double? height;
  final bool readOnly;
  final bool required;
  final String? errorText;
  final String? prefixText;
  final bool displayMode;
  final int? maxline;

  //final TextAlign textAlign; // New parameter
  final Function(String)? onChanged; //New add

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.width,
    this.height,
    this.readOnly = false,
    this.required = false,
    this.errorText,
    this.prefixText,
    this.displayMode = false,
    this.maxline,
    this.onChanged, // New add
    // this. textAlign = TextAlign.start, // Default left aligned
  });

  @override
  Widget build(BuildContext context) {
    final labelFontSize = IntakeLayoutTokens.inputFont(context);
    final helperFontSize = IntakeLayoutTokens.smallFont(context);
    final fieldHeight = height ?? IntakeLayoutTokens.inputHeight(context);
    final fieldRadius = IntakeLayoutTokens.inputRadius(context);
    final borderWidth = ResponsiveUtils.scaleWidth(context, 1, min: 1, max: 2);
    final labelSpacing = IntakeLayoutTokens.smallSpacing(context);
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
          // Text Field
          SizedBox(
            height: fieldHeight,
            child: Theme(
              data: ThemeData(
                textSelectionTheme: const TextSelectionThemeData(
                  selectionColor:
                      Color(0xFFB3E0F2), // Light CEO blue for selection
                  selectionHandleColor: AppColors.ceoPrimary,
                ),
              ),
              child: TextFormField(
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                readOnly: displayMode || readOnly,
                cursorColor: AppColors.ceoPrimary,
               maxLines: maxline,
                onChanged: onChanged,
                // textAlign: textAlign, // ✅ Text alignment

                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFBDBDBD),
                  ),
                  prefixText: prefixText,
                  prefixStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF3F3F3F),
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
