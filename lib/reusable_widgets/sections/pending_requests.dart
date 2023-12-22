import 'package:flutter/material.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/components/primary_button_outline.dart';
import 'package:xando/components/profile_avatar_screen.dart';

class PendingRequests extends StatelessWidget {
  const PendingRequests({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          const ProfileAvatar(
            image: 'https://api.multiavatar.com/dc8d09961b64430bc4.png',
            imageSize: 60,
            onTap: null,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Veekeo',
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Requested to join',
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                        ),
                      ),
                      Text(
                        '10h ago',
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' ID: 3573ub',
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                        ),
                      ),
                      Text(
                        'Stake: NGN 200',
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                        ),
                      ),
                      const Text(
                        '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PrimaryButton(
                        title: 'Accept',
                        width: 120,
                        height: 29,
                        onpressed: () {},
                        isLoading: false,
                      ),
                      const SizedBox(width: 8),
                      SecondaryButton(
                        title: 'Decline',
                        width: 120,
                        height: 29,
                        onpressed: () {},
                        isLoading: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
