import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  //MainPage

  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Widget image = Image.asset(
    "assets/images/avatar.png",
    height: 150.0,
    width: 100.0,
  );

  Future apiCall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http.get(
      Uri.parse("http://localhost:5000/user/$email"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }

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
        body: FutureBuilder(
            future: apiCall(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data["image"] != "") {
                  image = Image.memory(
                    base64Decode(snapshot.data["image"].replaceAll("-", "/")),
                    height: 200.0,
                  );
                }

                // Display the fetched data
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: image),
                      Text(snapshot.data["username"]),
                      Text(snapshot.data["email"]),
                      Text("Morada: " + snapshot.data['address']),
                      Text("Género: " + snapshot.data['gender']),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "/editprofilepage",
                                      arguments: {
                                        "username": snapshot.data["username"],
                                        "address": snapshot.data["address"],
                                        "gender": snapshot.data["gender"]
                                      });
                                },
                                child: Text("Editar perfil")),
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {}, child: Text("Log out")),
                          ),
                        ],
                      )
                    ]);
              }
            }));
  }
}
