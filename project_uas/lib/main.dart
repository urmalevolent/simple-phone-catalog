import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/api_hp_page.dart';
import 'pages/about_page.dart';
import 'pages/location_page.dart';
import 'widgets/bottom_navbar.dart'; 

void main() {
  runApp(const GadgetKuApp());
}

class GadgetKuApp extends StatelessWidget {
  const GadgetKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SukaHP - Katalog HP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),        
    ApiHpPage(),       
    LocationPage(), 
    AboutPage(),      
  ];

  final List<String> _titles = [
    'My Account',
    'HP Populer',
    'Lokasi Toko',
    'Tentang',
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
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
