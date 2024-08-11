import 'package:flutter/material.dart';

class WeatherForecastSection extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temp;
  const WeatherForecastSection({
    super.key,
    required this.icon,
    required this.time,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Icon(icon, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              temp,
              style: const TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
    );
  }
}
