import 'package:flutter/material.dart';
import 'display_total_screen.dart';
import 'asset_categories_screen.dart';
import 'add_amount_screen.dart';
import 'subtract_amount_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DisplayTotalScreen(),
    const AssetCategoryScreen(),
    const AddAmountScreen(),
    const SubtractAmountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2F2F2F),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.white70,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Total',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_circle_outline),
            label: 'Subtract',
          ),
        ],
      ),
    );
  }
}