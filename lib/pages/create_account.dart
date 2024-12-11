import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  bool _passwordVisible = false;
  final userController = TextEditingController();
  final passController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final emailController = TextEditingController();

  Future apiCall(username, password, email, address, gender) async {
    http.Response response;
    response = await http.post(
      Uri.parse("http://localhost:5000/users/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "email": email,
        "address": address,
        "gender": gender
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: TextField(
              controller: userController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your e-mail',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: TextField(
              controller: genderController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your gender',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: TextField(
              controller: addressController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText:
                    'Enter your adress or click the icon for automatic location',
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.map_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // to use gps
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextFormField(
              controller: passController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: 'Enter your password',
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      userName = userController.text;
                      passWord = passController.text;
                      email = emailController.text;
                      gender = genderController.text;
                      address = addressController.text;
                      apiCall(userName, passWord, email, address, gender);
                    });
                  },
                  child: const Text(
                    "Create account",
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
