import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/Screens/sign_in.dart';
import 'package:flutter/material.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
            color: _currentIndex == 0 ? const Color(0xFF049DFE) : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.qr_code_scanner_outlined,
            color: _currentIndex == 1 ? const Color(0xFF049DFE) : Colors.grey,
          ),
          label: 'Scan & pay',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.sync_alt_rounded,
            color: _currentIndex == 2 ? const Color(0xFF049DFE) : Colors.grey,
          ),
          label: 'Transfer',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.logout,
            color: _currentIndex == 3 ? const Color(0xFF049DFE) : Colors.grey,
          ),
          label: 'Log out',
        ),
      ],
      selectedLabelStyle: const TextStyle(color: Color(0xFF049DFE)),
      unselectedLabelStyle: const TextStyle(color: Colors.grey),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 3) {
          logoutFn();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const SignIn()));
        } else if (index == 1) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
    );
  }
}
