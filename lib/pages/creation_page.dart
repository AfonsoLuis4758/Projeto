import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class CreationPage extends StatefulWidget {
  const CreationPage({super.key});
  @override
  State<CreationPage> createState() => _CreationPage();
}

class _CreationPage extends State<CreationPage> {
  List<int>? imgForApi;
  String source = "";
  String name = '';
  String type = '';
  String gender = '';
  String price = "";
  String stock = "";
  bool recent = true;
  List colorCheckbox = [false, false, false, false, false, false];
  List sizeCheckbox = [false, false, false, false];
  List colors = [];
  List sizes = [];

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final genderController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return token;
  }

  Future apiCall(
      name, type, stock, gender, price, colors, sizes, recent, file) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? futureToken = prefs.getString('token');
    //String base64Image = base64Encode(file);
    String token = futureToken!.substring(1, futureToken.length - 1);
    print(token);

    String imgString = base64Encode(file);
    imgString = imgString.replaceAll("/", "-");

    http.Response response;
    response = await http.post(
      Uri.parse("http://localhost:5000/product"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": name,
        "type": type,
        "stock": stock,
        "gender": gender,
        "price": price,
        "color": colors,
        "sizes": sizes,
        "recent": recent,
        "image": imgString
      }),
    );

    if (response.statusCode == 200) {
      print("posted");
    } else {
      print("error");
    }
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

  @override
  Widget build(BuildContext context) {
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
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o nome do produto',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              controller: typeController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o tipo de produto',
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
                labelText: 'Introduza o genero de produto',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o preço do produto',
              ),
            ),
          ),
          Row(
            children: [
              Column(
                children: [
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
                                    sizes.add("S");
                                    setState(() {
                                      sizeCheckbox[0] = true;
                                    });
                                  } else {
                                    sizes.removeAt(colors.indexOf("S"));
                                    setState(() {
                                      sizeCheckbox[0] = false;
                                    });
                                  }
                                }),
                            const Text("S")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[1],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("M");
                                    setState(() {
                                      sizeCheckbox[1] = true;
                                    });
                                  } else {
                                    sizes.removeAt(colors.indexOf("M"));
                                    setState(() {
                                      sizeCheckbox[1] = false;
                                    });
                                  }
                                }),
                            const Text("M")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[2],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("L");
                                    setState(() {
                                      sizeCheckbox[2] = true;
                                    });
                                  } else {
                                    sizes.removeAt(colors.indexOf("L"));
                                    setState(() {
                                      sizeCheckbox[2] = false;
                                    });
                                  }
                                }),
                            const Text("L")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: sizeCheckbox[3],
                                onChanged: (value) {
                                  if (value == true) {
                                    sizes.add("XL");
                                    setState(() {
                                      sizeCheckbox[3] = true;
                                    });
                                  } else {
                                    sizes.removeAt(colors.indexOf("XL"));
                                    setState(() {
                                      sizeCheckbox[3] = false;
                                    });
                                  }
                                }),
                            const Text("XL")
                          ],
                        )
                      ]),
                ],
              ),
              Expanded(child: SizedBox()),
              Column(
                children: [
                  const Text("Cores"),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[0],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Azul");
                                    setState(() {
                                      colorCheckbox[0] = true;
                                    });
                                    print(colors);
                                  } else {
                                    colors.removeAt(colors.indexOf("Azul"));
                                    setState(() {
                                      colorCheckbox[0] = false;
                                    });
                                  }
                                }),
                            const Text("Azul")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[1],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Verde");
                                    setState(() {
                                      colorCheckbox[1] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("Verde"));
                                    setState(() {
                                      colorCheckbox[1] = false;
                                    });
                                  }
                                }),
                            const Text("Verde")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[2],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Amarelo");
                                    setState(() {
                                      colorCheckbox[2] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("Amarelo"));
                                    setState(() {
                                      colorCheckbox[2] = false;
                                    });
                                  }
                                }),
                            const Text("Amarelo")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[3],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Vermelho");
                                    setState(() {
                                      colorCheckbox[3] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("Vermelho"));
                                    setState(() {
                                      colorCheckbox[3] = false;
                                    });
                                  }
                                }),
                            const Text("Vermelho")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[4],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Preto");
                                    setState(() {
                                      colorCheckbox[4] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("Preto"));

                                    setState(() {
                                      colorCheckbox[4] = false;
                                    });
                                  }
                                }),
                            const Text("Preto")
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: colorCheckbox[5],
                                onChanged: (value) {
                                  if (value == true) {
                                    colors.add("Branco");
                                    setState(() {
                                      colorCheckbox[5] = true;
                                    });
                                  } else {
                                    colors.removeAt(colors.indexOf("Branco"));

                                    setState(() {
                                      colorCheckbox[5] = false;
                                    });
                                  }
                                }),
                            const Text("Branco")
                          ],
                        )
                      ]),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Introduza o Stock do produto',
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                children: [
                  Checkbox(
                      value: recent,
                      onChanged: (value) {
                        if (value == true) {
                          setState(() {
                            recent = true;
                          });
                        } else {
                          setState(() {
                            recent = false;
                          });
                        }
                      }),
                  const Text("Novidade")
                ],
              )),
          Expanded(child: SizedBox()),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  type = typeController.text;
                  gender = genderController.text;
                  stock = stockController.text;
                  price = priceController.text;

                  apiCall(name, type, double.parse(stock), gender,
                      double.parse(price), colors, sizes, recent, imgForApi);
                });
              },
              child: const Text(
                "Adicionar",
                style: TextStyle(fontSize: 24),
              )),
        ],
      )),
    );
  }
}
