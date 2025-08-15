import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_game/repository/app_repository.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';

class GameOverDialog extends StatefulWidget {
  const GameOverDialog({
    super.key,
    this.userId,
    required this.score,
    required this.distance,
    required this.onCancel,
    required this.onRestart,
    required this.onContinue,
  });

  final String? userId;
  final num score;
  final num distance;
  final Function()? onCancel;
  final Function()? onRestart;
  final Function()? onContinue;

  @override
  State<GameOverDialog> createState() => _GameOverDialogState();
}

class _GameOverDialogState extends State<GameOverDialog> {
  final repository = AppRepository();
  bool _isLoading = false;

  List<dynamic> top10 = [];
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    getRank();
  }

  Future<dynamic> getRank() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final result = await repository.getRank(widget.userId, widget.score.toString());
      setState(() {
        _isLoading = false;
      });
      isLogin = result['message'] == "Please login to see the your rank";
      top10 = result['top10'];
    } catch (e) {
      debugPrint("Error in getting rank: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.blueGrey.shade900,
          clipBehavior: Clip.hardEdge,
          type: MaterialType.card,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Game Over",
                style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
              ),
              const Text(
                "Your Score",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
              ),
              Text(
                "${widget.score}",
                style: const TextStyle(fontSize: 46, color: Colors.lightGreen, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
              ),
              Text(
                "Distance: ${widget.distance}",
                style: const TextStyle(fontSize: 16, color: Colors.amber, fontWeight: FontWeight.bold, fontFamily: "Digital7", decoration: TextDecoration.underline, decorationColor: Colors.amber),
              ),
              if (!_isLoading && top10.isNotEmpty) ...{
                Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    spacing: 10,
                    children: [
                      const Text(
                        "Ranks",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 10,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(AssetUtils.avatarList[Random().nextInt(AssetUtils.avatarList.length)]),
                                minRadius: 35,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  "3",
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  top10.length >= 3 ? "${top10[2]['username']}" : "",
                                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(AssetUtils.avatarList[Random().nextInt(AssetUtils.avatarList.length)]),
                                minRadius: 45,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  "1",
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  top10.isNotEmpty ? "${top10[0]['username']}" : "",
                                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(AssetUtils.avatarList[Random().nextInt(AssetUtils.avatarList.length)]),
                                minRadius: 35,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 3, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  "2",
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  top10.length >= 2 ? "${top10[1]['username']}" : "",
                                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 1), borderRadius: BorderRadius.circular(8)),
                        child: ListView.separated(
                          itemCount: top10.length,
                          separatorBuilder: (context, index) {
                            return const Divider(height: 1);
                          },
                          itemBuilder: (context, index) {
                            final user = top10[index];
                            return ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              leading: const Icon(Icons.person_4_rounded, color: Colors.white),
                              title: Text("${user['username']}", style: const TextStyle(color: Colors.white), maxLines: 1),
                              trailing: Text("${user['score']}", style: const TextStyle(color: Colors.white)),
                            );
                          },
                        ),
                      ),
                      const Text(
                        "Please login to see the your rank",
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
                      )
                    ],
                  ),
                ),
              } else ...{
                Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      const Text(
                        "Getting Ranks...",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
                      ),
                      LinearProgressIndicator(
                        backgroundColor: Colors.blueGrey.shade700,
                        color: Colors.indigo,
                      ),
                    ],
                  ),
                ),
              },
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: widget.onCancel,
                      style: FilledButton.styleFrom(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                        backgroundColor: Colors.blueGrey.shade400,
                      ),
                      child: const Text("Cancel", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7")),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: widget.onRestart,
                      style: FilledButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.lightGreen,
                      ),
                      child: const Text("Restart", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7")),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: widget.onContinue,
                      style: FilledButton.styleFrom(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text("Continue", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Digital7")),
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10, vertical: 5)
            ],
          ).paddingOnly(top: 16),
        ).marginSymmetric(horizontal: 20),
      ),
    );
  }
}
