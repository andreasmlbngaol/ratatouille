import 'package:flutter/material.dart';

class CommentPage extends StatelessWidget {
  CommentPage({super.key});

  final List<Map<String, dynamic>> comments = [
    {
      "name": "Haji Maguire",
      "comment": "Mantap banget rasanya kaya michelin star chef",
      "time": "18 mnt",
      "likes": "4k",
    },
    {
      "name": "Chef marinka",
      "comment": "akhirnya nemu resep paling enak sedunia",
      "time": "18 mnt",
      "likes": "2k",
    },
    {
      "name": "Muhammad Messi",
      "comment": "wah lengkap resep nya dengan alternatif protein",
      "time": "18 mnt",
      "likes": "1k",
    },
    {
      "name": "Abu Ronaldo",
      "comment": "tanggapan chef juna aplikasi ratatouille biru",
      "time": "18 mnt",
      "likes": "12",
    },
    {
      "name": "Habib Neymar",
      "comment": "Tambuih ciek daa",
      "time": "18 mnt",
      "likes": "109",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Column(
        children: [
          /// 🔶 HEADER
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
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Komentar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),

          /// 💬 LIST KOMENTAR
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: comments.length,
              separatorBuilder: (_, __) => const Divider(
                color: Color(0xFFD9A88C),
                height: 24,
              ),
              itemBuilder: (context, index) {
                final data = comments[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 👤 AVATAR
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: const AssetImage(
                        'assets/images/default_avatar.png',
                      ),
                      backgroundColor: Colors.white,
                    ),

                    const SizedBox(width: 12),

                    /// 💬 CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB85C38),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data["comment"],
                            style: const TextStyle(
                              color: Color(0xFF5E2A25),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                data["time"],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.favorite_border,
                                size: 18,
                                color: Colors.red[300],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                data["likes"],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),

          /// ✏️ INPUT KOMENTAR
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Berikan komentar...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFF5E2A25),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E2A25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
