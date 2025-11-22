import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<AuthProvider>().checkAuthStatus();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo_real.png",
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                if (authProvider.isLoading) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
