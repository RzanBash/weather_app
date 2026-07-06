// lib/views/info_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/weather_model.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherModel w = Get.arguments as WeatherModel;

    return Scaffold(
      backgroundColor: const Color(0xFF0a1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'معلومات المدينة',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // ─── Header ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1565c0), Color(0xFF0288d1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.location_city_rounded,
                    color: Colors.white, size: 48),
                const SizedBox(height: 12),
                Text(
                  w.cityName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  w.country,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ─── Info List ────────────────────────────────────────────────
          _sectionTitle('بيانات الموقع'),
          const SizedBox(height: 12),

          _infoTile(
            icon: Icons.flag_rounded,
            iconColor: const Color(0xFF42a5f5),
            title: 'الدولة',
            subtitle: w.country,
          ),
          _infoTile(
            icon: Icons.map_rounded,
            iconColor: const Color(0xFF66bb6a),
            title: 'المنطقة / الإقليم',
            subtitle: w.region.isNotEmpty ? w.region : 'غير متاح',
          ),
          _infoTile(
            icon: Icons.public_rounded,
            iconColor: const Color(0xFFffa726),
            title: 'المنطقة الزمنية',
            subtitle: w.timezone,
          ),
          _infoTile(
            icon: Icons.access_time_filled_rounded,
            iconColor: const Color(0xFFef5350),
            title: 'التوقيت المحلي',
            subtitle: w.localTime,
          ),

          const SizedBox(height: 24),
          _sectionTitle('حالة الطقس الحالية'),
          const SizedBox(height: 12),

          _infoTile(
            icon: Icons.thermostat_rounded,
            iconColor: const Color(0xFF42a5f5),
            title: 'درجة الحرارة',
            subtitle: '${w.tempC}°C  |  ${w.tempF}°F',
          ),
          _infoTile(
            icon: Icons.cloud_rounded,
            iconColor: const Color(0xFF78909c),
            title: 'الحالة الجوية',
            subtitle: w.condition,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        textDirection: TextDirection.rtl, // اتجاه العناصر من اليمين لليسار
        children: [
          // الأيقونة في جهة اليمين (تبدأ أولاً في الـ RTL)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16), // مسافة أمنة بعد الأيقونة مباشرة
          
          // النصوص تأخذ المساحة المتبقية بالكامل وتمنع الأوفرفلو
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // يبدأ من اليمين بسبب الـ RTL للـ Row الداكن
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}