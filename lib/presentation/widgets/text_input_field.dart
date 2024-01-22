import 'package:flutter/material.dart';


class FormInputField extends StatelessWidget {
  const FormInputField({
    Key? key,
    required this.controller,
    required this.prefixText,
    required this.validator,
    this.hintText = '',
    this.obscure,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text, this.color,
  }) : super(key: key);

  final TextEditingController controller;
  final String prefixText;
  final String hintText;
  final bool? obscure;
  final Color? color;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure ?? false,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: color ?? Colors.grey,
          fontSize: 12,
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                prefixText,
                style: TextStyle(
                  fontSize: 20,
                  color: color ?? Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: color ?? Colors.white38,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color ?? Colors.white,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color ?? Colors.white,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        contentPadding: const EdgeInsets.all(18),
      ),
      //textDirection: appLanguage.isEn ? TextDirection.ltr : TextDirection.rtl,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: color ?? Colors.white,
        fontSize: 16,
      ),
    );
  }
}
