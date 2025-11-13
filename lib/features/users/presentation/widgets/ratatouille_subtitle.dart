import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatatouilleSubtitle extends StatelessWidget {
  final String subtitle;

  const RatatouilleSubtitle(this.subtitle, {super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        Expanded(
          child: Divider(
              thickness: 1, color: Color(0xFF5E2A25)),
        ),
        Text(
            subtitle,
            style: TextStyle(
              fontFamily: GoogleFonts
                  .playfairDisplay()
                  .fontFamily,
              fontWeight: FontWeight.bold,
            )
        ),
        Expanded(
          child: Divider(
              thickness: 1, color: Color(0xFF5E2A25)),
        ),
      ],
    );
  }
}