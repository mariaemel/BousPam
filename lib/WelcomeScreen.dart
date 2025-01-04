import 'package:flutter/material.dart';

import 'LanguageSelectionScreen.dart';


class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomPaint(
            size: Size(screenWidth, screenHeight * 0.4),
            painter: OvalPainter(),
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: screenWidth * 0.12,
            child: Image.asset(
              'assets/bus.png',
              width: screenWidth * 0.75,
              height: screenHeight * 0.2,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.4),
                Text(
                  'BOUS PAM',
                  style: TextStyle(
                    fontSize: screenWidth * 0.12,
                    color: Colors.black,
                    fontFamily: 'Jura',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LanguageSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 48, 38, 47),
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.07,
                      height: 1.19,
                    ),
                    minimumSize: Size(screenWidth * 0.65, screenHeight * 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'START',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(250, 167, 167, 167)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.9)
      ..quadraticBezierTo(
          size.width / 2, size.height * 1.2, size.width, size.height * 0.9)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}