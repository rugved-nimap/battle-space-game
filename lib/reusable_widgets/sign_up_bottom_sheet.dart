import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/reusable_widgets/app_text_field.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class SignUpBottomSheet extends StatefulWidget {
  const SignUpBottomSheet({super.key, this.register, this.verifyOtp, this.onLoginTap});

  final Future Function(String)? register;
  final Future Function(String, String)? verifyOtp;
  final Function()? onLoginTap;

  @override
  State<SignUpBottomSheet> createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<SignUpBottomSheet> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController otpTextController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  int step = 1;
  bool isLoading = false;

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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey.shade800,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  step == 1 ? "SIGNUP" : "VERIFY-OTP",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                        widget.onLoginTap?.call();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(AssetUtils.loginGif, width: 40, height: 40),
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: step == 1,
              replacement: Pinput(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                length: 6,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                controller: otpTextController,
                defaultPinTheme: PinTheme(decoration: BoxDecoration(color: Colors.blueGrey.shade800, borderRadius: BorderRadius.circular(8)), width: 40, height: 50, textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
              ),
              child: AppTextField(
                controller: emailTextController,
                label: "EMAIL",
                validator: (v) {
                  if (v == null || !v.isEmail) return "Please enter email";
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (step == 1) {
                  if (formKey.currentState?.validate() ?? emailTextController.text.isEmail) {
                    setState(() {
                      isLoading = true;
                    });
                    if (widget.register != null) {
                      await widget.register!(emailTextController.text).then((value) {
                        setState(() {
                          isLoading = false;
                          step = 2;
                        });
                      }, onError: (err) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    }
                  }
                } else {
                  if (otpTextController.text.length == 6) {
                    setState(() {
                      isLoading = true;
                    });
                    await widget.verifyOtp?.call(emailTextController.text, otpTextController.text);
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                backgroundColor: const WidgetStatePropertyAll(Colors.indigoAccent),
                fixedSize: const WidgetStatePropertyAll(Size.fromWidth(double.maxFinite)),
              ),
              child: Visibility(
                visible: isLoading == false,
                replacement: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                child: Text(
                  step == 1 ? "VERIFY EMAIL" : "SUBMIT",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).paddingAll(16);
  }
}
