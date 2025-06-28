import 'package:flutter/material.dart';
// import your pages here:
import 'home_page.dart';
import 'browse_cars_page.dart';
import 'car_details_page.dart';
import 'account_page.dart';
import 'sell_car_page.dart';
import 'inbox_page.dart';
// import 'sell_car_page.dart';
// import 'inbox_page.dart';
// import 'account_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    BrowseCarsPage(),
    SellCarPage(),
    InboxPage(),
    AccountPage(),

    // SellCarPage(),
    // InboxPage(),
    // AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF2D2C30),
        selectedItemColor: const Color(0xFFD69C39),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Browse cars',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sell Car'),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
