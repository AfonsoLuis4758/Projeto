import 'package:project/pages/create_account.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/pages/main_page.dart';
import 'package:project/pages/profile_page.dart';
import 'package:project/pages/creation_page.dart';
import 'package:project/pages/item_page.dart';
import 'package:flutter/material.dart';

void main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      routes: {
        "/loginpage": (context) => const LoginPage(),
        "/createaccount": (context) => const CreateAccount(),
        "/mainpage": (context) => const MainPage(),
        "/profilepage": (context) => const ProfilePage(),
        "/creationpage": (context) => const CreationPage(),
        "/itempage": (context) => const ItemPage(),
      },
    );
  }
}
