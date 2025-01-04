import 'dart:ui';

import 'package:flutter/material.dart';

import 'MenuScreen.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String languageCode;

  const ResetPasswordScreen({required this.languageCode});

  String getText(String key) {
    switch (languageCode) {
      case 'pt':
        return {
          'newPassword': 'Nova senha',
          'repeatPassword': 'Repita a nova senha',
          'save': 'Salvar',
          'instruction': 'Sua nova senha deve ser diferente da anterior',
        }[key]!;
      case 'fr':
        return {
          'newPassword': 'Nouveau mot de passe',
          'repeatPassword': 'Répétez le nouveau mot de passe',
          'save': 'Enregistrer',
          'instruction': 'Votre nouveau mot de passe doit être différent de l\'ancien',
        }[key]!;
      case 'es':
        return {
          'newPassword': 'Nueva contraseña',
          'repeatPassword': 'Repetir nueva contraseña',
          'save': 'Guardar',
          'instruction': 'Su nueva contraseña debe ser diferente de la anterior',
        }[key]!;
      case 'ht':
        return {
          'newPassword': 'Nouvo modpas',
          'repeatPassword': 'Repete nouvo modpas la',
          'save': 'Sove',
          'instruction': 'Nouvo modpas ou dwe diferan de sa w te itilize anvan',
        }[key]!;
      case 'en':
      default:
        return {
          'newPassword': 'New Password',
          'repeatPassword': 'Repeat new password',
          'save': 'Save',
          'instruction': 'Your new password must be different from previously used password',
        }[key]!;
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
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: getText('newPassword'),
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: getText('repeatPassword'),
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  getText('instruction'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuScreen(languageCode: languageCode),
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
                    getText('save'),
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