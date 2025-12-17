import 'package:flutter/material.dart';

class SearchRecipePage extends StatefulWidget {
  const SearchRecipePage({super.key});

  @override
  State<SearchRecipePage> createState() => _SearchRecipePageState();
}

class _SearchRecipePageState extends State<SearchRecipePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> results = [
    "Bakso Mercon",
    "Bakso merah",
    "Bakso goreng",
    "Bakso Ayam",
    "Bakso kuah",
    "Bakso",
  ];

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Stack(
        children: [
          /// 🎨 GRADIENT OVERLAY BOTTOM
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFFFF3D00).withOpacity(0.4),
                    const Color(0xFFFFFDDE).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),

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
                      onPressed: () => Navigator.pop(context),
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
                          color: const Color(0xFFFFFDDE),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF5E2A25),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            hintText: 'Bakso',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10),
                          ),
                          onChanged: (value) {
                            debugPrint(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 📄 SEARCH RESULT
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: Color(0xFFD9A88C),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        results[index],
                        style: const TextStyle(
                          color: Color(0xFF5E2A25),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        debugPrint("Pilih ${results[index]}");
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
