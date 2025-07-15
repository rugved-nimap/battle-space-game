
import 'package:flutter/material.dart';
import 'package:flutter_game/reusable_widgets/app_text_field.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key, this.onSignUpTap});

  final Function()? onSignUpTap;

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: InkWell(
                onTap: () {
                  Get.back();
                  widget.onSignUpTap?.call();
                },
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(AssetUtils.signUpGif, width: 40, height: 40),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Container(
                  width: 60,
                  height: 8,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blueGrey.shade800),
                ),
                const Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                ),
                AppTextField(
                  controller: emailTextController,
                  label: "EMAIL",
                  validator: (v) {
                    if (v == null || !v.isEmail) return "Please enter email";
                    return null;
                  },
                ),
                AppTextField(
                  controller: passTextController,
                  label: "PASSWORD",
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Please enter password";
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? (emailTextController.text.isEmail || passTextController.text.isNotEmpty)) {
                      Get.back(result: {
                        "email": emailTextController.text,
                        "password": passTextController.text,
                      });
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    backgroundColor: const WidgetStatePropertyAll(Colors.indigoAccent),
                    fixedSize: const WidgetStatePropertyAll(Size.fromWidth(double.maxFinite)),
                  ),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).paddingAll(16);
  }
}
