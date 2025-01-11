import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> fetchUserData(int userId) async {
  final url = Uri.parse('http://server.bouspam.yusim.space/user/$userId');
  final response = await http.get(url, headers: {'accept': 'application/json'});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return {
      'name': data['name'] ?? 'Unknown',
      'surname': data['surname'] ?? 'Unknown',
      'phone': data['phone_number'] ?? 'Unknown',
    };
  } else {
    throw Exception('Failed to load user data: ${response.body}');
  }
}

Map<String, String> parseUserData(String responseBody) {
  final Map<String, dynamic> data = json.decode(responseBody);
  print('Parsed data: $data');

  return {
    'name': data['name'] ?? 'No name',
    'surname': data['surname'] ?? 'No surname',
    'phoneNumber': data['phone_number'] ?? 'N/A',
    'password': '********',
    'e_mail': data['e_mail'] ?? 'N/A',
    'passportNumber': data['passport_number'] ?? 'N/A',
    'niu': data['snils'] ?? 'N/A',
    'nif': data['inn'] ?? 'N/A',
  };
}


class ProfileScreen extends StatefulWidget {
  final String languageCode;

  ProfileScreen({required this.languageCode});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String get languageCode => widget.languageCode;
  bool isLoading = true;
  String errorMessage = '';
  String userId = '';

  Map<String, String> userInfo = {
    'name': 'Loading...',
    'surname': 'Loading...',
    'phone_name': 'Loading...',
  };

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUserData();
  }

  Future<void> _updateUserData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');
    if (userId == null) {
      print('User ID not found');
      return;
    }

    final url = Uri.parse('http://server.bouspam.yusim.space/user/$userId');

    final requestBody = {
      'name': userInfo['name'] ?? '',
      'surname': userInfo['surname'] ?? '',
      'password': userInfo['password'] ?? '',
      'phone_number': userInfo['phoneNumber'],
      'e_mail': userInfo['e_mail'] ?? '',
      'passport_number': userInfo['passportNumber'] ?? '',
      'snils': userInfo['niu'] ?? '',
      'inn': userInfo['nif'] ?? '',
    };

    requestBody[key] = value;

    try {
      final response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Data updated successfully');
        setState(() {
          userInfo[key] = value;
        });
      } else {
        print('Failed to update data: ${response.statusCode}, ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update data')));
      }
    } catch (e) {
      print('Error sending data: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error sending data')));
    }
  }




  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');
    if (userId == null) {
      print('User ID not found');
      return;
    }

    final url = Uri.parse('http://server.bouspam.yusim.space/user/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userInfo = parseUserData(response.body);
        });
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> _loadUserProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');

    if (userId != null) {
      try {
        final userData = await fetchUserData(userId);
        setState(() {
          userInfo = userData;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User ID not found')));
    }
  }

  String getText(String key) {
    switch (languageCode) {
      case 'pt':
        return {
          'profile': 'Perfil',
          'phoneNumber': 'Número de telefone',
          'e_mail': 'E-mail',
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
          'e_mail': 'E-mail',
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
          'e_mail': 'Imèl',
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
          'e_mail': 'E-mail',
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
          'e_mail': 'E-mail',
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
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.05),
              ),
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
                    '${userInfo['name']} ${userInfo['surname']}',
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
                    '${userInfo['phoneNumber']}',
                  ),
                  _buildProfileField(
                    context,
                    getText('e_mail'),
                    userInfo['e_mail'] ?? 'N/A',
                    onTap: () {
                      _showDialog(context, getText('e_mail'), 'e_mail');
                    },
                  ),
                  _buildProfileField(
                    context,
                    getText('passportNumber'),
                    userInfo['passportNumber'] ?? 'N/A',
                    onTap: () {
                      _showDialog(context, getText('passportNumber'), 'passportNumber');
                    },
                  ),
                  _buildProfileField(
                    context,
                    getText('niu'),
                    userInfo['niu'] ?? 'N/A',
                    onTap: () {
                      _showDialog(context, getText('niu'), 'niu');
                    },
                  ),
                  _buildProfileField(
                    context,
                    getText('nif'),
                    userInfo['nif'] ?? 'N/A',
                    onTap: () {
                      _showDialog(context, getText('nif'), 'nif');
                    },
                  ),
                  _buildProfileField(
                    context,
                    getText('password'),
                    userInfo['password'] ?? '*********',
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
                    onTap: (title != getText('phoneNumber')) ? onTap : null,
                    child: Text(
                      value == "N/A" ? "Add" : value,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: value == "N/A"
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

  void _showDialog(BuildContext context, String inputType, String key) async {
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
                  labelText: 'Enter Info',
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getInt('id');

                  if (userId != null) {
                    final value = controller.text;

                    if (value.isNotEmpty) {
                      await _updateUserData(key, value);

                      setState(() {
                        userInfo[key] = value;
                      });

                      Navigator.pop(context);
                    } else {
                      print('Input is empty');
                    }
                  } else {
                    print('User ID not found');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User ID not found')),
                    );
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 14),
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