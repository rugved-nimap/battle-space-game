import 'package:flutter/material.dart';
import 'package:flutter_game/reusable_widgets/app_text_field.dart';
import 'package:get/get.dart';

class AddUserBottomSheet extends StatefulWidget {
  const AddUserBottomSheet({
    super.key,
    required this.email,
    required this.addUserApi,
  });

  final String email;
  final Future Function(String, String, String)? addUserApi;

  @override
  State<AddUserBottomSheet> createState() => _AddUserBottomSheetState();
}

class _AddUserBottomSheetState extends State<AddUserBottomSheet> {
  final TextEditingController passTextController = TextEditingController();
  final TextEditingController usernameTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Container(
              width: 60,
              height: 8,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blueGrey.shade800),
            ),
            const Text(
              "USER DETAILS",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
            ),
            AppTextField(
              readOnly: true,
              controller: TextEditingController(text: widget.email),
              label: "EMAIL",
            ),
            AppTextField(
              controller: passTextController,
              label: "PASSWORD",
              obscureText: true,
              validator: (v) {
                if (v == null || v.trim().isEmpty || v.isEmpty) return "Please enter password";
                return null;
              },
            ),
            AppTextField(
              controller: usernameTextController,
              label: "USERNAME",
              validator: (v) {
                if (v == null || v.trim().isEmpty || v.isEmpty) return "Please enter username";
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? (passTextController.text.trim().isNotEmpty || usernameTextController.text.trim().isNotEmpty)) {
                  widget.addUserApi?.call(widget.email, passTextController.text, usernameTextController.text);
                }
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                backgroundColor: const WidgetStatePropertyAll(Colors.indigoAccent),
                fixedSize: const WidgetStatePropertyAll(Size.fromWidth(double.maxFinite)),
              ),
              child: const Text(
                "SUBMIT",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    ).paddingAll(16);
  }
}
