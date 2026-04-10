import 'package:flutter/material.dart';

import 'package:flutter_money_tracking_app/views/money_balance_ui.dart';
import 'package:flutter_money_tracking_app/views/money_in_ui.dart';
import 'package:flutter_money_tracking_app/views/money_out_ui.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [
    MoneyInUI(),
    MoneyBalanceUI(),
    MoneyOutUI(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF458F8B),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(
              Icons.account_balance_wallet_rounded,
              0,
              Colors.green,
            ),
            label: 'เงินเข้า',
          ),
          BottomNavigationBarItem(
            icon: _buildNotebookIcon(1),
            label: 'สรุปยอด',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              Icons.monetization_on_rounded,
              2,
              Colors.red,
            ),
            label: 'เงินออก',
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index, Color color) {
    final isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.translationValues(
        0,
        isSelected ? -6 : 0,
        0,
      ),
      child: Icon(
        icon,
        size: isSelected ? 30 : 24,
        color: isSelected ? color : Colors.grey,
      ),
    );
  }

  Widget _buildNotebookIcon(int index) {
    final isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      transform: Matrix4.translationValues(
        0,
        isSelected ? -10 : 0,
        0,
      ),
      padding: const EdgeInsets.all(6),
      child: Icon(
        Icons.menu_book_rounded,
        size: isSelected ? 34 : 28,
        color: isSelected ? const Color(0xFF458F8B) : Colors.grey,
      ),
    );
  }
}
