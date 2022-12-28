import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather/pages/home_page.dart';
import 'package:weather/pages/weathers_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => WaterDropMaterialHeader(),
      child: const MaterialApp(
        home: WeathersHome(),
      ),
    );
  }
}

