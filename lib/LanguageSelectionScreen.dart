import 'package:flutter/material.dart';

import 'RegistrationScreen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 200, 200, 200),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Language',
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                color: Colors.black,
                fontFamily: 'Hahmlet',
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            LanguageButton(label: 'Português', languageCode: 'pt'),
            LanguageButton(label: 'Français', languageCode: 'fr'),
            LanguageButton(label: 'Español', languageCode: 'es'),
            LanguageButton(label: 'Ayisyen', languageCode: 'ht'),
            LanguageButton(label: 'English', languageCode: 'en'),
          ],
        ),
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String label;
  final String languageCode;

  const LanguageButton({required this.label, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationScreen(languageCode: languageCode),
            ),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 229, 229, 229),
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          minimumSize: Size(screenWidth * 0.65, screenHeight * 0.001),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide.none,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'IstokWeb',
            color: Colors.black,
            fontSize: screenWidth * 0.07,
          ),
        ),
      ),
    );
  }
}