import 'package:cashense/flavors/flavor_config.dart';
import 'package:flutter/material.dart';

class BiometricsPage extends StatelessWidget {
  const BiometricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade100,
      body: Center(child: Text(FlavorConfig.instance.name)),
    );
  }
}
