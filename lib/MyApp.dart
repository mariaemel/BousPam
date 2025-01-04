import 'package:flutter/material.dart';

import 'WelcomeScreen.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.grey),
      home: WelcomeScreen(),
    );
  }
}