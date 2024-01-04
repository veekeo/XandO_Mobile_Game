import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Game/create_game_provider.dart';
import 'package:xando/components/primary_button.dart';

class OtherDailog extends StatelessWidget {
  const OtherDailog({
    super.key,
    required this.text,
    required this.onPressed,
    required this.buttonText,
    required this.smallText,
  });

  final String text;
  final String smallText;
  final String buttonText;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 32, 40, 73),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Bold',
              fontSize: 36,
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 500.ms)
              .slideY(duration: 500.ms),
          Text(
            smallText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Medium',
                fontSize: 18,
                color: Colors.white.withOpacity(0.5)),
          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 500.ms)
              .slideY(duration: 500.ms),
        ],
      ),
      actions: [
        Consumer<CreateGameProvider>(
          builder: (context, game, child) {
            return PrimaryButton(
              title: buttonText,
              width: 250,
              height: 55,
              onpressed: onPressed,
              isLoading: game.isLoading,
              backgroundColor: const Color(0xFF3B4FFE),
            )
                .animate(
                  delay:
                      1000.ms, // this delay only happens once at the very start
                )
                .shake(duration: 1000.ms);
          },
        ),
      ],
    );
  }
}
