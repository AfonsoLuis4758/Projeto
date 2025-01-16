import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MenuPage extends StatefulWidget {
  //secondPage

  const MenuPage({super.key});
  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  IconData gridType = Icons.grid_3x3;
  int cardCount = 2;
  Color discountColor = Colors.green;
  List discountPrice = [];
  List userWishlist = [];
  List<bool> isPressed = [];
  String role = "guest";
  String category = "Todos";

  Future? future;

  @override
  void initState() {
    future = apiCall();
    super.initState();
  }

  Future apiCall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String? futureToken = prefs.getString('token');
    String Url = "http://localhost:5000/product/products";

    if (arguments["gender"] == "Homem") {
      final type = arguments['type'];
      Url = "http://localhost:5000/product/$type?gender='Homem'";
      setState(() {
        final split = type.split('/');
        final Map values = {for (int i = 0; i < split.length; i++) i: split[i]};
        category = values[0];
      });
    } else if (arguments["gender"] == "Mulher") {
      final type = arguments['type'];

      setState(() {
        final split = type.split('/');
        final Map values = {for (int i = 0; i < split.length; i++) i: split[i]};
        category = values[0];
      });
      Url = "http://localhost:5000/product/$type?gender=Mulher";
    } else if (arguments["type"] != null) {
      final type = arguments['type'];
      final split = type.split('/');
      final Map values = {for (int i = 0; i < split.length; i++) i: split[i]};
      category = values[0];
      Url = "http://localhost:5000/product/$type";
    }

    http.Response response;
    response = await http.get(
      Uri.parse(Url),
      headers: {
        'Content-type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      if (futureToken != null) {
        userWishlist = await userCall(prefs, futureToken);
      }
      return json.decode(response.body);
    }
  }

  Future userCall(prefs, futureToken) async {
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
      final resp = json.decode(response.body);
      prefs.setString("role", resp["role"]);
      return resp["wishlist"];
    }
  }

  Future wishlistCall(wish) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http.put(
      Uri.parse("http://localhost:5000/user/wishlist/$email"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"wishlist": wish}),
    );
    if (response.statusCode == 200) {
      print("posted");
      return json.decode(response.body);
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
                Navigator.pushNamed(context, "/profilepage");
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // Display the fetched data
                return Scaffold(
                  body: Column(children: [
                    Row(
                      children: [
                        Text(
                          category,
                          style: TextStyle(fontSize: 32),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {},
                              child: const Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.black,
                              )),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (cardCount == 2) {
                                  cardCount = 1;
                                  gridType = Icons.list;
                                } else {
                                  cardCount = 2;
                                  gridType = Icons.grid_3x3;
                                }
                              });
                            },
                            child: Icon(
                              gridType,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (1 / 1.5),
                            crossAxisCount: cardCount,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data[index]["promotion"] != 0) {
                              discountColor = Colors.black;
                              discountPrice.add(
                                  snapshot.data[index]["price"].toString());
                            } else {
                              discountPrice.add("");
                            }
                            if (userWishlist
                                .contains(snapshot.data[index]["_id"])) {
                              isPressed.add(true);
                            } else {
                              isPressed.add(false);
                            }

                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "/itempage",
                                      arguments: {
                                        "id": snapshot.data[index]["_id"],
                                        "image": snapshot.data[index]["image"],
                                        "name": snapshot.data[index]["name"],
                                        "gender": snapshot.data[index]
                                            ["gender"],
                                        "type": snapshot.data[index]["type"],
                                        "stock": snapshot.data[index]["stock"],
                                        "price": snapshot.data[index]["price"],
                                        "color": snapshot.data[index]["color"],
                                        "sizes": snapshot.data[index]["sizes"],
                                        "promotion": snapshot.data[index]
                                            ["promotion"],
                                        "recent": snapshot.data[index]
                                            ["recent"],
                                        "wishlisted": isPressed[index]
                                      });
                                },
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  color: Colors.green,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  child: Column(
                                    children: [
                                      Hero(
                                          tag: "herotag" +
                                              snapshot.data[index]["_id"],
                                          child: Image.memory(
                                            base64Decode(snapshot.data[index]
                                                    ["image"]
                                                .replaceAll("-", "/")),
                                            fit: BoxFit.cover,
                                          )),
                                      Text(snapshot.data[index]["name"]),
                                      Text((snapshot.data[index]["price"] *
                                              (1 -
                                                  (snapshot.data[index]
                                                          ["promotion"] /
                                                      100)))
                                          .toStringAsFixed(2)),
                                      Text((discountPrice[index]),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: discountColor)),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isPressed[index] =
                                                !isPressed[index];
                                          });
                                          await wishlistCall(
                                              snapshot.data[index]["_id"]);
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: isPressed[index]
                                              ? Colors.red
                                              : Colors.white,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          }),
                    ),
                  ]),
                  floatingActionButton: FloatingActionButton(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    onPressed: () {
                      Navigator.pushNamed(context, "/creationpage");
                    },
                    child: const Icon(Icons.add),
                  ),
                );
              }
            }));
  }
}
