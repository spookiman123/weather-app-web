import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/weather_service.dart';

class WeatherDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('7-Day Forecast'),
        backgroundColor: Colors.lightBlue,
      ),
      body: weatherService.forecast != null
          ? ListView.builder(
        itemCount: weatherService.forecast!.length,
        itemBuilder: (context, index) {
          final forecastData = weatherService.forecast![index];
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Image.asset(forecastData['icon'], height: 50),
              title: Text(
                forecastData['dateTime'],
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                '${forecastData['temp']} - ${forecastData['description']}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          );
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
