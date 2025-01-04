import 'dart:ui';

import 'package:flutter/material.dart';

import 'VerificationScreen.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  final String languageCode;

  const PasswordRecoveryScreen({required this.languageCode});

  String getText(String key) {
    switch (languageCode) {
      case 'pt':
        return {'phone': 'Número de telefone', 'recoverPassword': 'Recuperar Senha'}[key]!;
      case 'fr':
        return {'phone': 'Numéro de téléphone', 'recoverPassword': 'Récupérer le mot de passe'}[key]!;
      case 'es':
        return {'phone': 'Número de teléfono', 'recoverPassword': 'Recuperar contraseña'}[key]!;
      case 'ht':
        return {'phone': 'Nimewo telefòn', 'recoverPassword': 'Rèstore modpas la'}[key]!;
      case 'en':
      default:
        return {'phone': 'Phone number', 'recoverPassword': 'Recover Password'}[key]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            'BOUS PAM',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: getText('phone'),
                      labelStyle: TextStyle(color: Colors.black),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: 10),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerificationScreen(languageCode: languageCode),
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
                    getText('recoverPassword'),
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
