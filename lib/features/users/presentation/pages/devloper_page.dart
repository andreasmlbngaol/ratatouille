import 'package:flutter/material.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5A1F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tentang kami',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/ratatuli.png', // ganti asset
                    height: 60,
                  ),
                ),
                const SizedBox(height: 24),
                DeveloperCard(
                  name: 'Andreas',
                  role: 'Full Stack Developer',
                  imagePath: 'assets/images/andre.png',
                ),
                const SizedBox(height: 16),
                DeveloperCard(
                  name: 'Bintang',
                  role: 'Versatile Developer',
                  imagePath: 'assets/images/bintang.png',
                  imageLeft: false,
                ),
                const SizedBox(height: 16),
                DeveloperCard(
                  name: 'Clara',
                  role: 'UI/UX Designer',
                  imagePath: 'assets/images/clara.png',
                ),
                const Spacer(),
                const Center(
                  child: Text(
                    'Created by Suka Kotlin',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            left: 25,
            child: Image.asset(
              'assets/images/dev_bottom_left.png', // asset default
              width: 180,
            ),
          ),
          Positioned(
            bottom: 100,
            right: 25,
            child: Image.asset(
              'assets/images/dev_bottom_right.png', // asset default
              width: 180,
            ),
          ),
        ],
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;
  final bool imageLeft;

  const DeveloperCard({
    super.key,
    required this.name,
    required this.role,
    required this.imagePath,
    this.imageLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: 36,
      backgroundImage: AssetImage(imagePath),
    );

    return Row(
      children: imageLeft
          ? [
        avatar,
        const SizedBox(width: 12),
        Expanded(child: _infoCard()),
      ]
          : [
        Expanded(child: _infoCard()),
        const SizedBox(width: 12),
        avatar,
      ],
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9A7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(role, style: const TextStyle(fontSize: 13)),
            ],
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFD8B25A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_right, size: 20),
          )
        ],
      ),
    );
  }
}
