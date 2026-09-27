import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SystemBuilderApp());
}

class SystemBuilderApp extends StatelessWidget {
  const SystemBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Toplama Sihirbazı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050505),
        primaryColor: Colors.blueAccent,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}