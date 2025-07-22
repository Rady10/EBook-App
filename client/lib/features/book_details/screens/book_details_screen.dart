// ignore_for_file: deprecated_member_use

import 'package:ebbok/models/book.dart';
import 'package:ebbok/features/cart/services/cart_service.dart';
import 'package:ebbok/features/wishlist/services/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:ebbok/providers/user_provider.dart';

class BookDetailsScreen extends StatefulWidget {
  static const String routeName = '/book-details';
  final Book book;

  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isInWishlist = false;
  bool isAddingToCart = false;
  final CartService _cartService = CartService();
  final WishlistService _wishlistService = WishlistService();

  @override
  void initState() {
    super.initState();
    _checkIfInWishlist();
  }

  Future<void> _checkIfInWishlist() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;
    try {
      final items = await _wishlistService.getWishlistItems(userId);
      final found = items.any((book) => book.id == widget.book.id);
      if (mounted) {
        setState(() {
          isInWishlist = found;
        });
      }
    } catch (e) {
      // Optionally handle error
    }
  }

  Future<void> toggleWishlist() async {
    setState(() {
      isInWishlist = !isInWishlist;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    try {
      if (isInWishlist) {
        await _wishlistService.addToWishlist(userId, widget.book.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to wishlist'), backgroundColor: Colors.green),
          );
        }
      } else {
        await _wishlistService.removeFromWishlist(userId, widget.book.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Removed from wishlist'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wishlist error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> addToCart() async {
    if (widget.book.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot add book: Invalid book ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isAddingToCart = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;

    try {
      await _cartService.addToCart(userId, widget.book.id!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to cart'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to cart: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.book.image,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${widget.book.author}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(185, 25, 194, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\$${widget.book.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              child: IconButton(
                onPressed: toggleWishlist,
                icon: Icon(
                  isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                  color: isInWishlist ? Colors.red : Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: isAddingToCart ? null : addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(185, 25, 194, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isAddingToCart
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.shopping_cart),
                          SizedBox(width: 8),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
  }
} 