import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final int maxlines;
  const CustomTextField({super.key, required this.controller, required this.hintText, this.obscureText = false, required this.icon, this.maxlines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        border:  OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black
          ),
          borderRadius: BorderRadius.circular(8)
        ),
        enabledBorder:  OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black
          ),
          borderRadius: BorderRadius.circular(8)
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
      maxLines: maxlines,
      
    );
  }
}