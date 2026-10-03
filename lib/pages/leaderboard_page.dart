import 'package:flutter/material.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/repository/app_repository.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';

/// Top 10 players, opened from the home page.
/// Uses the same ranking API as the game over dialog, with the player's best score.
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final controller = Get.find<GlobalController>();

  bool _loading = true;
  String? _error;
  List<dynamic> _top10 = [];
  bool _needsLogin = false;
  dynamic _myRank;

  static const _gold = Color(0xFFFFD700);
  static const _silver = Color(0xFFC0C0C0);
  static const _bronze = Color(0xFFCD7F32);

  @override
  void initState() {
    super.initState();
    _load(silent: true); // _loading already starts as true
  }

  /// [silent] keeps the current list on screen (used by pull-to-refresh).
  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final result = await AppRepository.getRank(controller.userId, controller.highScore.toString());
      if (!mounted) return;
      setState(() {
        _top10 = (result is Map && result['top10'] is List) ? result['top10'] : [];
        _needsLogin = result is Map && result['message'] == "Please login to see the your rank";
        // The server may or may not send the player's own rank; show it if it does.
        _myRank = result is Map ? (result['rank'] ?? result['userRank'] ?? result['position']) : null;
        _error = null;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Error loading leaderboard: $e");
      if (!mounted) return;
      setState(() {
        _error = "Couldn't load the leaderboard.\nCheck your connection and try again.";
        _loading = false;
      });
    }
  }

  bool _isMe(dynamic user) {
    if (user is! Map) return false;
    final id = controller.userId;
    if (id != null && (user['_id'] == id || user['userId'] == id)) return true;
    return user['username'] == controller.userName;
  }

  String _initial(dynamic user) {
    final name = user is Map ? "${user['username'] ?? ''}" : "";
    return name.isEmpty ? "?" : name[0].toUpperCase();
  }

  String _field(dynamic user, String key) => user is Map ? "${user[key] ?? ''}" : "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.asset(AssetUtils.background, fit: BoxFit.cover, height: double.infinity, width: double.infinity),
          Container(color: Colors.black.withValues(alpha: 0.45)),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        "LEADERBOARD",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ).paddingSymmetric(horizontal: 4, vertical: 8),
                _myCard(),
                const SizedBox(height: 16),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _load(silent: true),
                    child: _body(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.indigoAccent),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueGrey.withValues(alpha: 0.5),
            backgroundImage: AssetImage(controller.userAvatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "BEST: ${controller.highScore}",
                  style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (_myRank != null)
            Text(
              "#$_myRank",
              style: const TextStyle(color: _gold, fontSize: 30, fontWeight: FontWeight.bold, fontFamily: "Digital7"),
            )
          else if (_needsLogin)
            TextButton(
              onPressed: controller.loginBottomSheet,
              child: const Text("Log in\nfor your rank", textAlign: TextAlign.center, style: TextStyle(color: _gold)),
            ),
        ],
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    // ListView everywhere below, so pull-to-refresh always works.
    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(onPressed: () => _load(), child: const Text("Retry")),
          ),
        ],
      );
    }

    if (_top10.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 80),
          Text(
            "No scores yet.\nPlay a game and be the first!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _podium(),
        const SizedBox(height: 16),
        for (int i = 3; i < _top10.length; i++) _row(i, _top10[i]),
      ],
    );
  }

  Widget _podium() {
    Widget spot(int index, double height, Color color) {
      if (index >= _top10.length) return const Expanded(child: SizedBox());
      final user = _top10[index];
      final first = index == 0;
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: first ? 30 : 24,
              backgroundColor: color,
              child: Text(
                _initial(user),
                style: TextStyle(fontSize: first ? 24 : 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _field(user, 'username'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _isMe(user) ? Colors.amberAccent : Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              _field(user, 'score'),
              style: const TextStyle(color: Colors.white70, fontSize: 18, fontFamily: "Digital7"),
            ),
            const SizedBox(height: 6),
            Container(
              height: height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Text(
                "${index + 1}",
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: "Digital7"),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 6),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        spot(1, 70, _silver),
        spot(0, 100, _gold),
        spot(2, 50, _bronze),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget _row(int index, dynamic user) {
    final me = _isMe(user);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: me ? Colors.indigo.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: me ? Border.all(color: Colors.amberAccent) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              "${index + 1}",
              style: const TextStyle(color: Colors.white70, fontSize: 20, fontFamily: "Digital7"),
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blueGrey,
            child: Text(_initial(user), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _field(user, 'username'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: me ? Colors.amberAccent : Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            _field(user, 'score'),
            style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Digital7"),
          ),
        ],
      ),
    );
  }
}
