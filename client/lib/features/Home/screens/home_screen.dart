// ignore_for_file: use_build_context_synchronously

import 'package:ebbok/features/Home/screens/all_books_screen.dart';
import 'package:ebbok/features/Home/services/home_service.dart';
import 'package:ebbok/features/Home/widgets/book_grid.dart';
import 'package:ebbok/features/Home/widgets/circle_container.dart';
import 'package:ebbok/features/Home/widgets/curve_edge.dart';
import 'package:ebbok/features/Home/widgets/search_bar.dart';
import 'package:ebbok/features/search/screens/search_screen.dart';
import 'package:ebbok/models/book.dart';
import 'package:ebbok/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService homeService = HomeService();
  List<Book>? popularBooks;
  List<Book>? latestBooks;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    popularBooks = await homeService.fetchPopularBooks(context);
    latestBooks = await homeService.fetchLatestBooks(context);
    setState(() {});
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToViewAll(String section) {
    if (section == 'popular' && popularBooks != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllBooksScreen(
            title: 'Most Popular Books',
            books: popularBooks!,
          ),
        ),
      );
    } else if (section == 'latest' && latestBooks != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllBooksScreen(
            title: 'Latest Books',
            books: latestBooks!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CurveEdge(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromRGBO(185, 25, 194, 1), Color.fromARGB(255, 229, 67, 121)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                height: 280,
                child: Stack(
                  children: [
                    Positioned(
                      top: -150,
                      right: -250,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 5),
                        curve: Curves.easeInOut,
                        child: const CircleContainer(),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      right: -300,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 5),
                        curve: Curves.easeInOut,
                        child: const CircleContainer(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Good Shopping!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SearchBarWidget(
                            onSubmit: navigateToSearchScreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (popularBooks == null || latestBooks == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              BookGrid(
                books: popularBooks!,
                title: 'Most Popular',
                onViewAll: () => navigateToViewAll('popular'),
              ),
              const SizedBox(height: 24),
              BookGrid(
                books: latestBooks!,
                title: 'Latest Books',
                onViewAll: () => navigateToViewAll('latest'),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
