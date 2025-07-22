import 'package:ebbok/features/Home/screens/home_screen.dart';
import 'package:ebbok/features/account/screens/account_screen.dart';
import 'package:ebbok/features/cart/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/bottom-bar';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int index = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  updateIndex(int currentIndex){
    setState(() {
      index = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        height: 60,
        elevation: 0,
        selectedIndex: index,
        onDestinationSelected: updateIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.home), label: ''),
          NavigationDestination(icon: Icon(Iconsax.shopping_cart), label: ''),
          NavigationDestination(icon: Icon(Iconsax.user), label: ''),
        ]
      ),
    );
  }
}