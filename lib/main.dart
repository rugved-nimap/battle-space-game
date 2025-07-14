import 'package:flutter/material.dart';
import 'package:flutter_game/binders/global_binder.dart';
import 'package:flutter_game/network/api_client.dart';
import 'package:flutter_game/pages/home_page.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:flutter_game/utils/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(StorageKey.storageName);
  ApiClient.instance.init();
  runApp(const MyApp());
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
