// lib/views/search_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();

    return Scaffold(
      // هذا السطر يمنع الكيبورد من الضغط على العناصر بشكل مفاجئ إذا أردت تثبيت الخلفية
      resizeToAvoidBottomInset: true, 
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0a1628), Color(0xFF1a3a5c), Color(0xFF0d2137)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // 💡 هنا تم التعديل لجعل الشاشة قابلة للتمرير وحل مشكلة الخطوط الصفراء
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // ─── Logo & Title ───────────────────────────────────────────
                const Text(
                  '🌤️',
                  style: TextStyle(fontSize: 72),
                ),
                const SizedBox(height: 16),
                const Text(
                  'تطبيق الطقس',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ابحث عن مدينتك لمعرفة حالة الطقس',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 60),

                // ─── Search Field ───────────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'أدخل اسم المدينة...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                    onSubmitted: (value) => controller.fetchWeather(value),
                  ),
                ),

                const SizedBox(height: 16),

                // ─── Error Message ──────────────────────────────────────────
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.redAccent, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              controller.errorMessage.value,
                              style: const TextStyle(
                                  color: Colors.redAccent, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox()),

                const SizedBox(height: 20),

                // ─── Search Button ──────────────────────────────────────────
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller
                                .fetchWeather(controller.searchController.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4fc3f7),
                          foregroundColor: const Color(0xFF0a1628),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xFF0a1628),
                                ),
                              )
                            : const Text(
                                'بحث',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )),

                const SizedBox(height: 50),

                // ─── Popular Cities ─────────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'مدن شائعة',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: ['Riyadh', 'Dubai', 'Cairo', 'London', 'New York', 'Tokyo']
                      .map((city) => GestureDetector(
                            onTap: () {
                              controller.searchController.text = city;
                              controller.fetchWeather(city);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.15)),
                              ),
                              child: Text(
                                city,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24), // مساحة إضافية بالأسفل لتسهيل التمرير
              ],
            ),
          ),
        ),
      ),
    );
  }
}