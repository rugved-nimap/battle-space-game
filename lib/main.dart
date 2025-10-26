import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/binders/global_binder.dart';
import 'package:flutter_game/network/api_client.dart';
import 'package:flutter_game/pages/home_page.dart';
import 'package:flutter_game/repository/app_repository.dart';
import 'package:flutter_game/services/google_ads_service.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:flutter_game/utils/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await initializedDependencies();
  runApp(const MyApp());
}

Future<void> initializedDependencies() async {
  ApiClient.instance.init();

  // TODO: Called this to start the server.
  try {
    AppRepository.getUser();
  } catch (e) {
    debugPrint("$e");
  }

  try {
    await GetStorage.init(StorageKey.storageName);
    await GoogleAdsService.instance.initialize();
  } catch (err) {
    debugPrint("Error in starting the app: $err");
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
