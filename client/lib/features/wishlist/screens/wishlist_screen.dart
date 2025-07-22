// ignore_for_file: deprecated_member_use

import 'package:ebbok/models/book.dart';
import 'package:ebbok/features/wishlist/services/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:ebbok/providers/user_provider.dart';

class WishlistScreen extends StatefulWidget {
  static const String routeName = '/wishlist';

  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistService _wishlistService = WishlistService();
  List<Book> wishlistItems = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadWishlistItems();
  }

  Future<void> _loadWishlistItems() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user.id;
      final items = await _wishlistService.getWishlistItems(userId);
      if (mounted) {
        setState(() {
          wishlistItems = items;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> removeFromWishlist(Book book) async {
    if (book.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot remove book: Invalid book ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user.id;
      await _wishlistService.removeFromWishlist(userId, book.id!);
      if (mounted) {
        setState(() {
          wishlistItems.remove(book);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item removed from wishlist'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove item: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.warning_2, size: 64, color: Colors.red[400]),
                      const SizedBox(height: 16),
                      Text('Error loading wishlist', style: TextStyle(fontSize: 18, color: Colors.grey[800], fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text(error!, style: TextStyle(fontSize: 14, color: Colors.grey[600]), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadWishlistItems,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(185, 25, 194, 1),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : wishlistItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.heart, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('Your wishlist is empty', style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Text('Add some books to your wishlist', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: wishlistItems.length,
                      itemBuilder: (context, index) {
                        final book = wishlistItems[index];
                        return Dismissible(
                          key: Key(book.id ?? ''),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Iconsax.trash, color: Colors.red[400]),
                          ),
                          onDismissed: (direction) => removeFromWishlist(book),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    book.image,
                                    width: 100,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 150,
                                        color: Colors.grey[200],
                                        child: Icon(Iconsax.book_1, size: 40, color: Colors.grey[400]),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.name,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          book.author,
                                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '\$${book.price.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(185, 25, 194, 1)),
                                        ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: Icon(Iconsax.trash, color: Colors.red[400]),
                                            onPressed: () => removeFromWishlist(book),
                                            tooltip: 'Remove from wishlist',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
} 