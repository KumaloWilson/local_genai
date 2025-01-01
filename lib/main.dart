// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_gen_ai/core/utils/logs.dart';
import 'bindings/binding.dart';
import 'core/constants/color_constants.dart';
import 'core/routes/router.dart';
import 'features/home/views/home_page.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await InitialBinding().dependencies();
    runApp(const MyApp());
  } catch (e) {
    DevLogs.logError('Initialization error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Model Manager',
      initialBinding: InitialBinding(), // Set initial binding
      theme: Palette.lightTheme,
      darkTheme: Palette.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      getPages: Routes.routes,
      home: const HomePage(),
    );
  }
}