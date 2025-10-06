import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/binders/global_binder.dart';
import 'package:flutter_game/network/api_client.dart';
import 'package:flutter_game/pages/home_page.dart';
import 'package:flutter_game/repository/app_repository.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:flutter_game/utils/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  ApiClient.instance.init();
  try {
    await GetStorage.init(StorageKey.storageName);
    await MobileAds.instance.initialize();
  } catch (err) {
    debugPrint("Error in starting the app: $err");
  }
  runApp(const MyApp());

  // TODO: Called this to start the server.
  try {
    AppRepository.getUser();
  } catch (e) {
    debugPrint("$e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Battle Space",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      initialBinding: GlobalBinder(),
      home: const HomePage(),
    );
  }
}
