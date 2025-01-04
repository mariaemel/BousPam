import 'dart:ui';

import 'package:flutter/material.dart';

import 'VerificationScreen.dart';


class PasswordRecoveryScreen extends StatefulWidget {
  final String languageCode;

  const PasswordRecoveryScreen({required this.languageCode});

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  String getText(String key) {
    final translations = {
      'phone': {
        'pt': 'Número de telefone',
        'fr': 'Numéro de téléphone',
        'es': 'Número de teléfono',
        'ht': 'Nimewo telefòn',
        'en': 'Phone number',
      },
      'recoverPassword': {
        'pt': 'Recuperar Senha',
        'fr': 'Récupérer le mot de passe',
        'es': 'Recuperar contraseña',
        'ht': 'Rèstore modpas la',
        'en': 'Recover Password',
      },
      'phoneRequired': {
        'pt': 'O número de telefone é obrigatório',
        'fr': 'Le numéro de téléphone est obligatoire',
        'es': 'El número de teléfono es obligatorio',
        'ht': 'Nimewo telefòn obligatwa',
        'en': 'Phone number is required',
      },
      'phoneInvalid': {
        'pt': 'Insira um número de telefone válido',
        'fr': 'Entrez un numéro de téléphone valide',
        'es': 'Ingrese un número de teléfono válido',
        'ht': 'Antre yon nimewo telefòn valab',
        'en': 'Enter a valid phone number',
      },
      'passwordRequired': {
        'pt': 'A senha é obrigatória',
        'fr': 'Le mot de passe est obligatoire',
        'es': 'La contraseña es obligatoria',
        'ht': 'Modpas obligatwa',
        'en': 'Password is required',
      },
      'passwordTooShort': {
        'pt': 'A senha deve ter pelo menos 6 caracteres',
        'fr': 'Le mot de passe doit contenir au moins 6 caractères',
        'es': 'La contraseña debe tener al menos 6 caracteres',
        'ht': 'Modpas dwe gen omwen 6 karaktè',
        'en': 'Password must be at least 6 characters',
      },
      'passwordInvalid': {
        'pt': 'A senha deve conter letras e números',
        'fr': 'Le mot de passe doit contenir des lettres et des chiffres',
        'es': 'La contraseña debe contener letras y números',
        'ht': 'Modpas dwe gen lèt ak chif',
        'en': 'Password must contain letters and numbers',
      },
      'passwordsDoNotMatch': {
        'pt': 'As senhas não coincidem',
        'fr': 'Les mots de passe ne correspondent pas',
        'es': 'Las contraseñas no coinciden',
        'ht': 'Modpas yo pa matche',
        'en': 'Passwords do not match',
      },
    };
    return translations[key]?[widget.languageCode] ?? translations[key]?['en'] ?? '';
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: getText('phone'),
                        labelStyle: TextStyle(color: Colors.black),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: 10,
                        ),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return getText('phoneRequired');
                        }
                        final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
                        if (!phoneRegex.hasMatch(value)) {
                          return getText('phoneInvalid');
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VerificationScreen(languageCode: widget.languageCode),
                          ),
                        );
                      }
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
          ),
        ],
      ),
    );
  }
}