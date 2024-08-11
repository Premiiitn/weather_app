import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/additional_info_section.dart';
import 'package:weather/confi.dart';
import 'package:weather/weather_forecast_section.dart';

class WeatherAppPage extends StatefulWidget {
  const WeatherAppPage({super.key});

  @override
  State<WeatherAppPage> createState() => _WeatherAppPageState();
}

class _WeatherAppPageState extends State<WeatherAppPage> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> extractor() async {
    String cityname = 'Nagpur';
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityname,india&APPID=$apikey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'Unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = extractor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  weather = extractor();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            final data = snapshot.data!;
            final common = data['list'][0]['main'];
            double temp = common['temp'];
            temp = temp - 273.15;
            final humidity = common['humidity'];
            final pressure = common['pressure'];
            final wind = data['list'][0]['wind']['speed'];
            final icond = data['list'][0]['weather'][0]['main'];
            // List<double> t = List.filled(5, 0.0);
            // List icd = List.filled(5, null);
            // for (int i = 1; i < 6; i++) {
            //   t[i - 1] = data['list'][i]['main']['temp'] - 273.15;
            //   icd[i - 1] = data['list'][i]['weather'][0]['main'];
            // }
            IconData getIconData(int i) {
              final hrlyfr = data['list'][i]['weather'][0]['main'];
              if (hrlyfr == 'Clouds') {
                return Icons.cloud;
              } else if (hrlyfr == 'Rain') {
                return Icons.water;
              } else if (hrlyfr == 'Clear') {
                return Icons.sunny;
              }

              return Icons.error;
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(children: [
                                Text(
                                  '${temp.toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Icon(
                                    icond == 'Clouds'
                                        ? Icons.cloud
                                        : icond == 'Rainy'
                                            ? Icons.water
                                            : icond == 'Clear'
                                                ? Icons.sunny
                                                : null,
                                    size: 70),
                                const SizedBox(height: 10),
                                Text(
                                  '$icond',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hourly Forecast',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       WeatherForecastSection(
                    //           icon: getIconData(icd, 0),
                    //           temp: t.isNotEmpty
                    //               ? '${t[0].toStringAsFixed(1)}°C'
                    //               : '',
                    //           time: '09:00'),
                    //       WeatherForecastSection(
                    //           icon: getIconData(icd, 1),
                    //           temp: t.isNotEmpty
                    //               ? '${t[1].toStringAsFixed(1)}°C'
                    //               : '',
                    //           time: '12:00'),
                    //       WeatherForecastSection(
                    //           icon: getIconData(icd, 2),
                    //           temp: t.isNotEmpty
                    //               ? '${t[2].toStringAsFixed(1)}°C'
                    //               : '',
                    //           time: '15:00'),
                    //       WeatherForecastSection(
                    //           icon: getIconData(icd, 3),
                    //           temp: t.isNotEmpty
                    //               ? '${t[3].toStringAsFixed(1)}°C'
                    //               : '',
                    //           time: '18:00'),
                    //       WeatherForecastSection(
                    //           icon: getIconData(icd, 4),
                    //           temp: t.isNotEmpty
                    //               ? '${t[4].toStringAsFixed(1)}°C'
                    //               : '',
                    //           time: '21:00'),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final hrlyfr = data['list'][index + 2];
                            final dt =
                                DateTime.parse(hrlyfr['dt_txt'].toString());
                            final tmp = (hrlyfr['main']['temp'] - 273.15)
                                .toStringAsFixed(1);
                            return WeatherForecastSection(
                                icon: getIconData(index + 2),
                                time: DateFormat.j().format(dt).toString(),
                                temp: '$tmp°C');
                          }),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfoSection(
                          icons: Icons.water_drop,
                          forecast: 'Humidity',
                          value: '$humidity',
                        ),
                        AdditionalInfoSection(
                          icons: Icons.air,
                          forecast: 'Wind Speed',
                          value: '$wind ',
                        ),
                        AdditionalInfoSection(
                          icons: Icons.beach_access,
                          forecast: 'Pressure',
                          value: '$pressure',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
