// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSubmit;

  const SearchBarWidget({
    super.key,
    required this.onSubmit,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      widget.onSubmit(query);
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search books...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Iconsax.search_normal,
            color: Color.fromRGBO(185, 25, 194, 1),
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Iconsax.microphone,
              color: Color.fromRGBO(185, 25, 194, 1),
            ),
            onPressed: () {
              // TODO: Implement voice search
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        onSubmitted: (_) => _handleSearch(),
      ),
    );
  }
}
