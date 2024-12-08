import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.grey),
      home: WelcomeScreen(),
    );
  }
}

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

class RegistrationScreen extends StatefulWidget {

  final String languageCode;

  const RegistrationScreen({required this.languageCode});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<String> registerUser(String name, String surname, String phone, String password, String password2) async {
    final url = Uri.parse('http://127.0.0.1:8000/registration/');
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


  Future<bool> loginUser(String phone, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/login/?phone_number=$phone&password=$password');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (response.body.contains("Incorrect phone number or password")) {
        throw Exception('Неверный номер телефона или пароль');
      }
      return true;
    } else {
      throw Exception('Ошибка входа: ${response.body}');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 200, 200, 200),
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

  Widget buildForm(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: buildInputDecoration(getText('name')),
          ),
          SizedBox(height: screenHeight * 0.03),
          if (isRegistrationSelected) ...[
            TextField(
              controller: surnameController,
              decoration: buildInputDecoration(getText('surname')),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextField(
              controller: phoneController,
              decoration: buildInputDecoration(getText('phone')),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: screenHeight * 0.03),
          ],
          TextField(
            controller: passwordController,
            decoration: buildInputDecoration(getText('password')),
            obscureText: true,
          ),
          if (!isRegistrationSelected) ...[
            SizedBox(height: screenHeight * 0.01),
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
          SizedBox(height: screenHeight * 0.03),
          if (isRegistrationSelected)
            TextField(
              controller: confirmPasswordController,
              decoration: buildInputDecoration(getText('repeatPassword')),
              obscureText: true,
            ),
          SizedBox(height: screenHeight * 0.05),
          ElevatedButton(
            onPressed: () async {
              if (isRegistrationSelected) {
                try {
                  final result = await registerUser(
                    nameController.text,
                    surnameController.text,
                    phoneController.text,
                    passwordController.text,
                    confirmPasswordController.text,
                  );
                  print("Успешная регистрация: $result");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen(languageCode: widget.languageCode)),
                  );
                } catch (e) {
                  print("Ошибка: $e");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              } else {
                try {
                  final success = await loginUser(phoneController.text, passwordController.text);
                  if (success) {
                    print("Успешный вход");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuScreen(languageCode: widget.languageCode)),
                    );
                  }
                } catch (e) {
                  print("Ошибка: $e");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
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





  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}


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
          // Контент на фоне
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


class ToggleButtonsContainer extends StatelessWidget {
  final bool isRegistrationSelected;
  final ValueChanged<bool> onToggle;

  const ToggleButtonsContainer({
    required this.isRegistrationSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Color(0xFF30262F),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          buildToggleButton('Registration', true),
          buildToggleButton('Login', false),
        ],
      ),
    );
  }

  Widget buildToggleButton(String text, bool isSelectedTab) {
    bool isSelected = isRegistrationSelected == isSelectedTab;

    return Expanded(
      child: GestureDetector(
        onTap: () => onToggle(isSelectedTab),
        child: FractionallySizedBox(
          widthFactor: isSelected ? 0.9 : 1.0,
          child: Container(
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF8B7B89) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class MenuScreen extends StatelessWidget {
  final String languageCode;

  MenuScreen({required this.languageCode});

  String getText(String key) {
    switch (languageCode) {
      case 'pt':
        return {
          'profile': 'Perfil',
          'savings': 'Poupança',
          'contribution': 'Contribuição',
          'nameSurname': 'Nome Sobrenome',
        }[key]!;
      case 'fr':
        return {
          'profile': 'Profil',
          'savings': 'Épargne',
          'contribution': 'Contribution',
          'nameSurname': 'Nom Prénom',
        }[key]!;
      case 'ht':
        return {
          'profile': 'Pwofil',
          'savings': 'Kach',
          'contribution': 'Kondwit',
          'nameSurname': 'Non Siyati',
        }[key]!;
      case 'es':
        return {
          'profile': 'Perfil',
          'savings': 'Ahorros',
          'contribution': 'Contribución',
          'nameSurname': 'Nombre Apellido',
        }[key]!;
      case 'en':
      default:
        return {
          'profile': 'Profile',
          'savings': 'Savings',
          'contribution': 'Contribution',
          'nameSurname': 'Name Surname',
        }[key]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(width: screenWidth * 0.03),
                Text(
                  getText('nameSurname'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              width: screenWidth,
              height: 5.0,
              color: Color.fromARGB(255, 230, 230, 230),
            ),
            SizedBox(height: screenHeight * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAdaptiveButton(
                  context,
                  text: getText('profile'),
                  isSelected: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(languageCode: languageCode),
                      ),
                    );
                  },
                ),
                _buildAdaptiveButton(
                  context,
                  text: getText('savings'),
                  isSelected: false,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MainScreen(languageCode: languageCode),
                      ),
                    );
                  },
                ),
                _buildAdaptiveButton(
                  context,
                  text: getText('contribution'),
                  isSelected: false,
                  onPressed: () {
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            Container(
              width: screenWidth,
              height: 5.0,
              color: Color.fromARGB(255, 230, 230, 230),
            ),
            SizedBox(height: screenHeight * 0.07),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.07),
                    child: Container(
                      height: screenHeight * 0.12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdaptiveButton(
      BuildContext context, {
        required String text,
        required bool isSelected,
        required VoidCallback onPressed,
      }) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 226, 223, 223),
        elevation: isSelected ? 2 : 0,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color.fromARGB(255, 69, 69, 69),
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}


class MainScreen extends StatelessWidget {
  final String languageCode;

  MainScreen({required this.languageCode});

  String getText(String key) {
    switch (languageCode) {
      case 'pt':
        return {
          'onAccount': 'NA CONTA',
          'pay': 'Pagar',
          'topUp': 'Recarregar',
          'historyOfOperations': 'Histórico de operações',
          'today': 'Hoje',
          'yesterday': 'Ontem',
        }[key]!;
      case 'fr':
        return {
          'onAccount': 'SUR LE COMPTE',
          'pay': 'Payer',
          'topUp': 'Recharger',
          'historyOfOperations': 'Historique des opérations',
          'today': 'Aujourd\'hui',
          'yesterday': 'Hier',
        }[key]!;
      case 'ht':
        return {
          'onAccount': 'NAN KONT',
          'pay': 'Peye',
          'topUp': 'Refè balans',
          'historyOfOperations': 'Istwa operasyon yo',
          'today': 'Jodi a',
          'yesterday': 'Yè',
        }[key]!;
      case 'es':
        return {
          'onAccount': 'EN LA CUENTA',
          'pay': 'Pagar',
          'topUp': 'Recargar',
          'historyOfOperations': 'Historial de operaciones',
          'today': 'Hoy',
          'yesterday': 'Ayer',
        }[key]!;
      case 'en':
      default:
        return {
          'onAccount': 'ON ACCOUNT',
          'pay': 'Pay',
          'topUp': 'Top up',
          'historyOfOperations': 'History of operations',
          'today': 'Today',
          'yesterday': 'Yesterday',
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
              'assets/scale.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03),
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.1),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(48, 38, 47, 1),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                    child: Column(
                      children: [
                        Text(
                          getText('onAccount'),
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          "XXX, XXX, XXX",
                          style: TextStyle(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      context,
                      imagePath: 'assets/pay.png',
                      label: getText('pay'),
                      onPressed: () {},
                    ),
                    _buildActionButton(
                      context,
                      imagePath: 'assets/topup.png',
                      label: getText('topUp'),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.07),
                Container(
                  width: double.infinity,
                  color: Color.fromRGBO(187, 103, 0, 0.79),
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                  child: Center(
                    child: Text(
                      getText('historyOfOperations'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Color.fromRGBO(240, 138, 123, 137),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                    child: ListView(
                      children: [
                        _buildHistorySection(
                          context,
                          title: getText('today'),
                          content: _buildHistoryItem(screenHeight),
                        ),
                        _buildHistorySection(
                          context,
                          title: getText('yesterday'),
                          content: _buildHistoryItem(screenHeight),
                        ),
                      ],
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

  Widget _buildActionButton(BuildContext context,
      {required String imagePath,
        required String label,
        required VoidCallback onPressed}) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: screenWidth * 0.32,
        height: screenWidth * 0.27,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: screenWidth * 0.15,
              height: screenWidth * 0.15,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(
      BuildContext context, {
        required String title,
        required Widget content,
      }) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.03, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        content,
      ],
    );
  }

  Widget _buildHistoryItem(double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.04),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}



class ProfileScreen extends StatelessWidget {
  final String languageCode;

  ProfileScreen({required this.languageCode});

  String getText(String key) {
    switch (languageCode) {
      case 'pt':
        return {
          'profile': 'Perfil',
          'phoneNumber': 'Número de telefone',
          'email': 'E-mail',
          'passportNumber': 'Número do passaporte',
          'snils': 'SNILS',
          'inn': 'INN',
          'password': 'Senha',
        }[key]!;
      case 'fr':
        return {
          'profile': 'Profil',
          'phoneNumber': 'Numéro de téléphone',
          'email': 'E-mail',
          'passportNumber': 'Numéro de passeport',
          'snils': 'SNILS',
          'inn': 'INN',
          'password': 'Mot de passe',
        }[key]!;
      case 'ht':
        return {
          'profile': 'Pwofil',
          'phoneNumber': 'Nimewo telefòn',
          'email': 'Imèl',
          'passportNumber': 'Nimewo paspò',
          'snils': 'SNILS',
          'inn': 'INN',
          'password': 'Modpas',
        }[key]!;
      case 'es':
        return {
          'profile': 'Perfil',
          'phoneNumber': 'Número de Teléfono',
          'email': 'E-mail',
          'passportNumber': 'Número de Pasaporte',
          'snils': 'SNILS',
          'inn': 'INN',
          'password': 'Contraseña',
        }[key]!;
      case 'en':
      default:
        return {
          'profile': 'Profile',
          'phoneNumber': 'Phone Number',
          'email': 'E-mail',
          'passportNumber': 'Passport Number',
          'snils': 'SNILS',
          'inn': 'INN',
          'password': 'Password',
        }[key]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            getText('profile'),
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.1,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(width: screenWidth * 0.03),
                Text(
                  'Name Surname',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileField(context, getText('phoneNumber'), "+ XXX XXX XX XX"),
                  _buildProfileField(context, getText('email'), "Add"),
                  _buildProfileField(context, getText('passportNumber'), "Add"),
                  _buildProfileField(context, getText('snils'), "Add"),
                  _buildProfileField(context, getText('inn'), "Add"),
                  _buildProfileField(context, getText('password'), "********"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(BuildContext context, String title, String value) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            GestureDetector(
              onTap: () {

              },
              child: Text(
                value,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: value == "Add" ? Color.fromARGB(255, 102, 108, 238) : Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

