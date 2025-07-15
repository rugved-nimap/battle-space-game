import 'package:flutter/material.dart';
import 'package:flutter_game/reusable_widgets/app_text_field.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';

class UserProfileDialog extends StatefulWidget {
  const UserProfileDialog({
    super.key,
    required this.userName,
    required this.userAvatar,
    this.showDiscardBtn = true,
  });

  final String userName;
  final String userAvatar;
  final bool showDiscardBtn;

  @override
  State<UserProfileDialog> createState() => _UserProfileDialogState();
}

class _UserProfileDialogState extends State<UserProfileDialog> {
  final TextEditingController textEditingController = TextEditingController();
  late String selected;

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.userName;
    selected = widget.userAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 25,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(selected),
          radius: 40,
        ),
        Container(
          height: 50,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blueGrey.shade50.withValues(alpha: 0.1),
          ),
          padding: const EdgeInsets.all(8),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: AssetUtils.avatarList.length,
            itemBuilder: (context, index) {
              final avatar = AssetUtils.avatarList[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    selected = avatar;
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage(AssetUtils.avatarList[index])),
                    border: selected.isCaseInsensitiveContains(avatar) ? Border.all(color: Colors.white, width: 2) : null,
                  ),
                ),
              );
            },
          ),
        ),
        AppTextField(
          controller: textEditingController,
          label: "USERNAME",
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Visibility(
              visible: widget.showDiscardBtn,
              child: Expanded(
                child: ElevatedButton(
                  onPressed: Get.back,
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    backgroundColor: const WidgetStatePropertyAll(Colors.redAccent),
                  ),
                  child: const Text(
                    "Discard",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (textEditingController.text.isNotEmpty) {
                    Get.back(result: {
                      "userName": textEditingController.text,
                      "userAvatar": selected,
                    });
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: const WidgetStatePropertyAll(Colors.indigoAccent),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
