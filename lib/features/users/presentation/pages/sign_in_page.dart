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
        // ✅ Set background color ke kuning full screen
        backgroundColor: const Color(0xFFFFFDDE),
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return Center(
              child: SingleChildScrollView(
                // ✅ Hapus Container, gunakan padding langsung
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const RatatouilleTitle(),
                    const RatatouilleSubtitle("Masuk akun"),
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                          final success = await authProvider.signInWithEmailAndPassword(
                            _emailController.text,
                            _passwordController.text,
                          );

                          if (!context.mounted) return;

                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  authProvider.error ?? 'Sign in failed',
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
                          "Masuk Akun",
                          style: TextStyle(
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
                          "Masuk dengan Google",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.signUp),
                      child: const Text(
                        "Belum punya akun? Buat akun di sini",
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
            );
          },
        ),
      ),
    );
  }
}