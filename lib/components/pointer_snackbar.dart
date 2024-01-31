import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/snackbar_provider.dart';

class PointerSnackbar extends StatefulWidget {
  const PointerSnackbar({super.key});

  @override
  State<PointerSnackbar> createState() => _PointerSnackbarState();
}

class _PointerSnackbarState extends State<PointerSnackbar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration:
          const Duration(milliseconds: 800), // Duration of the fade animation
      opacity:
          Provider.of<PointerSnackbarProvider>(context).isVisible ? 1.0 : 0.0,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.57),
            child: SizedBox(
              height: 10,
              width: 10, // Height of the triangle
              child: CustomPaint(
                size: const Size(20, 10), // Adjust size of the pointer triangle
                painter: TrianglePainter(
                  color: const Color(0XFF61FD7D),
                ),
              ),
            ),
          ),
          // Green container

          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color(0XFF61FD7D),
            ),
            padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
                left: 10,
                right: 10), // Adjust height by modifying top and bottom padding
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.notifications,
                  color: Colors.black,
                  size: 20,
                ),
                Text(
                  'You have new alerts or game requests here.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),

                SizedBox(width: 20),
                // GestureDetector(
                //   onTap: () {
                //     Provider.of<PointerSnackbarProvider>(context, listen: false)
                //         .toggleVisibility(false);
                //   },
                //   child: const Icon(
                //     Icons.close,
                //     color: Colors.black,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
