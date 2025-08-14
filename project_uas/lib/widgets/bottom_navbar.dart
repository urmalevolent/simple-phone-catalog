import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Akun',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smartphone),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Lokasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Tentang',
        ),
      ],
    );
  }
}
