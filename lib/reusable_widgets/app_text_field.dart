import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
  });

  final String? label, hint;
  final TextEditingController? controller;
  final Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
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
    );
  }

  OutlineInputBorder textFieldCommonBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}
