import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ratatouille/features/users/presentation/provider/auth_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Color(0xFFFFFDDE),
              size: 29
          ),
          backgroundColor: Color(0xFFF3551E),
          title: Text(
              "Pengaturan",
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFDDE),
                  fontSize: 25
              )
          ),
        ),
        body: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Container(
                width: double.infinity,
                  color: Color(0xFFFFFDDE),
                  child: Column(
                      children: [
                        FilledButton(
                          onPressed: () async {
                            await authProvider.signOut();
                          },
                          child: Text(
                            "Sign Out"
                          ),
                        )
                      ]
                  )
              );
            }
        )
    );
  }
}
