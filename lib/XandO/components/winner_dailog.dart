import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Game/create_game_provider.dart';
import 'package:xando/components/primary_button.dart';

class WinnerDailog extends StatelessWidget {
  const WinnerDailog(
      {super.key, required this.onPressed, required this.wonAmount});

  final Function()? onPressed;
  final String wonAmount;

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
          Image.asset(
            'assets/images/winner.png',
          ).animate().fade(duration: 500.ms).scale(delay: 500.ms),
          const SizedBox(height: 15),
          const Text(
            'YOU WON!',
            style: TextStyle(
              fontFamily: 'Bold',
              fontSize: 36,
            ),
          )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 500.ms)
              .slideY(duration: 500.ms),
          Text(
            'NGN $wonAmount',
            style: const TextStyle(
              fontFamily: 'Bold',
              fontSize: 36,
              color: Color(0xffFDC101),
            ),
          )
              .animate()
              .fadeIn(delay: 1500.ms, duration: 500.ms)
              .slideY(duration: 500.ms),
        ],
      ),
      actions: [
        Consumer<CreateGameProvider>(
          builder: (context, game, child) {
            return PrimaryButton(
              title: 'Go Home',
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
