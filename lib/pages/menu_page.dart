import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:project/function/dialogue.dart';

class MenuPage extends StatefulWidget {
  //secondPage

  const MenuPage({super.key});
  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  IconData gridType = Icons.grid_3x3;
  int cardCount = 2;
  double? imageheight = 180.00;
  double width = 1.75;
  Color discountColor = Colors.green;
  List discountPrice = [];
  List userWishlist = [];
  List<bool> isPressed = [];
  bool visibility = false;
  String role = "guest";
  List sizes = ["XS", "S", "M", "L", "XL"];
  String category = "Todos";
  List<String> genders = ["Homem", "Mulher"];
  List<String> gendersfromApi = ["male", "female"];
  List<String> types = [
    "Calças",
    "T-shirts",
    "Sweatshirts",
    "Casacos",
    "Calçado",
    "Promoção",
    "Novidade",
    "Pesquisa"
  ];
  List<String> typesfromApi = [
    "pants",
    "shirts",
    "sweatshirts",
    "jackets",
    "shoes",
    "promotion",
    "new",
    "search"
  ];

  double max = 120;
  List sizeCheckbox = [true, true, true, true, true];
  double _currentSliderValue = 120; //for filters

  Future? future;
  String ipv4 = "localhost";

  @override
  void initState() {
    future = apiCall();
    super.initState();
  }

  void filterPop() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Filtros'),
            content: StatefulBuilder(
              builder: (context, state) {
                return SingleChildScrollView(
                    child: Column(children: [
                  const Text("Preço"),
                  Slider(
                    value: _currentSliderValue,
                    max: 120,
                    divisions: 12,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      state(() {
                        // Use the state parameter here
                        _currentSliderValue = value;
                      });
                    },
                  ),
                  Column(children: [
                    const Text("Tamanhos"),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: sizeCheckbox[0],
                                  onChanged: (value) {
                                    if (value == true) {
                                      sizes.add("XS");
                                      state(() {
                                        sizeCheckbox[0] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("XS"));
                                      state(() {
                                        sizeCheckbox[0] = false;
                                      });
                                    }
                                  }),
                              const Text("XS (34)")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: sizeCheckbox[1],
                                  onChanged: (value) {
                                    if (value == true) {
                                      sizes.add("S");
                                      state(() {
                                        sizeCheckbox[1] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("S"));
                                      state(() {
                                        sizeCheckbox[1] = false;
                                      });
                                    }
                                  }),
                              const Text("S (36)")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: sizeCheckbox[2],
                                  onChanged: (value) {
                                    if (value == true) {
                                      sizes.add("M");
                                      state(() {
                                        sizeCheckbox[2] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("M"));
                                      state(() {
                                        sizeCheckbox[2] = false;
                                      });
                                    }
                                  }),
                              const Text("M (38)")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: sizeCheckbox[3],
                                  onChanged: (value) {
                                    if (value == true) {
                                      sizes.add("L");
                                      state(() {
                                        sizeCheckbox[3] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("L"));
                                      state(() {
                                        sizeCheckbox[3] = false;
                                      });
                                    }
                                  }),
                              const Text("L (40)")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: sizeCheckbox[4],
                                  onChanged: (value) {
                                    if (value == true) {
                                      sizes.add("XL");
                                      state(() {
                                        sizeCheckbox[4] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("XL"));
                                      state(() {
                                        sizeCheckbox[4] = false;
                                      });
                                    }
                                  }),
                              const Text("XL (42)")
                            ],
                          )
                        ])
                  ])
                ]));
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Filtrar'),
                onPressed: () {
                  setState(() {
                    max = _currentSliderValue;
                    future = apiCall();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future apiCall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String? futureToken = prefs.getString('token');
    String Url = "http://$ipv4:5000/product/products";

    if (arguments["gender"] != null) {
      final type = arguments['type'];
      final gender = arguments['gender'];
      Url = "http://$ipv4:5000/product/$type?gender=$gender";
      setState(() {
        final split = type.split('/');
        final Map values = {for (int i = 0; i < split.length; i++) i: split[i]};
        category = types[typesfromApi.indexOf(values[0])];
      });
    }
    print(Url);
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
      role = resp["role"];
      setState(() {
        if (role == "admin") {
          visibility = true;
        }
      });
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
        body: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List filteredItems = snapshot.data.where((item) {
                  final firstSet = item["sizes"].toSet();
                  final secondSet = sizes.toSet();
                  final intersection = firstSet.intersection(secondSet);
                  return item["price"] * (1 - (item["promotion"] / 100)) <=
                          max &&
                      intersection.isNotEmpty;
                }).toList();
                // Display the fetched data
                return Scaffold(
                  body: Column(children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            category,
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                              onPressed: () {
                                filterPop();
                              },
                              child: const Icon(
                                Icons.filter_alt_outlined,
                                color: Colors.black54,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, top: 16, bottom: 16, left: 16),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (cardCount == 2) {
                                    cardCount = 1;
                                    imageheight = null;
                                    width = 1.3;
                                    gridType = Icons.list;
                                  } else {
                                    cardCount = 2;
                                    imageheight = 180;
                                    width = 1.75;
                                    gridType = Icons.grid_3x3;
                                  }
                                });
                              },
                              child: Icon(
                                gridType,
                                color: Colors.black54,
                              )),
                        )
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                          itemCount: filteredItems.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (1 / width),
                            crossAxisCount: cardCount,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final item = filteredItems[index];

                            if (item["promotion"] != 0) {
                              discountColor = Colors.black;
                              discountPrice
                                  .add(item["price"].toStringAsFixed(2));
                            } else {
                              discountPrice.add("");
                            }
                            if (userWishlist.contains(item["_id"])) {
                              isPressed.add(true);
                            } else {
                              isPressed.add(false);
                            }
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 16, left: 16),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/itempage",
                                        arguments: {
                                          "id": item["_id"],
                                          "image": item["image"],
                                          "name": item["name"],
                                          "gender": item["gender"],
                                          "type": item["type"],
                                          "stock": item["stock"],
                                          "price": item["price"],
                                          "color": item["color"],
                                          "sizes": item["sizes"],
                                          "promotion": item["promotion"],
                                          "recent": item["recent"],
                                          "wishlisted": isPressed[index],
                                          "role": role
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      color: Colors.green,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      child: Column(
                                        children: [
                                          Hero(
                                              tag: "herotag" + item["_id"],
                                              child: Image.memory(
                                                base64Decode(item["image"]
                                                    .replaceAll("-", "/")),
                                                height: imageheight,
                                                fit: BoxFit.cover,
                                              )),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: SizedBox(
                                                  height: 50,
                                                  child: Text(item["name"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              )),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 4),
                                              child: Text(
                                                (item["price"] *
                                                        (1 -
                                                            (item["promotion"] /
                                                                100)))
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, top: 4),
                                                child: Text(
                                                    (discountPrice[index]),
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: discountColor)),
                                              ),
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    isPressed[index] =
                                                        !isPressed[index];
                                                  });
                                                  await wishlistCall(
                                                      item["_id"]);
                                                },
                                                child: Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: isPressed[index]
                                                          ? Colors.red
                                                          : Colors.white,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ]),
                  floatingActionButton: Visibility(
                    visible: visibility,
                    child: FloatingActionButton(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      onPressed: () {
                        Navigator.pushNamed(context, "/creationpage");
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                );
              }
            }));
  }
}
