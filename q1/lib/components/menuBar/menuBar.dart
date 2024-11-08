// menuBar.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomMenuBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const BottomMenuBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      height: 60,
      index: currentIndex,
      items: [
        _buildIcon(FontAwesomeIcons.house, 0),
        _buildIcon(FontAwesomeIcons.bowlFood, 1),
        _buildIcon(FontAwesomeIcons.chartSimple, 2),
        _buildIcon(FontAwesomeIcons.bullseye, 3),
        _buildIcon(FontAwesomeIcons.gear, 4),
      ],
      onTap: (index) {
        onTabSelected(index); // Update the selected index
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/meals');
            break;
          case 2:
            Navigator.pushNamed(context, '/statistics');
            break;
          case 3:
            Navigator.pushNamed(context, '/goals');
            break;
          case 4:
            Navigator.pushNamed(context, '/settings');
            break;
        }
      },
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    return Container(
      width: currentIndex == index ? 52 : 40,
      height: currentIndex == index ? 52 : 40,
      decoration: currentIndex == index
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF21007E),
            )
          : null,
      child: Icon(
        icon,
        color: currentIndex == index
            ? const Color.fromARGB(255, 255, 255, 255)
            : const Color(0xFF21007E),
        size: 27,
      ),
    );
  }
}