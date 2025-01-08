import 'package:flutter/material.dart';

class UnloggedPage extends StatelessWidget {
  const UnloggedPage({super.key});
  //MainPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.green,
        title: const Text(
          "LusoVest",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/loginpage");
                },
                child: const Text(
                  "Log In",
                  style: TextStyle(fontSize: 24),
                )),
            const Text(
                "Faça log in para comprar artigos e outras funcionalidades")
          ]),
    );
  }
}
