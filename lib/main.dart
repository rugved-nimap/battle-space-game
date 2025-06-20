import 'package:flutter/material.dart';
import 'package:flutter_game/binders/global_binder.dart';
import 'package:flutter_game/pages/page1.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(StorageKey.storageName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Game",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialBinding: GlobalBinder(),
      home: const Page1()
    );
  }
}
