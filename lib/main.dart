import 'package:project/pages/firstPage.dart';
import 'package:project/pages/secondPage.dart';
import 'package:flutter/material.dart';

void main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirstPage(),
      routes: {
        "/firstpage": (context) => const FirstPage(),
        "/secondpage": (context) => const SecondPage(),
      },
    );
  }
}
