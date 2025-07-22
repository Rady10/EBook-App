import 'package:ebbok/models/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WishlistService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Future<List<Book>> getWishlistItems(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wishlist/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<Book>((item) => Book.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load wishlist items');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addToWishlist(String userId, String bookId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wishlist/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'bookId': bookId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add item to wishlist: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> removeFromWishlist(String userId, String bookId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/wishlist/$userId/$bookId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove item from wishlist: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 