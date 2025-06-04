import 'package:flutter/material.dart';

import '../../main.dart'; // For $strings, $styles, navigate
import '../../utils/assets.dart';
import '../../utils/responsive.dart' as $appUtils;
import '../alerts/alerts_list_page.dart';
import 'account_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const AlertsListPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            Logos.textLogo,
            height: $appUtils.sizing(25, context),
            color: $styles.colors.blue,
          ),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: $strings.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: $strings.alerts,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: $strings.account,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: $styles.colors.primary,
        unselectedItemColor: $styles.colors.greyMedium,
        onTap: _onItemTapped,
      ),
    );
  }
}
