import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';

class NotFoundPage extends StatelessWidget {
  final String? location;

  const NotFoundPage({
    super.key,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              '404',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3F5242),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Halaman Tidak Ditemukan',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF5E2A25),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                location != null
                    ? 'Halaman "$location" tidak dapat ditemukan'
                    : 'Halaman yang Anda cari tidak tersedia',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF5E2A25),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F5242),
                foregroundColor: const Color(0xFFFFFDDE),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Kembali ke Home',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
