// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:ebbok/core/common/widgets/bottom_bar.dart';
import 'package:ebbok/core/constants/error_handling.dart';
import 'package:ebbok/core/constants/global_variables.dart';
import 'package:ebbok/core/constants/utils.dart';
import 'package:ebbok/models/user.dart';
import 'package:ebbok/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuhtService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
      );

      final http.Response response = await http.post(
        Uri.parse('$apiUri/api/signup'),
        headers: <String, String> {
          'Content-Type': 'application/json',
        },
        body: user.toJson(),
      );
      httpErrorHandler(
        response: response, 
        context: context, 
        onSuccess: () {
          showSnackBar(context, 'Account created!, Login with the same credentials.',);
        }
      );

    } catch (e) {
        showSnackBar(context, e.toString());
    }
  }

   void login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      http.Response res = await http.post(
        Uri.parse('$apiUri/api/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'user-id': user.id
        },
      );
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$apiUri/token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$apiUri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
