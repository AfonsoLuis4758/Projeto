import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:project/function/dialogue.dart';
import 'package:project/function/my-globals.dart' as globals;

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
  List discountPrice = [];
  String role = "guest";
  bool button = false;
  List userWishlist = [];
  List userCart = [];
  List<bool> isPressed = [];
  bool visibility = false;
  String section = "cart";
  double total = 0;
  int totalItems = 0;
  String ipv4 = globals.ip;

  void calculateTotalAndItems(List items) {
    total = 0;
    totalItems = 0;
    for (var item in items) {
      int quantity = 1;
      var cartItem = userCart.singleWhere(
        (cartItem) => cartItem["id"] == item["_id"],
        orElse: () => null,
      );
      if (cartItem != null) {
        quantity = cartItem["quantity"];
      }
      total += item["price"] * (1 - (item["promotion"] / 100)) * quantity;
      totalItems += quantity;
    }
  }

  Future apiCall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('role') == null) {
      Navigator.pushNamed(context, "/unloggedpage");
    }
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    String Url = "http://$ipv4:5000/user/$section/$email";
    discountPrice = [];

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
    } else if (response.statusCode == 401 && prefs.getString('token') != null) {
      await prefs.clear();
      await showMyDialog(context);
    } else {
      print("error");
    }
  }

  Future userCall(prefs, futureToken) async {
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
      Uri.parse("http://$ipv4:5000/user/wishlist/$email"),
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

  Future cartCall(item, quantity, color, size) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http.put(
      Uri.parse("http://$ipv4:5000/user/cart/$email"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
          {"id": item, "quantity": quantity, "color": color, "size": size}),
    );
    if (response.statusCode == 200) {
      print("posted");
      return json.decode(response.body);
    }
  }

  Future cartQuantityCall(item, quantity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    final String? email = prefs.getString('email');
    String token = futureToken!.substring(1, futureToken.length - 1);

    http.Response response;
    response = await http.put(
      Uri.parse("http://$ipv4:5000/user/cart/quantity/$email"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"id": item, "quantity": quantity}),
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
        .put(Uri.parse("http://$ipv4:5000/user/purchase/$email"), headers: {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("posted");
      Navigator.pushNamed(context, "/purchasepage");
      return json.decode(response.body);
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
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null && arguments["section"] != null) {
      section = arguments["section"];
      button = true;
    }
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
        body: FutureBuilder(
            future: apiCall(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                calculateTotalAndItems(snapshot.data);
                // Display the fetched data
                return Scaffold(
                  body: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              right: 24, left: 24, top: 16, bottom: 16),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      button ? Colors.white : Colors.green),
                              onPressed: () {
                                setState(() {
                                  section = "cart";
                                  button = false;
                                  visibility = false;
                                });
                              },
                              child: Text(
                                "Carrinho",
                                style: TextStyle(
                                    color:
                                        button ? Colors.black : Colors.white),
                              )),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 16, bottom: 16),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      button ? Colors.green : Colors.white),
                              onPressed: () {
                                setState(() {
                                  section = "wishlist";
                                  button = true;
                                  visibility = true;
                                });
                                TextStyle(color: Colors.white);
                              },
                              child: Text(
                                "Wishlist",
                                style: TextStyle(
                                    color:
                                        button ? Colors.white : Colors.black),
                              )),
                        )),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (1 / 1.75),
                            crossAxisCount: cardCount,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data[index]["promotion"] != 0) {
                              discountColor = Colors.black;
                              discountPrice.add(snapshot.data[index]["price"]
                                  .toStringAsFixed(2));
                            } else {
                              discountPrice.add("");
                            }
                            if (userWishlist
                                .contains(snapshot.data[index]["_id"])) {
                              isPressed.add(true);
                            } else {
                              isPressed.add(false);
                            }
                            total += snapshot.data[index]["price"] *
                                (1 - (snapshot.data[index]["promotion"] / 100));

                            int quantity = 1;
                            var cartItem = userCart.singleWhere(
                              (item) =>
                                  item["id"] == snapshot.data[index]["_id"],
                              orElse: () => null,
                            );
                            if (cartItem != null) {
                              quantity = cartItem["quantity"];
                            }

                            Widget buttonWidget = Container();

                            if (section == "cart") {
                              buttonWidget = Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            quantity--;
                                            totalItems--;
                                            total -= snapshot.data[index]
                                                    ["price"] *
                                                (1 -
                                                    (snapshot.data[index]
                                                            ["promotion"] /
                                                        100));
                                            if (quantity == 0) {
                                              cartCall(
                                                  snapshot.data[index]["_id"],
                                                  quantity,
                                                  snapshot.data[index]["color"]
                                                      [0],
                                                  snapshot.data[index]["sizes"]
                                                      [0]);
                                            } else {
                                              cartQuantityCall(
                                                  snapshot.data[index]["_id"],
                                                  quantity);
                                            }
                                          });
                                        },
                                        child: Icon(Icons.arrow_back_ios,
                                            color: Colors.white)),
                                  ),
                                  Text(
                                    "$quantity",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            quantity++;
                                            totalItems++;
                                            total += snapshot.data[index]
                                                    ["price"] *
                                                (1 -
                                                    (snapshot.data[index]
                                                            ["promotion"] /
                                                        100));
                                            cartQuantityCall(
                                                snapshot.data[index]["_id"],
                                                quantity);
                                          });
                                        },
                                        child: Icon(Icons.arrow_forward_ios,
                                            color: Colors.white)),
                                  ),
                                ],
                              );
                            } else {
                              buttonWidget = Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {});
                                    if (userCart.singleWhere(
                                            (item) =>
                                                item["id"] ==
                                                snapshot.data[index]["_id"],
                                            orElse: () => null) !=
                                        null) {
                                    } else {
                                      await cartCall(
                                          snapshot.data[index]["_id"],
                                          1,
                                          snapshot.data[index]["color"][0],
                                          snapshot.data[index]["sizes"][0]);
                                    }
                                  },
                                  child: Text(
                                    "Carrinho",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }

                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8),
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    color: Colors.green,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                                  height: 180,
                                                  fit: BoxFit.cover,
                                                )),
                                            Row(
                                              children: [
                                                Expanded(child: Container()),
                                                InkWell(
                                                    onTap: () {
                                                      if (section ==
                                                          "wishlist") {
                                                        wishlistCall(
                                                            snapshot.data[index]
                                                                ["_id"]);
                                                      } else if (section ==
                                                          "cart") {
                                                        cartCall(
                                                            snapshot.data[index]
                                                                ["_id"],
                                                            1,
                                                            " ",
                                                            " ");
                                                      }
                                                      setState(() {});
                                                    },
                                                    child: Icon(Icons.close)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: SizedBox(
                                            height: 50,
                                            child: Text(
                                                snapshot.data[index]["name"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 4),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                (snapshot.data[index]["price"] *
                                                        (1 -
                                                            (snapshot.data[
                                                                        index][
                                                                    "promotion"] /
                                                                100)))
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 4),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text((discountPrice[index]),
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: discountColor)),
                                          ),
                                        ),
                                        Flexible(child: buttonWidget),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ));
                          }),
                    ),
                    // Expanded(child: Container()),
                    Visibility(
                        visible: !visibility,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.greenAccent[700],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                        "Número de artigos: $totalItems",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white)),
                                  ),
                                  Expanded(child: Container()),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                        "Total: ${total.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white)),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await purchaseCall();
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Comprar",
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                            ],
                          ),
                        ))
                  ]),
                );
              }
            }));
  }
}
