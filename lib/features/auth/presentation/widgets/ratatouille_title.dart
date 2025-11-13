import 'package:flutter/cupertino.dart';
import 'package:ratatouille/features/auth/presentation/widgets/stacked_text.dart';

class RatatouilleTitle extends StatelessWidget {
  const RatatouilleTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ===== "Rat" =====
        StackedText(
            text: "Rat",
            fillColor: Color(0xFFCC3100),
            outlineColor: Color(0xFFFEF1BE),
            borderColor: Color(0xFF5E2A25)
        ),

        SizedBox(width: 4),

        StackedText(
            text: "atouille",
            fillColor: Color(0xFFFEF1BE),
            outlineColor: Color(0xFFCC3100),
            borderColor: Color(0xFF5E2A25)
        ),
      ],
    );
  }
}