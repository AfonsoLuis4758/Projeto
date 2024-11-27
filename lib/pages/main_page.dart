import 'package:flutter/material.dart';
import 'package:project/pages/cart_page.dart';
import 'package:project/pages/menu_page.dart';
import 'package:project/pages/search_page.dart';

class MainPage extends StatefulWidget {
  //MainPage

  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _selectedIndex = 1;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [const SearchPage(), const MenuPage(), const CartPage()];
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (arguments["page"] != null) {
      _navigateBottomBar(arguments["page"]);
      arguments.remove("page");
    }
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.green,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(bodySmall: const TextStyle(color: Colors.green))),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.white),
              label: "SEARCH",
              activeIcon: Icon(
                Icons.search_outlined,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu, color: Colors.white),
                label: "MENU",
                activeIcon: Icon(Icons.menu_outlined, color: Colors.white)),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                label: "CART",
                activeIcon:
                    Icon(Icons.shopping_cart_outlined, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
