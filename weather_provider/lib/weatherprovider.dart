import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class WeatherProvider with ChangeNotifier {
  String _desc = "";
  String get desc => _desc;

  void getProvider(String location) async {
    var apiid = "15de80e1abffb64ec7d59b4432709513";
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiid&units=metric');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      var temperature = parsedData['main']['temp'];
      var humidity = parsedData['main']['humidity'];
      var loc = parsedData['name'];
      var weather = parsedData['weather'][0]['main'];
      _desc = "Current weather data in " +
          loc.toString() +
          " is " +
          weather.toString() +
          " with temperature of " +
          temperature.toString() +
          " celcius and " +
          humidity.toString() +
          "% humidity";
      notifyListeners();
    }
  }
}
