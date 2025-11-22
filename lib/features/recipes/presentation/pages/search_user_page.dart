import 'package:flutter/material.dart';

class SearchUserPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  SearchUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Auto focus ketika page dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Cari pengguna...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (query) {
            // Implementasi search logic nanti
            debugPrint('Search user: $query');
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text('Search User Results akan muncul di sini'),
      ),
    );
  }

  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
  }
}
