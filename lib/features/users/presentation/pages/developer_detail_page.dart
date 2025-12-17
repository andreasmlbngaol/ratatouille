import 'package:flutter/material.dart';
// =============================
// DETAIL DEVELOPER PAGE
// =============================
class DeveloperDetailPage extends StatelessWidget {
  const DeveloperDetailPage({super.key});

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
        title: const Text('Tentang kami', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/images/bintang.png'), // ganti asset
                ),
                const SizedBox(height: 20),
                _infoCard(),
                const SizedBox(height: 16),
                _quoteCard(),
                const SizedBox(height: 16),
                _socialCard(),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            bottom: -25,
            left: 10,
            child: Image.asset('assets/images/Resep_bottom_left.png', width: 120),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: Image.asset('assets/images/Resep_bottom_right.png', width: 120),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9A7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'Nama', value: 'Bintang Aulia'),
          _InfoRow(label: 'NIM', value: '231401074'),
          _InfoRow(label: 'Kom', value: 'B'),
          _InfoRow(label: 'Makanan Kesukaan', value: 'Mie Tumis Ikan Teri'),
        ],
      ),
    );
  }

  Widget _quoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9A7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Text('"Adili Patrick Kluivert"', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text('"Shin Tae Yong"', style: TextStyle(fontSize: 13)),
          )
        ],
      ),
    );
  }

  Widget _socialCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.brown),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          _SocialRow(icon: Icons.email, text: 'bintangaulia@students.usu.ac.id'),
          _SocialRow(icon: Icons.camera_alt, text: '_bintang_aulia'),
          _SocialRow(icon: Icons.code, text: 'BintangAull'),
          _SocialRow(icon: Icons.work, text: 'Bintang Aulia'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text('$label', style: TextStyle(fontStyle: FontStyle.italic))),
          Text(': $value'),
        ],
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SocialRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
