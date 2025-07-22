// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ebbok/core/constants/error_handling.dart';
import 'package:ebbok/core/constants/global_variables.dart';
import 'package:ebbok/core/constants/utils.dart';
import 'package:ebbok/models/book.dart';
import 'package:ebbok/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AccountService {
  void addBook({
    required BuildContext context,
    required String name,
    required String description,
    required String author,
    required double price,
    required File image,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dnpweqtiw', 'book-upload');
      final user = Provider.of<UserProvider>(context, listen: false).user;
      
      CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, folder: name),
      );

      Book book = Book(
        name: name,
        description: description,
        author: author,
        image: res.secureUrl,
        price: price,
        userId: user.id
      );

      final http.Response response = await http.post(
        Uri.parse('$apiUri/api/addBook'),
        headers: <String, String> {
          'Content-Type' : 'application/json',
          'x-auth-token' : user.token
        },
        body: book.toJson(),
      );

      httpErrorHandler(
        response: response, 
        context: context, 
        onSuccess: (){
          showSnackBar(context, 'Product Added Successfully');
        }
      );


    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Book>> fetchBooks(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Book> books = [];
    try {
      final http.Response res = await http.get(
        Uri.parse('$apiUri/api/books'),
        headers: <String, String>{
          'Content-Type' : 'application/json',
          'x-auth-token' : user.token,
          'user-id': user.id
        }
      );

      httpErrorHandler(
        response: res, 
        context: context, 
        onSuccess: (){
          for(int i = 0; i < jsonDecode(res.body).length; i++){
            books.add(
              Book.fromJson(jsonEncode(jsonDecode(res.body)[i]))
            );
          }
        }
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return books;
  }

  void deleteBook({
    required BuildContext context,
    required Book book,
    required VoidCallback onSuccess
  }) async {
      final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response res = await http.post(
        Uri.parse('$apiUri/api/delete'),
        headers: <String, String>{
          'Content-Type' : 'application/json',
          'x-auth-token' : user.token,
          'user-id': user.id
        },
        body: jsonEncode({
          'id': book.id
        })
      );

      httpErrorHandler(response: res, context: context, onSuccess: onSuccess);


    } catch(e) {
      showSnackBar(context, e.toString());
    }
  }
}


