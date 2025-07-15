import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
  });

  final String? label, hint;
  final TextEditingController? controller;
  final Function(dynamic)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText, readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white),
      inputFormatters: [
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.deny(RegExp.escape(r'\s')),
      ],
      decoration: InputDecoration(
        border: textFieldCommonBorder(Colors.indigoAccent.shade100),
        disabledBorder: textFieldCommonBorder(Colors.grey),
        enabledBorder: textFieldCommonBorder(Colors.blueGrey),
        focusedBorder: textFieldCommonBorder(Colors.indigoAccent.shade100),
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.blueGrey),
        floatingLabelStyle: TextStyle(color: Colors.indigoAccent.shade100),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }

  OutlineInputBorder textFieldCommonBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}
