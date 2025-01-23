import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:project/function/dialogue.dart';

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

  List<String> genders = ["Homem", "Mulher"];
  List<String> gendersfromApi = ["male", "female"];
  String ipv4 = "localhost";

  Future apiCall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http.get(
      Uri.parse("http://$ipv4:5000/user/$email"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401 && prefs.getString('token') != null) {
      await prefs.clear();
      await showMyDialog(context);
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: Colors.green[800],
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
                    height: 250.0,
                  );
                }

                // Display the fetched data
                return ListView(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: image),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 12),
                    child: Text(snapshot.data["username"],
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(snapshot.data["email"],
                        style: TextStyle(fontSize: 24)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Morada: " + snapshot.data['address'],
                        style: TextStyle(fontSize: 24)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                        "Género: " +
                            genders[gendersfromApi
                                .indexOf(snapshot.data['gender'])],
                        style: TextStyle(fontSize: 24)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/cartpage", arguments: {
                          "section": "wishlist",
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          height: 50,
                          child: const Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Ir para wishlist',
                                style: TextStyle(fontSize: 20),
                              )),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 8, bottom: 64),
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
                                child: Text("Editar perfil",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20))),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 24, bottom: 64),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () async {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('token');
                                  prefs.remove('email');
                                  prefs.remove('role');
                                  prefs.remove('gender');
                                  Navigator.pushNamed(context, "/mainpage");
                                },
                                child: Text("Log out",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20))),
                          ),
                        ),
                      ],
                    ),
                  )
                ]);
              }
            }));
  }
}
