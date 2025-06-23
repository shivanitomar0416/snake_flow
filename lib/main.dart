import 'package:flutter/material.dart';
import 'package:snake_flow/snakegame.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake_flow',
      debugShowCheckedModeBanner: false,
      home: Snakegamepage(),
    );
  }
}

