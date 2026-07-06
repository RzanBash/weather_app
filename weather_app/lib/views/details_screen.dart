// lib/views/details_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();

    return Obx(() {
      final w = controller.weather.value;
      if (w == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final colors = controller.getTemperatureColors(w.tempC);
      final emoji = controller.getWeatherEmoji(w.condition);
      final localTime = controller.formatLocalTime(w.localTime);

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ─── AppBar Row ───────────────────────────────────────────
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      const Text(
                        'حالة الطقس',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Get.toNamed('/info', arguments: w),
                        icon: const Icon(Icons.info_outline_rounded,
                            color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ─── City & Country ───────────────────────────────────────
                  Text(
                    w.cityName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${w.region.isNotEmpty ? '${w.region}, ' : ''}${w.country}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ─── Main Weather Icon & Temp ─────────────────────────────
                  Text(emoji, style: const TextStyle(fontSize: 90)),
                  const SizedBox(height: 10),
                  Text(
                    '${w.tempC.toStringAsFixed(0)}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    w.condition,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'يشعر كأنه ${w.feelsLikeC.toStringAsFixed(0)}°C',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ─── Local Time & Timezone ────────────────────────────────
                  _infoCard(
                    children: [
                      _infoRow(
                        icon: Icons.access_time_rounded,
                        label: 'التوقيت المحلي',
                        value: localTime,
                      ),
                      _divider(),
                      _infoRow(
                        icon: Icons.public_rounded,
                        label: 'المنطقة الزمنية',
                        value: w.timezone,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ─── Stats Grid ───────────────────────────────────────────
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    // 💡 تم تعديل نسبة الارتفاع والعرض ليعطي مرونة ومساحة إضافية داخل البطاقات تمنع الـ Overflow عمودياً
                    childAspectRatio: 1.35, 
                    children: [
                      _statCard(
                        icon: Icons.water_drop_rounded,
                        label: 'الرطوبة',
                        value: '${w.humidity}%',
                      ),
                      _statCard(
                        icon: Icons.air_rounded,
                        label: 'سرعة الريح',
                        value: '${w.windKph} km/h',
                      ),
                      _statCard(
                        icon: Icons.cloud_rounded,
                        label: 'الغيوم',
                        value: '${w.cloud}%',
                      ),
                      _statCard(
                        icon: Icons.visibility_rounded,
                        label: 'مدى الرؤية',
                        value: '${w.visKm} km',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ─── UV Index ─────────────────────────────────────────────
                  _infoCard(
                    children: [
                      _infoRow(
                        icon: Icons.wb_sunny_rounded,
                        label: 'مؤشر الأشعة فوق البنفسجية (UV)',
                        value: _uvLevel(w.uvIndex),
                      ),
                      _divider(),
                      _infoRow(
                        icon: Icons.thermostat_rounded,
                        label: 'درجة الحرارة بالفهرنهايت',
                        value: '${w.tempF.toStringAsFixed(1)}°F',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ─── Search Again ─────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('بحث عن مدينة أخرى',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ─── Helper Widgets ─────────────────────────────────────────────────────────

  Widget _infoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: Colors.white.withOpacity(0.1), height: 1);
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      // 💡 قمنا بتقليل الـ padding الرأسي قليلاً لضمان عدم ضغط الواجهة في الأجهزة المتوسطة والصغيرة
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white60, size: 22),
          // 💡 تم استخدام Spacer مرن بدلاً من ترك المسافات عشوائية ومحاصرة النصوص
          const Spacer(), 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19, // تعديل دقيق جداً للحجم ليحافظ على رونقه الجمالي
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _uvLevel(double uv) {
    if (uv <= 2) return '${uv.toStringAsFixed(0)} - منخفض';
    if (uv <= 5) return '${uv.toStringAsFixed(0)} - معتدل';
    if (uv <= 7) return '${uv.toStringAsFixed(0)} - مرتفع';
    if (uv <= 10) return '${uv.toStringAsFixed(0)} - مرتفع جداً';
    return '${uv.toStringAsFixed(0)} - شديد';
  }
}