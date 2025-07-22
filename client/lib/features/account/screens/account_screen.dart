// ignore_for_file: deprecated_member_use

import 'package:ebbok/core/common/widgets/custom_button.dart';
import 'package:ebbok/core/constants/global_variables.dart';
import 'package:ebbok/features/account/screens/add_book_screen.dart';
import 'package:ebbok/features/account/services/account_service.dart';
import 'package:ebbok/features/account/widgets/single_product.dart';
import 'package:ebbok/models/book.dart';
import 'package:ebbok/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:ebbok/features/auth/screens/login_screen.dart';
import 'package:ebbok/features/Home/screens/all_books_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountService accountService = AccountService();
  List<Book>? books;

  @override
  void initState() {
    super.initState();
    fetchOwnBooks();
  }

  Future<void> fetchOwnBooks() async {
    books = await accountService.fetchBooks(context);
    setState(() {});
  }

  void deleteBook(Book book, int index) {
    accountService.deleteBook(
      context: context,
      book: book,
      onSuccess: () {
        books!.removeAt(index);
        setState(() {});
      },
    );
  }

  void logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(Iconsax.user, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.bookmark, color: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, '/wishlist');
                      },
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Iconsax.logout, color: Colors.white),
                      onPressed: logout,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: books == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "My Books" Section
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'My Books',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllBooksScreen(
                                      title: 'My Books',
                                      books: books!,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  color: Color.fromRGBO(185, 25, 194, 1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 260,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: books!.length > 3 ? 3 : books!.length,
                            itemBuilder: (context, index) {
                              final book = books![index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Container(
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                          child: SingleProduct(book: book),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                book.name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => deleteBook(book, index),
                                              icon: const Icon(Iconsax.trash),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Add Book',
                          onTap: () {
                            Navigator.pushNamed(context, AddBookScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
