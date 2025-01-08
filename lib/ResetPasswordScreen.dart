import 'dart:ui';

import 'package:flutter/material.dart';

import 'MenuScreen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String languageCode;

  const ResetPasswordScreen({required this.languageCode});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FocusNode _newPasswordFocusNode = FocusNode();
  FocusNode _repeatPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _newPasswordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  String getText(String key) {
    switch (widget.languageCode) {
      case 'pt':
        return {
          'newPassword': 'Nova senha',
          'repeatPassword': 'Repita a nova senha',
          'save': 'Salvar',
          'instruction': 'Sua nova senha deve ser diferente da anterior',
          'passwordRequired': 'Senha é obrigatória',
          'passwordTooShort': 'Senha deve ter pelo menos 6 caracteres',
          'passwordsDoNotMatch': 'As senhas não coincidem',
        }[key]!;
      case 'fr':
        return {
          'newPassword': 'Nouveau mot de passe',
          'repeatPassword': 'Répétez le nouveau mot de passe',
          'save': 'Enregistrer',
          'instruction': 'Votre nouveau mot de passe doit être différent de l\'ancien',
          'passwordRequired': 'Mot de passe requis',
          'passwordTooShort': 'Le mot de passe doit comporter au moins 6 caractères',
          'passwordsDoNotMatch': 'Les mots de passe ne correspondent pas',
        }[key]!;
      case 'es':
        return {
          'newPassword': 'Nueva contraseña',
          'repeatPassword': 'Repita la nueva contraseña',
          'save': 'Guardar',
          'instruction': 'Su nueva contraseña debe ser diferente de la anterior',
          'passwordRequired': 'Se requiere contraseña',
          'passwordTooShort': 'La contraseña debe tener al menos 6 caracteres',
          'passwordsDoNotMatch': 'Las contraseñas no coinciden',
        }[key]!;
      case 'ht':
        return {
          'newPassword': 'Nouvo modpas',
          'repeatPassword': 'Repete nouvo modpas la',
          'save': 'Sove',
          'instruction': 'Nouvo modpas ou dwe diferan de modpas anvan an',
          'passwordRequired': 'Modpas obligatwa',
          'passwordTooShort': 'Modpas la dwe gen omwen 6 karaktè',
          'passwordsDoNotMatch': 'Modpas yo pa matche',
        }[key]!;
      case 'en':
      default:
        return {
          'newPassword': 'New Password',
          'repeatPassword': 'Repeat new password',
          'save': 'Save',
          'instruction': 'Your new password must be different from previously used password',
          'passwordRequired': 'Password is required',
          'passwordTooShort': 'Password must be at least 6 characters long',
          'passwordsDoNotMatch': 'Passwords do not match',
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocusNode,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: _newPasswordController.text.isEmpty &&
                          !_newPasswordFocusNode.hasFocus
                          ? getText('newPassword')
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return getText('passwordRequired');
                      }
                      if (value.length < 6) {
                        return getText('passwordTooShort');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  TextFormField(
                    controller: _repeatPasswordController,
                    focusNode: _repeatPasswordFocusNode,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: _repeatPasswordController.text.isEmpty &&
                          !_repeatPasswordFocusNode.hasFocus
                          ? getText('repeatPassword')
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return getText('passwordRequired');
                      }
                      if (value != _newPasswordController.text) {
                        return getText('passwordsDoNotMatch');
                      }
                      return null;
                    },
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
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuScreen(languageCode: widget.languageCode),
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
          ),
        ],
      ),
    );
  }
}