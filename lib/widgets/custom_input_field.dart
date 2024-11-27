import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.required,
    this.validationText,
  });
  final String label;
  final TextEditingController controller;
  final String? validationText;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TextFormField(
      maxLines: null,
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        label: Text(label),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
          borderSide: BorderSide(
            color: Theme.of(context)
                .primaryColor, // Change the border color when focused
            width: 2.0, // Adjust the width as needed
          ),
        ),
      ),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Please enter your $validationText.';
        }
        return null;
      },
    );
  }
}
