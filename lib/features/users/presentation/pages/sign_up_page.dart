import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';
import 'package:ratatouille/features/users/presentation/widgets/ratatouille_subtitle.dart';
import 'package:ratatouille/features/users/presentation/widgets/ratatouille_title.dart';
import 'package:ratatouille/features/users/presentation/widgets/rounded_bold_outline.dart';

import '../../../../core/presentation/app_routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: const Color(0xFF5E2A25),
          displayColor: const Color(0xFF5E2A25),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(const Color(0xFF5E2A25)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF5E2A25),
          ),
        ),
      ),
      child: Scaffold(
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
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const RatatouilleTitle(),
                        const RatatouilleSubtitle("Buat Akun"),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Color(0xFF5E2A25)),
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: roundedBoldOutline(),
                            enabledBorder: roundedBoldOutline(),
                          ),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Color(0xFF5E2A25)),
                            labelText: "Kata Sandi",
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            border: roundedBoldOutline(),
                            enabledBorder: roundedBoldOutline(),
                          ),
                        ),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_confirmPasswordVisible,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Color(0xFF5E2A25)),
                            labelText: "Konfirmasi Kata Sandi",
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible = !_confirmPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            border: roundedBoldOutline(),
                            enabledBorder: roundedBoldOutline(),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                              final success = await authProvider.signUpWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                                _confirmPasswordController.text,
                              );

                              if (!context.mounted) return;

                              if (!success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authProvider.error ?? 'Sign up failed',
                                    ),
                                  ),
                                );
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF3F5242),
                              foregroundColor: const Color(0xFFFFFDDE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              minimumSize: const Size(0, 50),
                            ),
                            child: authProvider.isLoading
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
                              "Buat Akun",
                              style: TextStyle(
                                color: Color(0xFFFFFDDE),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                              final success = await authProvider.signInWithGoogle();

                              if (!context.mounted) return;

                              if (!success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authProvider.error ??
                                          'Google sign in failed',
                                    ),
                                  ),
                                );
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF5E2A25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              minimumSize: const Size(0, 50),
                            ),
                            icon: Image.asset(
                              "assets/images/google_logo.png",
                              width: 36,
                              height: 36,
                            ),
                            label: const Text(
                              "Daftar dengan Google",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.signIn),
                          child: const Text(
                            "Sudah punya akun? Masuk di sini",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ],
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

                /// 🎨 GRADIENT OVERLAY TOP
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6A2A),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                  ),
                ),

                /// 🔶 BACKGROUND BOTTOM
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6A2A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(0),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}