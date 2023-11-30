import 'package:flutter/material.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({super.key, required this.displayExOh, required this.index});

  final int index;

  final List<String> displayExOh;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 7, 38),
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: displayExOh[index] != ''
            ? Image.asset(
                displayExOh[index],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            : const Text(''),
      ),
    );
  }
}
