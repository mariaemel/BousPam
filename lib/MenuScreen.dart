import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'ProfileScreen.dart';


class MenuScreen extends StatefulWidget {
  final String languageCode;
  final int userId;

  MenuScreen({required this.languageCode, required this.userId});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>  {
  late int _userId;
  String _userName = '';
  String _userSurname = '';

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://server.bouspam.yusim.space/user/$_userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userName = data['name'] ?? 'Unknown';
          _userSurname = data['surname'] ?? 'Unknown';
        });
      } else {
        throw Exception('Error fetching user details');
      }
    } catch (e) {
      setState(() {
        _userName = 'Unknown';
        _userSurname = 'Unknown';
      });
      print('Error: $e');
    }
  }

  String getText(String key) {
    switch (widget.languageCode) {
      case 'pt':
        return {
          'profile': 'Perfil',
          'savings': 'Poupança',
          'contribution': 'Contribuição',
        }[key]!;
      case 'fr':
        return {
          'profile': 'Profil',
          'savings': 'Épargne',
          'contribution': 'Contribution',
        }[key]!;
      case 'ht':
        return {
          'profile': 'Pwofil',
          'savings': 'Kach',
          'contribution': 'Kondwit',
        }[key]!;
      case 'es':
        return {
          'profile': 'Perfil',
          'savings': 'Ahorros',
          'contribution': 'Contribución',
        }[key]!;
      case 'en':
      default:
        return {
          'profile': 'Profile',
          'savings': 'Savings',
          'contribution': 'Contribution',
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
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/menuscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(48, 38, 47, 0.56),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.09,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Text(
                        '$_userName $_userSurname',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.08),
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
                                ProfileScreen(languageCode: widget.languageCode),
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
                                MainScreen(languageCode: widget.languageCode, userId: _userId),
                          ),
                        );
                      },
                    ),
                    _buildAdaptiveButton(
                      context,
                      text: getText('contribution'),
                      isSelected: false,
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.08),
                Container(
                  width: screenWidth,
                  height: 5.0,
                  color: Color.fromARGB(255, 139, 136, 143),
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
                            borderRadius:
                            BorderRadius.circular(screenWidth * 0.03),
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
        ],
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
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(187, 103, 0, 0.79),
        elevation: isSelected ? 2 : 0,
        minimumSize: Size(screenWidth * 0.05, screenHeight * 0.06),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.035,
          vertical: screenHeight * 0.015,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}