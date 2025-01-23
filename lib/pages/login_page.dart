import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String email = '';
  String passWord = '';
  String token = "";
  bool _passwordVisible = false;
  bool textVisible = false;
  final emailController = TextEditingController();
  final passController = TextEditingController();
  String ipv4 = "localhost";

  Future apiCall(email, password) async {
    http.Response response;
    response = await http.post(
      Uri.parse("http://$ipv4:5000/user/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.body);
      await prefs.setString('email', email);
      setState(() {
        token = response.body;
      });
      Navigator.pushNamed(context, "/mainpage");
    } else {
      setState(() {
        textVisible = true;
      });
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(48.0),
            child: Image.asset("assets/images/LusoVeste.png"),
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 24, left: 24, top: 16, bottom: 16),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduz o teu E-mail',
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 24, left: 24, top: 16, bottom: 16),
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
              visible: textVisible, child: Text("Email ou password invalidas")),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      email = emailController.text;
                      passWord = passController.text;
                      apiCall(email, passWord);
                    });
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  )),
            ),
          ),
          Text(
            "Não tens conta? Cria uma!",
            style: TextStyle(fontSize: 14),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/createaccount");
                  },
                  child: const Text(
                    "Criar conta",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
