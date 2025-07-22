// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:ebbok/core/constants/utils.dart';
import 'package:ebbok/features/account/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddBookScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController bookDescController = TextEditingController();
  final TextEditingController bookPriceController = TextEditingController();
  final TextEditingController bookAuthorController = TextEditingController();
  final AccountService accountService = AccountService();

  File? image;

  @override
  void dispose() {
    bookNameController.dispose();
    bookDescController.dispose();
    bookPriceController.dispose();
    bookAuthorController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void addBook() {
    if (formkey.currentState!.validate() && image != null) {
      accountService.addBook(
        context: context,
        name: bookNameController.text,
        description: bookDescController.text,
        author: bookAuthorController.text,
        price: double.parse(bookPriceController.text),
        image: image!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(185, 25, 194, 1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add a New Book',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(185, 25, 194, 1),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Fill in the details and add a new book to your collection.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: selectImage,
                          child: CircleAvatar(
                            radius: 54,
                            backgroundColor: const Color.fromRGBO(185, 25, 194, 0.08),
                            backgroundImage: image != null ? FileImage(image!) : null,
                            child: image == null
                                ? const Icon(Iconsax.image, size: 44, color: Color.fromRGBO(185, 25, 194, 1))
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Iconsax.edit, size: 18, color: Color.fromRGBO(185, 25, 194, 1)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: bookNameController,
                    decoration: InputDecoration(
                      hintText: 'Book Name',
                      prefixIcon: const Icon(Iconsax.book),
                      filled: true,
                      fillColor: const Color(0xFFF3EAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: bookAuthorController,
                    decoration: InputDecoration(
                      hintText: 'Author',
                      prefixIcon: const Icon(Iconsax.user),
                      filled: true,
                      fillColor: const Color(0xFFF3EAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: bookPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Price',
                      prefixIcon: const Icon(Iconsax.dollar_circle),
                      filled: true,
                      fillColor: const Color(0xFFF3EAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: bookDescController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      prefix: Padding(
                        padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                        child: Icon(Iconsax.document_text, color: Colors.grey[700]),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3EAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: addBook,
                      icon: const Icon(Iconsax.add, size: 20),
                      label: const Text(
                        'Add Book',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(185, 25, 194, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
