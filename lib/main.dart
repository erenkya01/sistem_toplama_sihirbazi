import 'package:flutter/material.dart';
// Yeni menü sayfamızın dosya yolunu import ediyoruz
import 'screens/main_menu.dart';

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
      // BURASI DEĞİŞTİ: Uygulamanın ana kapısı artık alt menülü sayfamız
      home: const MainMenuScreen(),
    );
  }
}
