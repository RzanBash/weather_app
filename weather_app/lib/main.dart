// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'bindings/weather_binding.dart';
import 'views/search_screen.dart';
import 'views/details_screen.dart';
import 'views/info_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'تطبيق الطقس',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      textDirection: TextDirection.rtl,
      initialBinding: WeatherBinding(),
      initialRoute: '/search',
      getPages: [
        GetPage(name: '/search', page: () => const SearchScreen()),
        GetPage(name: '/details', page: () => const DetailsScreen()),
        GetPage(name: '/info', page: () => const InfoScreen()),
      ],
    );
  }
}
