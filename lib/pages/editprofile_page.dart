import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  List? imgForApi;
  String source = "";
  String username = '';
  String gender = '';
  String address = "";
  String password = "";

  final usernameController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return token;
  }

  Future passwordChange(password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    //String base64Image = base64Encode(file);
    String token = futureToken!.substring(1, futureToken.length - 1);
    http.Response response;
    response = await http.put(
      Uri.parse("http://localhost:5000/user/password/$email"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      print("posted");
    } else {
      print("error");
    }
  }

  Future<void> passwordDialog(context) async {
    bool _passwordVisible = false;
    double textvisible = 0.0;
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alterar password'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Introduza a sua nova password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: TextFormField(
                      controller: passwordController2,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Confirme a password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
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
                  Opacity(
                    opacity: textvisible,
                    child: Text("Passwords dont match!",
                        style: TextStyle(color: Colors.red)),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  TextButton(
                    child: const Text('Exit'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Change password'),
                    onPressed: () async {
                      if (passwordController.text == passwordController2.text) {
                        await passwordChange(passwordController.text);
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          textvisible = 1.0;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }

  void takeSnapshot(source) async {
    final ImagePicker picker = ImagePicker();
    if (source == "camera") {
      final XFile? img = await picker.pickImage(
          source: ImageSource.camera, // alternatively, use ImageSource.gallery
          imageQuality: 80);
      if (img == null) return;
      imgForApi = await img.readAsBytes();
    }
    if (source == "gallery") {
      final XFile? img = await picker.pickImage(
          source: ImageSource.gallery, // alternatively, use ImageSource.gallery
          imageQuality: 80);
      if (img == null) return;
      imgForApi = await img.readAsBytes();
    }
  }

  Future putCall(username, gender, address, file) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    //String base64Image = base64Encode(file);
    String token = futureToken!.substring(1, futureToken.length - 1);

    String? jsonBody;
    if (file != null) {
      String imgString = base64Encode(file);
      imgString = imgString.replaceAll("/", "-");
      print(imgString);
      setState(() {
        jsonBody = jsonEncode({
          "image": imgString,
          "username": username,
          "gender": gender,
          "address": address,
        });
      });
    } else {
      setState(() {
        jsonBody = jsonEncode({
          "username": username,
          "gender": gender,
          "address": address,
        });
      });
    }

    http.Response response;
    response = await http.put(
      Uri.parse("http://localhost:5000/user/$email"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print("posted");
    } else {
      print("error");
    }
  }

  Future deleteCall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http.delete(
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
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      usernameController.text = arguments["username"];
      genderController.text = arguments["gender"];
      addressController.text = arguments["address"];
    });
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
          child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 150,
                icon: const Icon(
                  Icons.camera_alt_rounded,
                ),
                onPressed: () {
                  source = "camera";
                  takeSnapshot(source);
                },
              ),
              IconButton(
                iconSize: 150,
                icon: const Icon(
                  Icons.image,
                ),
                onPressed: () {
                  source = "gallery";
                  takeSnapshot(source);
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              controller: usernameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'O seu nome',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              controller: addressController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'A sua morada',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              controller: genderController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'O seu género',
              ),
            ),
          ),
          InkWell(
            onTap: () {
              passwordDialog(context);
            },
            child: Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(child: Text('Alterar password')),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  username = usernameController.text;
                  address = addressController.text;
                  gender = genderController.text;

                  putCall(username, gender, address, imgForApi);
                });
              },
              child: const Text(
                "Editar",
                style: TextStyle(fontSize: 24),
              )),
          ElevatedButton(
              onPressed: () {
                deleteCall();
              },
              child: const Text(
                "Eliminar",
                style: TextStyle(fontSize: 24),
              )),
        ],
      )),
    );
  }
}
