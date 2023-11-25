import 'package:covid_tracker/resources/color.dart';
import 'package:flutter/material.dart';

class InputTextFormField extends StatelessWidget {
  const InputTextFormField({
    Key? key,
    required this.myController,
    required this.focusNode,
    required this.onFiledSubmittedValue,
    required this.decoration,
    required this.keyboardType,
    required this.obscureText,
    required this.hint,
    required this.onValidator,
    this.enable = true,
    this.autoFocus = false,
    this.maxLines = 1,
    this.icon,
  }) : super(key: key);

  final TextEditingController myController;
  final int maxLines;
  final FocusNode focusNode;
  final FormFieldSetter onFiledSubmittedValue;
  final FormFieldValidator onValidator;
  final decoration;
  final Icon? icon;
  final TextInputType keyboardType;
  final String hint;
  final bool obscureText;
  final bool enable, autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      focusNode: focusNode,
      onFieldSubmitted: onFiledSubmittedValue,
      validator: onValidator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hint,
        prefixIcon: icon,
        contentPadding: EdgeInsets.all(15),
        hintStyle: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(height: 0, color: AppColors.primaryTextTextColor.withOpacity(0.8)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryMaterialColor),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryMaterialColor),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryMaterialColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
