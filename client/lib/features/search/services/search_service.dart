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

class SearchServices {
  Future<List<Book>> fetchSearchedBook({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Book> books = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$apiUri/api/products/search/$searchQuery'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            books.add(
              Book.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
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