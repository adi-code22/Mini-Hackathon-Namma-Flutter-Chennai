import 'package:flutter/material.dart';
import 'package:mini_hack_flutter/screens/alarm_clock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'நம்ம Flutter Alarm Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const AlarmClockScreen(title: 'நம்ம Flutter Alarm Clock'),
    );
  }
}