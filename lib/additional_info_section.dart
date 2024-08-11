import 'package:flutter/material.dart';

class AdditionalInfoSection extends StatelessWidget {
  final IconData icons;
  final String forecast;
  final String value;
  const AdditionalInfoSection({
    super.key,
    required this.icons,
    required this.forecast,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icons, size: 36),
        const SizedBox(height: 10),
        Text(
          forecast,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )
      ],
    );
  }
}
