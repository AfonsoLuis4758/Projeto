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
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black
                ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/loginpage");
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontSize: 24),
                  )),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                    "Faça log in para comprar artigos e outras funcionalidades", 
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,),
              )
            ]),
      ),
    );
  }
}
