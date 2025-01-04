import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'MenuScreen.dart';
import 'PasswordRecoveryScreen.dart';
import 'ToggleButtonsContainer.dart';

class RegistrationScreen extends StatefulWidget {

  final String languageCode;

  const RegistrationScreen({required this.languageCode});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final loginPhoneController = TextEditingController();
  final loginPasswordController = TextEditingController();

  bool isRegistrationSelected = true;

  String getText(String key) {
    switch (widget.languageCode) {
      case 'pt':
        return {
          'name': 'Nome',
          'surname': 'Sobrenome',
          'phone': 'Número de telefone',
          'password': 'Senha',
          'repeatPassword': 'Repetir senha',
          'register': 'Registrar',
          'login': 'Entrar',
          'forgotPassword': 'Esqueceu a senha?',
        }[key]!;
      case 'fr':
        return {
          'name': 'Nom',
          'surname': 'Prénom',
          'phone': 'Numéro de téléphone',
          'password': 'Mot de passe',
          'repeatPassword': 'Répétez le mot de passe',
          'register': 'S\'inscrire',
          'login': 'Se connecter',
          'forgotPassword': 'Mot de passe oublié?',
        }[key]!;
      case 'es':
        return {
          'name': 'Nombre',
          'surname': 'Apellido',
          'phone': 'Número de teléfono',
          'password': 'Contraseña',
          'repeatPassword': 'Repetir la contraseña',
          'register': 'Registrar',
          'login': 'Iniciar sesión',
          'forgotPassword': '¿Olvidaste la contraseña?',
        }[key]!;
      case 'ht':
        return {
          'name': 'Non',
          'surname': 'Siyati',
          'phone': 'Nimewo telefòn',
          'password': 'Modpas',
          'repeatPassword': 'Repete modpas',
          'register': 'Enskri',
          'login': 'Konekte',
          'forgotPassword': 'Bliye modpas la?',
        }[key]!;
      case 'en':
      default:
        return {
          'name': 'Name',
          'surname': 'Surname',
          'phone': 'Phone number',
          'password': 'Password',
          'repeatPassword': 'Repeat password',
          'register': 'Register',
          'login': 'Login',
          'forgotPassword': 'Forgot password?',
        }[key]!;
    }
  }


  String? validateRegistrationForm() {
    if (nameController.text.isEmpty) return 'Please enter your name.';
    if (surnameController.text.isEmpty) return 'Please enter your surname.';
    if (registerPhoneController.text.isEmpty) return 'Please enter your phone number.';
    if (registerPasswordController.text.length < 6) return 'Password must be at least 6 characters.';
    if (registerPasswordController.text != confirmPasswordController.text) return 'Passwords do not match.';
    return null;
  }

  Future<String> registerUser(String name, String surname, String phone, String password, String password2) async {
    final url = Uri.parse('http://server.bouspam.yusim.space/registration/');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    };


    final body = jsonEncode({
      "name": name,
      "surname": surname,
      "password": password,
      "phone_number": phone,
      "password2": password2,
    });

    print(body);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Ошибка регистрации: ${response.body}');
    }
  }


  Future<void> handleRegistration() async {
    final error = validateRegistrationForm();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    try {
      final result = await registerUser(
        nameController.text,
        surnameController.text,
        registerPhoneController.text,
        registerPasswordController.text,
        confirmPasswordController.text,
      );

      final userId = int.tryParse(result);

      if (userId == null) {
        throw Exception('Failed to parse user ID');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);

      print("Registration successful: $result");
      print(userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(
            languageCode: widget.languageCode,
            name: nameController.text,
            surname: surnameController.text,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }



  String? validateLoginForm() {
    if (loginPhoneController.text.isEmpty) return 'Please enter your phone number.';
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(loginPhoneController.text)) return 'Invalid phone number format.';
    if (loginPasswordController.text.isEmpty) return 'Please enter your password.';
    return null;
  }

  Future<bool> loginUser(String phone, String password) async {
    final url = Uri.parse('http://server.bouspam.yusim.space/login/?phone_number=$phone&password=$password');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception('Неверный номер телефона или пароль');
    } else {
      throw Exception('Ошибка сервера: ${response.statusCode}');
    }
  }


  Future<void> handleLogin() async {
    final error = validateLoginForm();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    try {
      final success = await loginUser(
        loginPhoneController.text,
        loginPasswordController.text,
      );

      if (success) {
        print("Login successful");

        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('userId');

        if (userId != null) {
          print("User ID: $userId");
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(
              languageCode: widget.languageCode,
              name: 'Logged in user',
              surname: '',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }


  Widget buildForm(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (isRegistrationSelected) ...[
            TextField(
              controller: nameController,
              decoration: buildInputDecoration(getText('name')),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextField(
              controller: surnameController,
              decoration: buildInputDecoration(getText('surname')),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextField(
              controller: registerPhoneController,
              decoration: buildInputDecoration(getText('phone')),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextField(
              controller: registerPasswordController,
              obscureText: true,
              decoration: buildInputDecoration(getText('password')),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: buildInputDecoration(getText('repeatPassword')),
            ),
          ],

          if (!isRegistrationSelected) ...[
            TextField(
              controller: loginPhoneController,
              decoration: buildInputDecoration(getText('phone')),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextField(
              controller: loginPasswordController,
              obscureText: true,
              decoration: buildInputDecoration(getText('password')),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PasswordRecoveryScreen(languageCode: widget.languageCode),
                    ),
                  );
                },
                child: Text(
                  getText('forgotPassword'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],

          SizedBox(height: screenHeight * 0.05),
          ElevatedButton(
            onPressed: isRegistrationSelected ? handleRegistration : handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFBB6700),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isRegistrationSelected ? getText('register') : getText('login'),
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Center(
          child: Text(
            'BOUS PAM',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/gori.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.07),
                ToggleButtonsContainer(
                  isRegistrationSelected: isRegistrationSelected,
                  onToggle: (isSelected) {
                    setState(() {
                      isRegistrationSelected = isSelected;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.1),
                buildForm(screenWidth, screenHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}