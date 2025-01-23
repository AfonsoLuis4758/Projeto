import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/function/dialogue.dart';
import 'dart:convert';
//import 'dart:convert';

class SearchPage extends StatefulWidget {
  //MainPage

  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  List<dynamic> data = []; //to receive from api latter
  List<dynamic> searchResults = [];
  bool button = false;
  String? type;
  String? gender = "male";
  Widget listview = Container();

  String ipv4 = "localhost";

  Future<void> _getGender() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("gender") != null) {
        gender = prefs.getString('gender');
        if (gender == "male") {
          button = false;
        } else {
          button = true;
        }
      }
    });
  }

  @override
  void initState() {
    listview = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/menupage",
                    arguments: {"gender": gender, "type": "promotion"});
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: Text('Promoções')),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/menupage",
                    arguments: {"gender": gender, "type": "new"});
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: Text('Novidades')),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/menupage",
                    arguments: {"gender": gender, "type": "pants"});
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: Text('Calças')),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/menupage",
                    arguments: {"gender": gender, "type": "shirts"});
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: Text('T-shirts')),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/menupage",
                    arguments: {"gender": gender, "type": "sweatshirts"});
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: Text('Sweatshirts')),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/menupage",
                    arguments: {"gender": gender, "type": "jackets"});
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(child: Text('Casacos')),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    super.initState();
    _getGender();
  }

  final controller = TextEditingController();
  int flag = 0;

  /*Future getSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    gender = prefs.getString("gender");
    return gender;
  } */

  void onQueryChanged(String query) {
    setState(() {
      if (flag == 0) {
        flag++;
        getFromApi();
      }
      listview = _searchListView(searchResults, gender);
      searchResults = data
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future getFromApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    //String base64Image = base64Encode(file);
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http
        .get(Uri.parse("http://$ipv4:5000/user/searches/$email"), headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else if (response.statusCode == 401 && prefs.getString('token') != null) {
      await prefs.clear();
      await showMyDialog(context);
    } else {
      print("error");
    }
  }

  Future sendToApi(search) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http.put(
      Uri.parse("http://$ipv4:5000/user/searches/$email"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"search": search}),
    );

    if (response.statusCode == 200) {
      print("posted");
    } else {
      print("error");
    }
  }

  Future<void> _checkRoleAndNavigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role');
    if (role == null) {
      Navigator.pushNamed(context, "/unloggedpage");
    } else {
      Navigator.pushNamed(context, "/profilepage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[800],
          title: const Text(
            "LusoVest",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
              ),
              onPressed: () async {
                await _checkRoleAndNavigate();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: 24,
                    right: 8,
                    bottom: 24,
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              button ? Colors.white : Colors.green),
                      onPressed: () {
                        setState(() {
                          gender = "male";
                          button = false;
                        });
                      },
                      child: Text(
                        "Homem",
                        style: TextStyle(
                            color: button ? Colors.black : Colors.white,
                            fontSize: 18),
                      )),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              button ? Colors.green : Colors.white),
                      onPressed: () {
                        setState(() {
                          gender = "female";
                          button = true;
                        });
                      },
                      child: Text(
                        "Mulher",
                        style: TextStyle(
                            color: button ? Colors.white : Colors.black,
                            fontSize: 18),
                      )),
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                top: 0,
                right: 24,
                bottom: 0,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: onQueryChanged,
                  onSubmitted: (query) async {
                    await sendToApi(query);
                    Navigator.pushNamed(context, "/menupage",
                        arguments: {"gender": gender, "type": "search/$query"});
                  },
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            listview
          ],
        ));
  }
}

Widget _searchListView(searchResults, gender) {
  return Expanded(
    child: ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/menupage", arguments: {
                  "gender": gender,
                  "type": "search/${searchResults[index]}"
                });
              },
              child: Text(searchResults[index])),
        );
      },
    ),
  );
}
