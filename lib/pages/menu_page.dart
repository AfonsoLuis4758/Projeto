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
                  Slider(
                    value: _currentSliderValue,
                    max: 120,
                    divisions: 12,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
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
                                      setState(() {
                                        sizeCheckbox[0] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("XS"));
                                      setState(() {
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
                                      setState(() {
                                        sizeCheckbox[1] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("S"));
                                      setState(() {
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
                                      setState(() {
                                        sizeCheckbox[2] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("M"));
                                      setState(() {
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
                                      setState(() {
                                        sizeCheckbox[3] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("L"));
                                      setState(() {
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
                                      setState(() {
                                        sizeCheckbox[4] = true;
                                      });
                                    } else {
                                      sizes.removeAt(sizes.indexOf("XL"));
                                      setState(() {
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
    String Url = "http://localhost:5000/product/products";

    if (arguments["gender"] != null) {
      final type = arguments['type'];
      final gender = arguments['gender'];
      Url = "http://localhost:5000/product/$type?gender=$gender";
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
      setState(() {
        visibility = true;
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
                              onPressed: () {
                                filterPop();
                              },
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
                          itemCount: snapshot.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (1 / 1.5),
                            crossAxisCount: cardCount,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data[index] != null) {
                              final firstSet =
                                  snapshot.data[index]["sizes"].toSet();
                              final secondSet = sizes.toSet();
                              final intersection =
                                  firstSet.intersection(secondSet);
                              if (snapshot.data[index]["price"] *
                                          (1 -
                                              (snapshot.data[index]
                                                      ["promotion"] /
                                                  100)) >
                                      max ||
                                  !intersection.isNotEmpty) {
                                snapshot.data.removeAt(index);
                                snapshot.data.add(null);
                              }

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
                                            "image": snapshot.data[index]
                                                ["image"],
                                            "name": snapshot.data[index]
                                                ["name"],
                                            "gender": snapshot.data[index]
                                                ["gender"],
                                            "type": snapshot.data[index]
                                                ["type"],
                                            "stock": snapshot.data[index]
                                                ["stock"],
                                            "price": snapshot.data[index]
                                                ["price"],
                                            "color": snapshot.data[index]
                                                ["color"],
                                            "sizes": snapshot.data[index]
                                                ["sizes"],
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      child: Column(
                                        children: [
                                          Hero(
                                              tag: "herotag" +
                                                  snapshot.data[index]["_id"],
                                              child: Image.memory(
                                                base64Decode(snapshot
                                                    .data[index]["image"]
                                                    .replaceAll("-", "/")),
                                                fit: BoxFit.cover,
                                                height: 200,
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
                                                  decoration: TextDecoration
                                                      .lineThrough,
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
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ),
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
