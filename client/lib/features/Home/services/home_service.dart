// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:ebbok/core/constants/error_handling.dart';
import 'package:ebbok/core/constants/global_variables.dart';
import 'package:ebbok/core/constants/utils.dart';
import 'package:ebbok/models/book.dart';
import 'package:ebbok/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeService {
  Future<List<Book>> fetchPopularBooks(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Book> books = [];
    try {
      final http.Response res = await http.get(
        Uri.parse('$apiUri/api/all-books'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          final List<dynamic> decodedBody = jsonDecode(res.body);
          for (int i = 0; i < decodedBody.length; i++) {
            books.add(
              Book.fromJson(jsonEncode(decodedBody[i])),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return books;
  }

  Future<List<Book>> fetchLatestBooks(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Book> books = [];
    try {
      final http.Response res = await http.get(
        Uri.parse('$apiUri/api/all-books'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-auth-token': user.token,
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          final List<dynamic> decodedBody = jsonDecode(res.body);
          for (int i = 0; i < decodedBody.length; i++) {
            books.add(
              Book.fromJson(jsonEncode(decodedBody[i])),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return books;
  }
} 