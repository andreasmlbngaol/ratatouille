import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class StackedText extends StatelessWidget {
  final String text;
  final Color fillColor;
  final Color outlineColor;
  final Color borderColor;

  const StackedText({
    super.key,
    required this.text,
    required this.fillColor,
    required this.outlineColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outline luar (misal hitam)
        Text(
          text,
          style: TextStyle(
            fontFamily: GoogleFonts.alexandria().fontFamily,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 8 // lebih besar dari outline dalam
              ..color = borderColor,
          ),
        ),
        // Outline kuning
        Text(
          text,
          style: TextStyle(
            fontFamily: GoogleFonts.alexandria().fontFamily,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = outlineColor,
          ),
        ),
        // Fill putih
        Text(
          text,
          style: TextStyle(
            fontFamily: GoogleFonts.alexandria().fontFamily,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: fillColor,
          ),
        ),
      ],
    );
  }
}