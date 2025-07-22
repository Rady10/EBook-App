import 'package:ebbok/core/common/widgets/bottom_bar.dart';
import 'package:ebbok/features/account/screens/add_book_screen.dart';
import 'package:ebbok/features/auth/screens/login_screen.dart';
import 'package:ebbok/features/auth/screens/signup_screen.dart';
import 'package:ebbok/features/book_details/screens/book_details_screen.dart';
import 'package:ebbok/features/search/screens/search_screen.dart';
import 'package:ebbok/features/cart/screens/cart_screen.dart';
import 'package:ebbok/features/wishlist/screens/wishlist_screen.dart';
import 'package:ebbok/models/book.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );
    case SignupScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignupScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case AddBookScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddBookScreen(),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(searchQuery: searchQuery),
      );
    case BookDetailsScreen.routeName:
      var book = routeSettings.arguments as Book;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => BookDetailsScreen(book: book),
      );
    case CartScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CartScreen(),
      );
    case WishlistScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const WishlistScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder:
            (_) => const Scaffold(
              body: Center(child: Text('Screen dose not exist!')),
            ),
      );
  }
}
