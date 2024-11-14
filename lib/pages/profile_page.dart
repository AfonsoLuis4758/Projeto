import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            "LusoVest",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Text("PROFILE"),
        ),
      ),
    );
  }
}
