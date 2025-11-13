import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ratatouille/features/auth/presentation/widgets/ratatouille_subtitle.dart';
import 'package:ratatouille/features/auth/presentation/widgets/ratatouille_title.dart';
import 'package:ratatouille/features/auth/presentation/widgets/rounded_bold_outline.dart';

class SignInScreen extends StatelessWidget {
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToVerification;
  final VoidCallback onNavigateToSignUp;

  const SignInScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToVerification,
    required this.onNavigateToSignUp,
  });

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(signInProvider);
    // final viewModel = ref.read(signInProvider.notifier);

    // final signInEnabled = state.email.isNotEmpty &&
    //     state.password.isNotEmpty && state.emailError == null &&
    //     state.passwordError == null;
    //
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme
            .of(context)
            .textTheme
            .apply(
          bodyColor: Color(0xFF5E2A25),
          displayColor: Color(0xFF5E2A25),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Color(0xFF5E2A25)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF5E2A25), // warna teks button
          ),
        ),
      ),
      child: Scaffold(
          body: Center(
            child: Container(
              color: Color(0xFFFFFDDE),
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatatouilleTitle(),
                    RatatouilleSubtitle("Masuk akun"),
                    TextField(
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Color(0xFF5E2A25)),
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: roundedBoldOutline(),
                          enabledBorder: roundedBoldOutline(),
                          // errorText: state.emailError
                      ),
                      onChanged: (value) {
                        // viewModel.setEmail(value);
                      },
                    ),
                    TextField(
                      // obscureText: !state.passwordVisible,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Color(0xFF5E2A25)),
                          labelText: "Kata Sandi",
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: IconButton(
                              onPressed: () {
                                // viewModel.togglePasswordVisibility()
                              },
                              icon: Icon(
                                Icons.visibility
                                  // state.passwordVisible
                                  // ? Icons.visibility
                                  // : Icons.visibility_off)
                              )
                          ),
                          border: roundedBoldOutline(),
                          enabledBorder: roundedBoldOutline(),
                          // errorText: state.passwordError
                      ),
                      onChanged: (value) {
                        // viewModel.setPassword(value);
                      },
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed:
                            // signInEnabled ?
                                () {
                              // viewModel.signInWithEmailAndPassword(
                              //     onNavigateToHome: onNavigateToHome,
                              //     onNavigateToVerification: onNavigateToVerification,
                              //     onFailed: (error) {
                              //       Fluttertoast.showToast(
                              //         msg: error,
                              //         toastLength: Toast.LENGTH_SHORT,
                              //         gravity: ToastGravity.BOTTOM,
                              //       );
                              //     }
                              // );
                            }
                            // : null
                            ,
                            style: FilledButton.styleFrom(
                                backgroundColor: Color(0xFF3F5242),
                                foregroundColor: Color(0xFFFFFDDE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4),
                                minimumSize: Size(0, 50)
                            ),
                            child: const Text(
                                "Masuk Akun",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                )
                            )
                        )
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                            onPressed: () {
                              // viewModel.signInWithGoogle(
                              //     onSuccess: onNavigateToHome,
                              //     onFailed: (error) {
                              //       Fluttertoast.showToast(
                              //         msg: error,
                              //         toastLength: Toast.LENGTH_SHORT,
                              //         gravity: ToastGravity.BOTTOM,
                              //       );
                              //     }
                              // );
                            },
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFF5E2A25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8
                                ),
                                minimumSize: Size(0, 50)
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
                                    fontWeight: FontWeight.bold
                                )
                            )
                        )
                    ),
                    TextButton(
                        onPressed: onNavigateToSignUp,
                        child: const Text(
                            "Belum punya akun? Buat akun di sini",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2
                            )
                        )
                    )
                  ]
              ),
            ),
          )
      ),
    );
  }
}