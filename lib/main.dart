import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const CirioApp());
}

class CirioApp extends StatelessWidget {
  const CirioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Círio de Nazaré',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}


