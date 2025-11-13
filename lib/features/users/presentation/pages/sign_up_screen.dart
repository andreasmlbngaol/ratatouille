import 'package:flutter/material.dart';
import 'package:ratatouille/features/users/presentation/widgets/ratatouille_subtitle.dart';
import 'package:ratatouille/features/users/presentation/widgets/ratatouille_title.dart';
import 'package:ratatouille/features/users/presentation/widgets/rounded_bold_outline.dart';

class SignUpScreen extends StatelessWidget {
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToVerification;
  final VoidCallback onNavigateToSignIn;

  const SignUpScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToVerification,
    required this.onNavigateToSignIn,
  });

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(signUpProvider);
    // final viewModel = ref.read(signUpProvider.notifier);
    //
    // final signUpEnabled = state.name.isNotEmpty &&
    //     state.email.isNotEmpty &&
    //     state.password.isNotEmpty &&
    //     state.confirmPassword.isNotEmpty &&
    //     state.nameError == null &&
    //     state.emailError == null &&
    //     state.passwordError == null &&
    //     state.confirmPasswordError == null;
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
                      RatatouilleSubtitle("Registrasi"),
                      TextField(
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Color(0xFF5E2A25)),
                            labelText: "Name",
                            prefixIcon: Icon(Icons.abc),
                            border: roundedBoldOutline(),
                            enabledBorder: roundedBoldOutline(),
                            // errorText: state.nameError
                        ),
                        onChanged: (value) {
                          // viewModel.setName(value);
                        },
                      ),
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
                                onPressed: ()  {
                                  // viewModel.togglePasswordVisibility
                                },
                                icon: Icon(
                                  Icons.visibility
                                    // state.passwordVisible
                                    // ? Icons.visibility
                                    // : Icons.visibility_off
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
                      TextField(
                        // obscureText: !state.confirmPasswordVisible,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(color: Color(0xFF5E2A25)),
                            labelText: "Konfirmasi kata sandi",
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  // viewModel.toggleConfirmPasswordVisibility()
                                },
                                icon: Icon(
                                  Icons.visibility
                                    // state.confirmPasswordVisible
                                    // ? Icons.visibility
                                    // : Icons.visibility_off
                                )
                            ),
                            border: roundedBoldOutline(),
                            enabledBorder: roundedBoldOutline(),
                            // errorText: state.confirmPasswordError
                        ),
                        onChanged: (value) {
                          // viewModel.setConfirmPassword(value);
                        },
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed:
                              // signUpEnabled ?
                                  () {
                                // viewModel.signUpWithEmailAndPassword(
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
                                      vertical: 8),
                                  minimumSize: Size(0, 50)
                              ),
                              child: const Text(
                                  "Daftar",
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
                                      vertical: 8),
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
                          onPressed: onNavigateToSignIn,
                          child: const Text(
                              "Sudah punya akun? Masuk",
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
        )
    );
  }
}
