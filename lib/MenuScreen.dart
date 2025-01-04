import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainScreen.dart';
import 'ProfileScreen.dart';

Future<int> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId') ?? 0;
}

class MenuScreen extends StatelessWidget {
  final String languageCode;
  final String? name;
  final String? surname;

  MenuScreen({
    required this.languageCode,
    this.name,
    this.surname,
  });

  String getText(String key) {
    switch (languageCode) {
      case 'pt':
        return {
          'profile': 'Perfil',
          'savings': 'Poupança',
          'contribution': 'Contribuição',
          'nameSurname': '$name $surname',
        }[key]!;
      case 'fr':
        return {
          'profile': 'Profil',
          'savings': 'Épargne',
          'contribution': 'Contribution',
          'nameSurname': '$name $surname',
        }[key]!;
      case 'ht':
        return {
          'profile': 'Pwofil',
          'savings': 'Kach',
          'contribution': 'Kondwit',
          'nameSurname': '$name $surname',
        }[key]!;
      case 'es':
        return {
          'profile': 'Perfil',
          'savings': 'Ahorros',
          'contribution': 'Contribución',
          'nameSurname': '$name $surname',
        }[key]!;
      case 'en':
      default:
        return {
          'profile': 'Profile',
          'savings': 'Savings',
          'contribution': 'Contribution',
          'nameSurname': '$name $surname',
        }[key]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<int>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading user ID'));
        } else if (!snapshot.hasData || snapshot.data == 0) {
          return Center(child: Text('User ID not found'));
        }

        int userId = snapshot.data!;

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
                            '$name $surname',
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
                                    MainScreen(languageCode: languageCode, userId: userId),
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
      },
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