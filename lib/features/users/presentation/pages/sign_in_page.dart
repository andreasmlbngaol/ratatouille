import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/core/presentation/app_routes.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';
import 'package:ratatouille/features/users/presentation/widgets/ratatouille_subtitle.dart';
import 'package:ratatouille/features/users/presentation/widgets/ratatouille_title.dart';
import 'package:ratatouille/features/users/presentation/widgets/rounded_bold_outline.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDDE),
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return Stack(
              children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 80),

                        const RatatouilleTitle(),

                        const SizedBox(height: 6),

                        const RatatouilleSubtitle("Masuk akun"),

                        const SizedBox(height: 32),

                        /// 📧 EMAIL
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: roundedBoldOutline(),
                            enabledBorder: roundedBoldOutline(),
                            focusedBorder: roundedBoldOutline(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// 🔒 PASSWORD
                        TextField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: "Kata Sandi",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            border: roundedBoldOutline(),
                            enabledBorder: roundedBoldOutline(),
                            focusedBorder: roundedBoldOutline(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// ✅ BUTTON LOGIN
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                              final success =
                              await authProvider.signInWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                              );

                              if (!context.mounted) return;

                              if (!success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authProvider.error ??
                                          'Sign in failed',
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F5242),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: authProvider.isLoading
                                ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                              AlwaysStoppedAnimation(Color(0xFFFFFDDE)),
                            )
                                : const Text(
                              "Masuk Akun",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// 🔵 GOOGLE LOGIN
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                              final success =
                              await authProvider.signInWithGoogle();

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
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFF5E2A25),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: Image.asset(
                              'assets/images/google_logo.png',
                              width: 22,
                            ),
                            label: const Text(
                              "Masuk dengan Google",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// 📝 REGISTER
                        TextButton(
                          onPressed: () => context.go(AppRoutes.signUp),
                          child: const Text(
                            "Belum memiliki akun? Buat akun di sini.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),


                /// 🍴 FOOD BOTTOM LEFT
                Positioned(
                  bottom: 100, // ⬅ tepat di atas bg-bottom
                  left: 20,
                  child: Image.asset(
                    'assets/images/food_pattern_bot.png',
                    width: 140,
                  ),
                ),

                /// 🍴 FOOD BOTTOM RIGHT
                Positioned(
                  bottom: 100,
                  right: 0,
                  child: Image.asset(
                    'assets/images/food_pattern.png',
                    width: 140,
                  ),
                ),

              ],
            );
          },
        ),
      ),
    );
  }

}