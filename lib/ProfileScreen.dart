import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map<String, String>> fetchUserData(String token) async {
  final url = Uri.parse('http://server.bouspam.yusim.space/user/profile');

  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return {
      'name': data['name'] ?? 'Unknown',
      'surname': data['surname'] ?? 'Unknown',
      'phone': data['phone'] ?? 'Unknown',
    };
  } else {
    throw Exception('Failed to load user data');
  }
}


class ProfileScreen extends StatefulWidget {
  final String languageCode;

  ProfileScreen({required this.languageCode});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String get languageCode => widget.languageCode;

  Map<String, String> userInfo = {
    'phoneNumber': '+ XXX XXX XX XX',
    'email': 'Add',
    'passportNumber': 'Add',
    'niu': 'Add',
    'nif': 'Add',
    'password': '********',
  };

  String getText(String key) {
    switch (languageCode) {
      case 'pt':
        return {
          'profile': 'Perfil',
          'phoneNumber': 'Número de telefone',
          'email': 'E-mail',
          'passportNumber': 'Número do passaporte',
          'niu': 'NIU',
          'nif': 'NIF',
          'password': 'Senha',
          'nameSurname': 'Nome Sobrenome',
          'addInfo': 'Adicionar Informação',
          'enterInfo': 'Insira sua informação',
          'continue': 'Continuar',
        }[key]!;
      case 'fr':
        return {
          'profile': 'Profil',
          'phoneNumber': 'Numéro de téléphone',
          'email': 'E-mail',
          'passportNumber': 'Numéro de passeport',
          'niu': 'NIU',
          'nif': 'NIF',
          'password': 'Mot de passe',
          'nameSurname': 'Nom Prénom',
          'addInfo': 'Ajouter des informations',
          'enterInfo': 'Entrez votre information',
          'continue': 'Continuer',
        }[key]!;
      case 'ht':
        return {
          'profile': 'Pwofil',
          'phoneNumber': 'Nimewo telefòn',
          'email': 'Imèl',
          'passportNumber': 'Nimewo paspò',
          'niu': 'NIU',
          'nif': 'NIF',
          'password': 'Modpas',
          'nameSurname': 'Non Surnon',
          'addInfo': 'Ajoute enfòmasyon',
          'enterInfo': 'Antre enfòmasyon ou',
          'continue': 'Kontinye',
        }[key]!;
      case 'es':
        return {
          'profile': 'Perfil',
          'phoneNumber': 'Número de Teléfono',
          'email': 'E-mail',
          'passportNumber': 'Número de Pasaporte',
          'niu': 'NIU',
          'nif': 'NIF',
          'password': 'Contraseña',
          'nameSurname': 'Nombre Apellido',
          'addInfo': 'Agregar información',
          'enterInfo': 'Ingrese su información',
          'continue': 'Continuar',
        }[key]!;
      case 'en':
      default:
        return {
          'profile': 'Profile',
          'phoneNumber': 'Phone Number',
          'email': 'E-mail',
          'passportNumber': 'Passport Number',
          'niu': 'NIU',
          'nif': 'NIF',
          'password': 'Password',
          'nameSurname': 'Name Surname',
          'addInfo': 'Add Information',
          'enterInfo': 'Enter your information',
          'continue': 'Continue',
        }[key]!;
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 175, 175, 175),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 175, 175, 175),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(138, 123, 137, 0.5),
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.1,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    getText('nameSurname'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileField(
                    context,
                    getText('phoneNumber'),
                    userInfo['phoneNumber']!,
                  ),
                  _buildProfileField(
                    context,
                    getText('email'),
                    userInfo['email']!,
                    onTap: () {
                      _showDialog(context, getText('email'), 'email');
                    },
                  ),
                  _buildProfileField(
                    context,
                    getText('passportNumber'),
                    userInfo['passportNumber']!,
                    onTap: () {
                      _showDialog(context, getText('passportNumber'), 'passportNumber');
                    },
                  ),
                  _buildProfileField(
                    context,
                    getText('niu'),
                    userInfo['niu']!,
                    onTap: () {
                      _showDialog(context, getText('niu'), 'niu');
                    },
                  ),
                  _buildProfileField(
                    context,
                    getText('nif'),
                    userInfo['nif']!,
                    onTap: () {
                      _showDialog(context, getText('nif'), 'nif');
                    },
                  ),
                  _buildProfileField(
                    context,
                    getText('password'),
                    userInfo['password']!,
                    showChangeButton: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildProfileField(
      BuildContext context,
      String title,
      String value, {
        VoidCallback? onTap,
        bool showChangeButton = false,
      }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.04,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 229, 229, 229),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
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
                    onTap: onTap,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: value == "Add"
                            ? const Color.fromARGB(255, 187, 103, 0)
                            : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showChangeButton)
              GestureDetector(
                onTap: () {
                  _showChangePasswordDialog(context);
                },
                child: Text(
                  'Change',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: const Color.fromARGB(255, 187, 103, 0),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String inputType, String key) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            inputType,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  labelText: getText('enterInfo'),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(168, 95, 4, 1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                onPressed: () {
                  setState(() {
                    userInfo[key] = controller.text;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  getText('continue'),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'Changing the password',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Old password',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New password',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Repeat new password',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 187, 103, 0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Add logic to save the new password here.
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}