import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isChecking = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    // Auto-check verification setiap 5 detik
    _startAutoCheck();
  }

  void _startAutoCheck() {
    // Future.delayed(const Duration(seconds: 5), () {
    //   if (mounted && !_isChecking) {
    //     _checkEmailVerification(isManual: false);
    //     _startAutoCheck();
    //   }
    // });
  }

  Future<void> _openEmailApp() async {
    try {
      // Try to open Gmail first
      if (await canLaunchUrl(Uri.parse('mailto:'))) {
        await launchUrl(Uri.parse('mailto:'));
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada aplikasi email')),
        );
      }
    } catch (e) {
      debugPrint('Error opening email: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _checkEmailVerification({bool isManual = true}) async {
    setState(() => _isChecking = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.checkAndSyncEmailVerification();

      if (!context.mounted) return;

      if (success) {
        debugPrint('✅ Email verified');

        // Selalu tampilkan success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email berhasil diverifikasi')),
        );

        // Auto-redirect ke update_profile
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            context.go(AppRoutes.home);
          }
        });
      } else {
        debugPrint('❌ Email not verified yet');

        // Hanya tampilkan error message jika manual check (user tekan tombol)
        if (isManual) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? 'Email belum diverifikasi'),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error checking verification: $e');
      if (!context.mounted) return;

      // Hanya tampilkan error jika manual check
      if (isManual) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isChecking = false);
    }
  }

  Future<void> _resendEmailVerification() async {
    setState(() => _isResending = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final result = await authProvider.resendEmailVerification();

      if (!context.mounted) return;

      if (result) {
        debugPrint('✅ Email verification resent');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verifikasi telah dikirim ulang')),
        );
      } else {
        debugPrint('❌ Failed to resend email');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Gagal mengirim ulang email'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error resending email: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  Future<void> _signOut() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.signOut();

    if (!context.mounted) return;
    context.go('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDDE),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Stack(
            children: [
              /// 🍴 FOOD TOP LEFT
              Positioned(
                top: 24,
                left: -5,
                child: Image.asset(
                  'assets/images/top_left.png',
                  width: 180,
                ),
              ),

              /// 🍴 FOOD TOP RIGHT
              Positioned(
                top: 40,
                right: 10,
                child: Image.asset(
                  'assets/images/top_right.png',
                  width: 120,
                ),
              ),

              /// 🧾 CONTENT
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // ===== Email Icon =====
                        Container(
                          width: 200,
                          height: 125,
                          child: const Center(
                            child: Icon(
                              Icons.mail_outline,
                              size: 150,
                              color: Color(0xFF76342E),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ===== Info Text =====
                        Text(
                          'Silakan cek email Anda.\nSetelah verifikasi, kembali ke aplikasi ini.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF5E2A25),
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ===== Open Email App Button =====
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _openEmailApp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F5242),
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFFB39245),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.mail, size: 20),
                            label: const Text(
                              'Buka Aplikasi Email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== Check Verification Button =====
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isChecking ? null : _checkEmailVerification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFEF1BE),
                              foregroundColor: const Color(0xFF5E2A25),
                              side: const BorderSide(
                                color: Color(0xFFB39245),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: _isChecking
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Color(0xFFFFFDDE),
                                ),
                              ),
                            )
                                : const Text(
                              'Cek Status Verifikasi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== Resend Email Button =====
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _isResending ? null : _resendEmailVerification,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFE8845C),
                              side: const BorderSide(
                                color: Color(0xFFE8845C),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: _isResending
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Color(0xFFE8845C),
                                ),
                              ),
                            )
                                : const Text(
                              'Kirim Ulang',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _signOut,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFFFDDE),
                              backgroundColor: const Color(0xFFBA1813),
                              side: const BorderSide(
                                color: Color(0xFFB39245),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Keluar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ===== Additional Info =====
                        Text(
                          'Tidak menerima email verifikasi?\nCoba periksa folder spam atau minta kirim ulang!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF5E2A25).withOpacity(0.7),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),


              /// 🍴 FOOD BOTTOM LEFT
              Positioned(
                bottom: 50, // ⬅ tepat di atas bg-bottom
                left: 10,
                child: Image.asset(
                  'assets/images/food_pattern_bot.png',
                  width: 200,
                ),
              ),

              /// 🍴 FOOD BOTTOM RIGHT
              Positioned(
                bottom: 50,
                right: -35,
                child: Image.asset(
                  'assets/images/food_pattern.png',
                  width: 200,
                ),
              ),

              /// 🎨 GRADIENT OVERLAY
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

              /// 🔶 BACKGROUND TOP
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/bg_top.png',
                  fit: BoxFit.cover,
                ),
              ),

              /// 🔶 BACKGROUND BOTTOM
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/bg_bottom.png',
                  fit: BoxFit.cover,
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
