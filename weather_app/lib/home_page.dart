import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'weather_detail_page.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherService = Provider.of<WeatherService>(context);
    final locationService = Provider.of<LocationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Forecast'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          IconButton(
            icon: Icon(Icons.contact_mail),
            onPressed: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Image.asset('assets/new_logo.png', height: 100),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      weatherService.setLoading(true);
                      try {
                        await weatherService.fetchWeatherByCity(_searchController.text);
                      } catch (e) {
                        weatherService.setErrorMessage(e.toString());
                      } finally {
                        weatherService.setLoading(false);
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (weatherService.isLoading)
              CircularProgressIndicator(),
            if (weatherService.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  weatherService.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (weatherService.cityName != null && weatherService.errorMessage == null)
              Card(
                margin: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      if (weatherService.weatherIcon != null)
                        Image.asset(weatherService.weatherIcon!, height: 100),
                      SizedBox(height: 10),
                      Text(
                        weatherService.cityName!,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Temperature: ${weatherService.temperature ?? '--°C'}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Description: ${weatherService.description ?? 'Loading...'}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Wind Speed: ${weatherService.windSpeed?.toStringAsFixed(1) ?? '--'} m/s',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Humidity: ${weatherService.humidity ?? '--'}%',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Pressure: ${weatherService.pressure?.toStringAsFixed(1) ?? '--'} hPa',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await weatherService.fetchForecastByCity(weatherService.cityName!);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherDetailPage()),
                );
              },

              child: Text('See next 7 days'),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await locationService.getCurrentLocation();
            await weatherService.fetchWeather(
                locationService.latitude!, locationService.longitude!);
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to get location or weather data'),
              ),
            );
          }
        },
        child: Image.asset('assets/location.png', height: 30, width: 30),
        mini: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
