// lib/controllers/weather_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherController extends GetxController {
  // ─── API ───────────────────────────────────────────────────────────────────
  // استبدل بـ API key الخاص بك من weatherapi.com
  static const String _apiKey = 'your Key';
  static const String _baseUrl = 'https://api.weatherapi.com/v1';

  // ─── State ─────────────────────────────────────────────────────────────────
  final Rx<WeatherModel?> weather = Rx<WeatherModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController searchController = TextEditingController();

  // ─── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ─── Methods ───────────────────────────────────────────────────────────────

  /// جلب بيانات الطقس لمدينة معينة
  Future<void> fetchWeather(String city) async {
    if (city.trim().isEmpty) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final uri = Uri.parse(
        '$_baseUrl/current.json?key=$_apiKey&q=${Uri.encodeComponent(city)}&aqi=no',
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        weather.value = WeatherModel.fromJson(data);
        Get.toNamed('/details');
      } else if (response.statusCode == 400) {
        errorMessage.value = 'المدينة غير موجودة، حاول مرة أخرى';
      } else if (response.statusCode == 403) {
        errorMessage.value = 'مفتاح API غير صالح';
      } else {
        errorMessage.value = 'حدث خطأ، حاول مرة أخرى';
      }
    } catch (e) {
      errorMessage.value = 'تعذر الاتصال بالإنترنت';
    } finally {
      isLoading.value = false;
    }
  }

  /// الحصول على أيقونة الطقس بناءً على الحالة
  String getWeatherEmoji(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('sunny') || c.contains('clear')) return '☀️';
    if (c.contains('partly cloudy')) return '⛅';
    if (c.contains('cloudy') || c.contains('overcast')) return '☁️';
    if (c.contains('rain') || c.contains('drizzle')) return '🌧️';
    if (c.contains('snow') || c.contains('blizzard')) return '❄️';
    if (c.contains('thunder') || c.contains('storm')) return '⛈️';
    if (c.contains('fog') || c.contains('mist')) return '🌫️';
    if (c.contains('wind')) return '💨';
    return '🌤️';
  }

  /// تنسيق التاريخ والوقت المحلي
  String formatLocalTime(String rawTime) {
    try {
      final parts = rawTime.split(' ');
      if (parts.length == 2) {
        return '${parts[0]}  •  ${parts[1]}';
      }
      return rawTime;
    } catch (_) {
      return rawTime;
    }
  }

  /// تحديد لون الخلفية بناءً على درجة الحرارة
  List<Color> getTemperatureColors(double temp) {
    if (temp <= 0) {
      return [const Color(0xFF1a237e), const Color(0xFF283593)];
    } else if (temp <= 15) {
      return [const Color(0xFF0d47a1), const Color(0xFF1565c0)];
    } else if (temp <= 25) {
      return [const Color(0xFF1565c0), const Color(0xFF0288d1)];
    } else if (temp <= 35) {
      return [const Color(0xFFe65100), const Color(0xFFf57c00)];
    } else {
      return [const Color(0xFFb71c1c), const Color(0xFFc62828)];
    }
  }
}
