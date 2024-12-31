import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/color_constants.dart';
import 'core/routes/router.dart';
import 'features/home/views/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Palette.lightTheme, // Specify the light theme
      darkTheme: Palette.darkTheme, // Specify the dark theme
      themeMode: ThemeMode.system, // Use system theme mode (light/dark)
      debugShowCheckedModeBanner: false,
      getPages: Routes.routes,
      home: HomePage()
    );
  }
}