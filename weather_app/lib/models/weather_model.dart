// lib/models/weather_model.dart

class WeatherModel {
  final String cityName;
  final String country;
  final String region;
  final String timezone;
  final String localTime;
  final double tempC;
  final double tempF;
  final String condition;
  final String conditionIcon;
  final int humidity;
  final double windKph;
  final double feelsLikeC;
  final int cloud;
  final double uvIndex;
  final double visKm;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.region,
    required this.timezone,
    required this.localTime,
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.conditionIcon,
    required this.humidity,
    required this.windKph,
    required this.feelsLikeC,
    required this.cloud,
    required this.uvIndex,
    required this.visKm,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'] ?? '',
      country: json['location']['country'] ?? '',
      region: json['location']['region'] ?? '',
      timezone: json['location']['tz_id'] ?? '',
      localTime: json['location']['localtime'] ?? '',
      tempC: (json['current']['temp_c'] ?? 0).toDouble(),
      tempF: (json['current']['temp_f'] ?? 0).toDouble(),
      condition: json['current']['condition']['text'] ?? '',
      conditionIcon: json['current']['condition']['icon'] ?? '',
      humidity: json['current']['humidity'] ?? 0,
      windKph: (json['current']['wind_kph'] ?? 0).toDouble(),
      feelsLikeC: (json['current']['feelslike_c'] ?? 0).toDouble(),
      cloud: json['current']['cloud'] ?? 0,
      uvIndex: (json['current']['uv'] ?? 0).toDouble(),
      visKm: (json['current']['vis_km'] ?? 0).toDouble(),
    );
  }
}
