import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});
  @override
  State<CreateAccount> createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {
  String userName = '';
  String email = '';
  String passWord = '';
  String gender = '';
  String address = '';
  String token = "";
  List<String> genders = ["Homem", "Mulher"];
  List<String> gendersforApi = ["male", "female"];
  String genderValue = "Homem";

  bool textVisible = false;
  bool _passwordVisible = false;
  final userController = TextEditingController();
  final passController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future apiCall(username, password, email, address, gender) async {
    http.Response response;
    response = await http.post(
      Uri.parse("http://localhost:5000/user/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "email": email,
        "address": address,
        "gender": gender,
        "image": ""
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      Navigator.pushNamed(context, "/loginpage");
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Image.asset("assets/images/LusoVeste.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: TextField(
              controller: userController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o seu username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o seu email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: DropdownButton<String>(
              value: genderValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  genderValue = value!;
                  gender = gendersforApi[genders.indexOf(genderValue)];
                });
              },
              items: genders.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: TextField(
              controller: addressController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText:
                    'Introduza a sua morada (clique no icone para usar o gps)',
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.map_outlined,
                    color: Colors.black54,
                  ),
                  onPressed: () async {
                    // to use gps, only works on phone
                    setState(() {
                      addressController.text = "...";
                    });
                    final position = await _determinePosition();
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        position.latitude, position.longitude);
                    setState(() {
                      String localidade = placemarks[0].toString();
                      addressController.text = localidade;
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: TextFormField(
              controller: passController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: 'Introduza a sua password',
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          Visibility(
              visible: textVisible,
              child: Text(
                "Verifique os campos",
                style: TextStyle(color: Colors.red),
              )),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      userName = userController.text;
                      passWord = passController.text;
                      email = emailController.text;
                      address = addressController.text;
                      apiCall(userName, passWord, email, address, gender);
                    });
                  },
                  child: const Text(
                    "Criar Conta",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/mainpage");
                  },
                  child: Card(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.account_circle_rounded),
                            title: Text("username = $token"),
                            subtitle: Text("password = $passWord"),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
