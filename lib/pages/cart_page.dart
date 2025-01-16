import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
  //secondPage

  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPage();
}

class _CartPage extends State<CartPage> {
  IconData gridType = Icons.grid_3x3;
  int cardCount = 2;
  Color discountColor = Colors.green;
  String discountPrice = "";
  String role = "guest";
  bool button = false;
  List userWishlist = [];
  List userCart = [];
  List<bool> isPressed = [];
  bool visibility = false;
  String section = "cart";

  Future apiCall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    String Url = "http://localhost:5000/user/$section/$email";

    http.Response response;
    response = await http.get(
      Uri.parse(Url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final userData = await userCall(prefs, futureToken);
      userWishlist = userData[0];
      userCart = userData[1];
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
      prefs.setString("gender", resp["gender"]);
      return [resp["wishlist"], resp["cart"]];
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

  Future cartCall(item) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http.put(
      Uri.parse("http://localhost:5000/user/cart/$email"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"cart": item}),
    );
    if (response.statusCode == 200) {
      print("posted");
      return json.decode(response.body);
    }
  }

  Future purchaseCall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http
        .put(Uri.parse("http://localhost:5000/user/purchase/$email"), headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    });
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
            future: apiCall(),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: button
                                        ? Colors.white
                                        : Colors.green[700]),
                                onPressed: () {
                                  setState(() {
                                    section = "cart";
                                    button = false;
                                    visibility = false;
                                  });
                                },
                                child: Text("Carrinho"))),
                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: button
                                        ? Colors.green[700]
                                        : Colors.white),
                                onPressed: () {
                                  setState(() {
                                    section = "wishlist";
                                    button = true;
                                    visibility = true;
                                  });
                                },
                                child: Text("Wishlist"))),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (1 / 1.6),
                            crossAxisCount: cardCount,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data[index]["promotion"] != 0) {
                              discountColor = Colors.black;
                              discountPrice =
                                  snapshot.data[index]["price"].toString();
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
                                      Stack(
                                        children: [
                                          Hero(
                                              tag: "herotag" +
                                                  snapshot.data[index]["_id"],
                                              child: Image.memory(
                                                base64Decode(snapshot
                                                    .data[index]["image"]
                                                    .replaceAll("-", "/")),
                                                fit: BoxFit.cover,
                                              )),
                                          Row(
                                            children: [
                                              Expanded(child: Container()),
                                              InkWell(
                                                  onTap: () {
                                                    if (section == "wishlist") {
                                                      wishlistCall(snapshot
                                                          .data[index]["_id"]);
                                                    } else if (section ==
                                                        "cart") {
                                                      cartCall(snapshot
                                                          .data[index]["_id"]);
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: Icon(Icons.close)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(snapshot.data[index]["name"]),
                                      Text((snapshot.data[index]["price"] *
                                              (1 -
                                                  (snapshot.data[index]
                                                          ["promotion"] /
                                                      100)))
                                          .toString()),
                                      Text((discountPrice),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: discountColor)),
                                      Visibility(
                                          visible: visibility,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              setState(() {});
                                              if (userCart.contains(snapshot
                                                  .data[index]["_id"])) {
                                              } else {
                                                print(userCart);
                                                await cartCall(snapshot
                                                    .data[index]["_id"]);
                                              }
                                            },
                                            child: Text("< Carrinho"),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          }),
                    ),
                    Expanded(child: Container()),
                    Visibility(
                        visible: !visibility,
                        child: ElevatedButton(
                            onPressed: () async {
                              await purchaseCall();
                            },
                            child: Text("Comprar")))
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
