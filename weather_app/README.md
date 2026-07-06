# 🌤️ تطبيق الطقس - Weather App

تطبيق Flutter لعرض بيانات الطقس باستخدام **GetX** لإدارة الحالة و **WeatherAPI** كمصدر للبيانات.

---

## 📁 هيكل المشروع

```
lib/
├── main.dart                    # نقطة البداية + GetMaterialApp + Routes
├── models/
│   └── weather_model.dart       # موديل بيانات الطقس
├── controllers/
│   └── weather_controller.dart  # GetX Controller - إدارة الحالة والـ API
├── bindings/
│   └── weather_binding.dart     # GetX Binding - حقن التبعيات
└── views/
    ├── search_screen.dart       # الواجهة 1: صفحة البحث
    ├── details_screen.dart      # الواجهة 2: تفاصيل الطقس
    └── info_screen.dart         # الواجهة 3: معلومات المدينة
```

---

## 🖥️ الواجهات (3 Screens)

| الواجهة | الوصف |
|---------|-------|
| **Search Screen** | البحث عن المدينة + مدن شائعة |
| **Details Screen** | درجة الحرارة، الرطوبة، الريح، التوقيت المحلي |
| **Info Screen** | الدولة، المنطقة، المنطقة الزمنية، التوقيت |

---

## ⚙️ إعداد المشروع

### 1. الحصول على API Key
- اذهب إلى [weatherapi.com](https://www.weatherapi.com/)
- أنشئ حساباً مجانياً
- انسخ الـ API Key

### 2. إضافة الـ API Key
في ملف `lib/controllers/weather_controller.dart`:
```dart
static const String _apiKey = 'YOUR_API_KEY_HERE'; // ← ضع مفتاحك هنا
```

### 3. تثبيت المكتبات
```bash
flutter pub get
```

### 4. تشغيل التطبيق
```bash
flutter run
```

---

## 📦 المكتبات المستخدمة

| المكتبة | الغرض |
|---------|-------|
| `get: ^4.6.6` | إدارة الحالة والتنقل (GetX) |
| `http: ^1.1.0` | استدعاء الـ API |
| `intl: ^0.18.1` | تنسيق التواريخ |

---

## 🔑 المعلومات المعروضة

- ✅ اسم المدينة
- ✅ الدولة والمنطقة
- ✅ التوقيت المحلي
- ✅ المنطقة الزمنية (timezone)
- ✅ درجة الحرارة (°C و °F)
- ✅ الحالة الجوية + رمز تعبيري
- ✅ الرطوبة، سرعة الريح، مدى الرؤية
- ✅ مؤشر UV، نسبة الغيوم

---

## 🏗️ إدارة الحالة مع GetX

```dart
// في الـ Controller
final Rx<WeatherModel?> weather = Rx<WeatherModel?>(null);
final RxBool isLoading = false.obs;
final RxString errorMessage = ''.obs;

// في الـ UI
Obx(() => controller.isLoading.value
    ? CircularProgressIndicator()
    : Text('${controller.weather.value?.tempC}°C'))
```
