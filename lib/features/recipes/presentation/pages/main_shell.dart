import 'package:flutter/material.dart';
import 'package:ratatouille/features/recipes/presentation/widgets/ratatouille_navbar.dart';

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: RatatouilleNavbar(),
    );
  }
}
