import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  //MainPage

  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
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
            Image.asset("assets/images/avatar.png"),
            Text("UserName"),
            Text("Email"),
            Text("UserName"),
            Text("Morada:\p Rua morada,71"),
            Text("Género: Masculino"),
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Editar perfil")),
                ElevatedButton(onPressed: () {}, child: Text("Log out")),
              ],
            )
          ]),
    );
  }
}
