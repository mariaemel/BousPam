import 'dart:ui';

import 'package:flutter/material.dart';

import 'ResetPasswordScreen.dart';

class VerificationScreen extends StatelessWidget {
  final String languageCode;

  const VerificationScreen({required this.languageCode});

  String getText(String key) {
    switch (languageCode) {
      case 'pt':
        return {'enterCode': 'Digite o código de 4 dígitos', 'resendCode': 'Reenviar código', 'verify': 'Verificar'}[key]!;
      case 'fr':
        return {'enterCode': 'Entrez le code à 4 chiffres', 'resendCode': 'Renvoyer le code', 'verify': 'Vérifier'}[key]!;
      case 'es':
        return {'enterCode': 'Ingrese el código de 4 dígitos', 'resendCode': 'Reenviar código', 'verify': 'Verificar'}[key]!;
      case 'ht':
        return {'enterCode': 'Antre kòd 4 chif', 'resendCode': 'Re-envoye kòd la', 'verify': 'Verifye'}[key]!;
      case 'en':
      default:
        return {'enterCode': 'Please enter the 4 digit code', 'resendCode': 'Resend code', 'verify': 'Verify'}[key]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/gori.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                        (index) => Container(
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.09,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                Text(
                  getText('enterCode'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextButton(
                  onPressed: () {

                  },
                  child: Text(
                    getText('resendCode'),
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(languageCode: languageCode),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 187, 103, 0),
                    minimumSize: Size(double.infinity, screenHeight * 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    getText('verify'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
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