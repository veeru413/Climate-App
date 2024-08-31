import 'package:climate_app/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:climate_app/utilities/constants.dart';
import 'package:climate_app/services/weather.dart';
import 'package:climate_app/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen(this.locationweather);

  final locationweather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  var temperature;
  var conditionalnumber;
  var cityname;
  var emoji;
  var message;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationweather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        message = 'Unable to get Weather Data';
        emoji = 'Error';
        cityname = '';
        return;
      }
      var temp = weatherData['main']['temp'];
      temperature = temp
          .toInt(); // Assuming temperature is a double, convert it to an integer
      conditionalnumber = weatherData['weather'][0]['id'];
      cityname = weatherData['name'];
      emoji = weather.getWeatherIcon(conditionalnumber);
      message = weather.getMessage(temperature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      if(typedName!=null)
                        {
                         var weatherData = await weather.getCityweather(typedName);
                         updateUI(weatherData);
                        }
                    },
                    child: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°', // Font applied
                      style: GoogleFonts.nerkoOne(
                        fontSize: 150.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      emoji,
                      style: GoogleFonts.nerkoOne(
                        fontSize: 100.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $cityname!", // Font applied
                  textAlign: TextAlign.right,
                  style: GoogleFonts.nerkoOne(
                    fontSize: 60.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
