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

  final List _pages = [SearchPage(), MenuPage(), CartPage()];
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (arguments["page"] != null) {
      _navigateBottomBar(arguments["page"]);
      arguments.remove("page");
    }
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.green[800],
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(bodySmall: const TextStyle(color: Colors.green))),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.white),
              label: "PESQUISA",
              activeIcon: Icon(
                Icons.search_outlined,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu, color: Colors.white),
                label: "PRODUTOS",
                activeIcon: Icon(Icons.menu_outlined, color: Colors.white)),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                label: "Cesto", backgroundColor: Color(0xFF000000),
                activeIcon:
                    Icon(Icons.shopping_cart_outlined, color: Colors.white)),
          ],
          selectedItemColor: Colors.white,
          selectedFontSize: 14,
        ),
      ),
    );
  }
}
