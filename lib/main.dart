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
                    backgroundColor: Color.fromARGB(255, 176, 40, 40),
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.07,
                      height: 1.19,
                    ),
                    minimumSize: Size(screenWidth * 0.65, screenHeight * 0.06),
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
      backgroundColor: Color.fromARGB(255, 229, 229, 229),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Select language',
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                color: Colors.black,
                fontFamily: 'Inter',
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
          backgroundColor: Colors.white,
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
          'forgotPassword': 'Forgot your password?',
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
        backgroundColor: Colors.white,
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.05),
            ToggleButtonsContainer(
              isRegistrationSelected: isRegistrationSelected,
              onToggle: (isSelected) {
                setState(() {
                  isRegistrationSelected = isSelected;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.1),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: screenWidth * 0.8,
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: getText('name'),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    if (isRegistrationSelected) ...[
                      TextField(
                        decoration: InputDecoration(
                          labelText: getText('surname'),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      TextField(
                        decoration: InputDecoration(
                          labelText: getText('phone'),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                    TextField(
                      decoration: InputDecoration(
                        labelText: getText('password'),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    if (isRegistrationSelected) ...[
                      TextField(
                        decoration: InputDecoration(
                          labelText: getText('repeatPassword'),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: screenHeight * 0.1),
                    ],
                    Container(
                      width: screenWidth * 0.9,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuScreen(languageCode: widget.languageCode),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 176, 40, 40),
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
                    ),
                    if (!isRegistrationSelected) ...[
                      SizedBox(height: screenHeight * 0.01),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordRecoveryScreen(languageCode: widget.languageCode),
                            ),
                          );
                        },
                        child: Text(
                          getText('forgotPassword'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.035,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
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
        return {
          'phone': 'Número de telefone',
          'recoverPassword': 'Recuperar Senha',
        }[key]!;
      case 'fr':
        return {
          'phone': 'Numéro de téléphone',
          'recoverPassword': 'Récupérer le mot de passe',
        }[key]!;
      case 'es':
        return {
          'phone': 'Número de teléfono',
          'recoverPassword': 'Recuperar contraseña',
        }[key]!;
      case 'ht':
        return {
          'phone': 'Nimewo telefòn',
          'recoverPassword': 'Rèstore modpas la',
        }[key]!;
      case 'en':
      default:
        return {
          'phone': 'Phone number',
          'recoverPassword': 'Recover Password',
        }[key]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            'BOUS PAM',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: getText('phone'),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 1),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // ЗДЕСЬ ПОТОМ ЧЕ ДЕЛАТЬ С ВОССТАНОВЛЕНИЕМ
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 176, 40, 40),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                getText('recoverPassword'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
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
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: FractionallySizedBox(
                widthFactor: isRegistrationSelected ? 0.9 : 1.0,
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: isRegistrationSelected ? Colors.white : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7),
                  alignment: Alignment.center,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: isRegistrationSelected ? Colors.black : Colors.grey[700],
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: FractionallySizedBox(
                widthFactor: !isRegistrationSelected ? 0.9 : 1.0,
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: !isRegistrationSelected ? Colors.white : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 7),
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: !isRegistrationSelected ? Colors.black : Colors.grey[700],
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
                ),
                _buildAdaptiveButton(
                  context,
                  text: getText('savings'),
                  isSelected: false,
                ),
                _buildAdaptiveButton(
                  context,
                  text: getText('contribution'),
                  isSelected: false,
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


  Widget _buildAdaptiveButton(BuildContext context, {required String text, required bool isSelected}) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: () {
        if (text == getText('profile')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(languageCode: languageCode),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 226, 223, 223),
        elevation: 0,
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

