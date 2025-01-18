import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/func/dialogue.dart';
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
  String gender = "male";
  Widget listview = Container();

  @override
  void initState() {
    listview = Expanded(
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
    );
    super.initState();
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
        .get(Uri.parse("http://localhost:5000/user/searches/$email"), headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else if (response.statusCode == 401 && prefs.getString('token') != null) {
      await prefs.remove('email');
      await prefs.remove('token');
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
      Uri.parse("http://localhost:5000/user/searches/$email"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
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
              onPressed: () {
                Navigator.pushNamed(context, "/unloggedpage");
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
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                button ? Colors.white : Colors.green[700]),
                        onPressed: () {
                          setState(() {
                            gender = "male";
                            button = false;
                          });
                        },
                        child: Text("Homem"))),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                button ? Colors.green[700] : Colors.white),
                        onPressed: () {
                          setState(() {
                            gender = "female";
                            button = true;
                          });
                        },
                        child: Text("Mulher"))),
              ],
            ),
            Container(
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
