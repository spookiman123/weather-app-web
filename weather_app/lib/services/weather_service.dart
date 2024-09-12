import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService extends ChangeNotifier {
  String? temperature;
  String? description;
  String? cityName;
  String? weatherIcon;
  double? windSpeed;
  int? humidity;
  double? pressure;
  List<Map<String, dynamic>>? forecast;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchWeather(double lat, double lon) async {
    final apiKey = '318b659690d7d71052fdd88d447dfd7d';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        temperature = '${data['main']['temp']}°C';
        description = data['weather'][0]['description'];
        cityName = data['name'];
        weatherIcon = getWeatherIcon(data['weather'][0]['main']);
        windSpeed = (data['wind']['speed'] as num).toDouble();
        humidity = data['main']['humidity'];
        pressure = (data['main']['pressure'] as num).toDouble();
        errorMessage = null;
        notifyListeners();
      } else {
        errorMessage = 'Failed to load weather data';
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Failed to load weather data: $e';
      notifyListeners();
    }
  }


  Future<void> fetchForecast(double lat, double lon) async {
    final apiKey = '318b659690d7d71052fdd88d447dfd7d';
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        forecast = (data['list'] as List).map((item) {
          final dateTime = item['dt_txt'].substring(0, 16);
          final temp = item['main']['temp'];
          final description = item['weather'][0]['description'];
          final icon = getWeatherIcon(item['weather'][0]['main']);
          return {
            'dateTime': dateTime,
            'temp': '$temp°C',
            'description': description,
            'icon': icon
          };
        }).toList();
        errorMessage = null;
        notifyListeners();
      } else {
        errorMessage = 'Failed to load forecast data';
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Failed to load forecast data: $e';
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    final apiKey = '318b659690d7d71052fdd88d447dfd7d';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        temperature = '${data['main']['temp']}°C';
        description = data['weather'][0]['description'];
        cityName = data['name'];
        weatherIcon = getWeatherIcon(data['weather'][0]['main']);
        windSpeed = (data['wind']['speed'] as num).toDouble();
        humidity = data['main']['humidity'];
        pressure = (data['main']['pressure'] as num).toDouble();
        errorMessage = null;
        notifyListeners();
      } else {
        errorMessage = 'Failed to load weather data';
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Failed to load weather data: $e';
      notifyListeners();
    }
  }

  Future<void> fetchForecastByCity(String city) async {
    final apiKey = '318b659690d7d71052fdd88d447dfd7d';
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        forecast = (data['list'] as List).map((item) {
          final dateTime = item['dt_txt'].substring(0, 16);
          final temp = item['main']['temp'];
          final description = item['weather'][0]['description'];
          final icon = getWeatherIcon(item['weather'][0]['main']);
          return {
            'dateTime': dateTime,
            'temp': '$temp°C',
            'description': description,
            'icon': icon
          };
        }).toList();
        errorMessage = null;
        notifyListeners();
      } else {
        errorMessage = 'Failed to load forecast data';
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Failed to load forecast data: $e';
      notifyListeners();
    }
  }

  String getWeatherIcon(String weatherDescription) {
    switch (weatherDescription.toLowerCase()) {
      case 'clear':
        return 'assets/sunny.png';
      case 'clouds':
        return 'assets/cloudy.png';
      case 'rain':
        return 'assets/rainy.png';
      case 'snow':
        return 'assets/snowy.png';
      case 'thunderstorm':
        return 'assets/thunderstorm.png';
      default:
        return 'assets/clear.png';
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }
}
