import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/app_routes.dart';
import '../provider/search_user_provider.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    context.read<SearchUserProvider>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Stack(
        children: [
          /// 🍴 PATTERN BAWAH KIRI
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/Resep_bottom_left.png',
              width: 160,
            ),
          ),

          /// 🍴 PATTERN BAWAH KANAN
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Resep_bottom_right.png',
              width: 160,
            ),
          ),

          Column(
            children: [
              /// 🔶 HEADER SEARCH
              Container(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6A2A),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    /// BACK
                    IconButton(
                      onPressed: () => context.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),

                    /// SEARCH FIELD
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Cari pengguna...',
                            prefixIcon: const Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onChanged: (value) {
                            context
                                .read<SearchUserProvider>()
                                .search(query: value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 📄 SEARCH RESULT
              Expanded(
                child: Consumer<SearchUserProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (provider.errorMessage != null) {
                      return Center(
                        child: Text(provider.errorMessage!),
                      );
                    }

                    if (provider.results.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada hasil'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: provider.results.length,
                      separatorBuilder: (_, _) => const Divider(
                        color: Color(0xFFD9A88C),
                        height: 1,
                      ),
                      itemBuilder: (_, index) {
                        final user = provider.results[index];
                        return ListTile(
                          title: Text(
                            user.name,
                            style: const TextStyle(
                              color: Color(0xFF5E2A25),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () {
                            debugPrint('Pilih ${user.name}');
                            // context.push(
                            //     "${AppRoutes.userProfile}/${user.id}"
                            // );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}