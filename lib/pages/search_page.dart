import 'package:flutter/material.dart';
//import 'dart:convert';

class SearchPage extends StatefulWidget {
  //MainPage

  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  List<String> data = [
    'Calças',
    'T-shirt',
    'Sweatshirt',
    'Sapatilhas',
    'Casaco'
  ];

  List<String> searchResults = [];

  final controller = TextEditingController();
  Widget listview = _mainListView();

  void onQueryChanged(String query) {
    setState(() {
      listview = _searchListView(searchResults);
      searchResults = data
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: onQueryChanged,
              onSubmitted: (query) {
                data.insert(0, query);
                //final mapEncoded = jsonEncode(data);
                //await storage.write(key: "mapKey", value: mapEncoded);
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
      ),
    );
  }
}

Widget _mainListView() {
  return Expanded(
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        InkWell(
          onTap: () {},
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
          onTap: () {},
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
          onTap: () {},
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
          onTap: () {},
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
          onTap: () {},
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
          onTap: () {},
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
        InkWell(
          onTap: () {},
          child: Container(
            height: 50,
            child: Row(
              children: [
                Expanded(child: Text('Calçado')),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _searchListView(searchResults) {
  return Expanded(
    child: ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: InkWell(onTap: () {}, child: Text(searchResults[index])),
        );
      },
    ),
  );
}
