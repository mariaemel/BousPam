import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final String languageCode;

  MainScreen({required this.languageCode});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double _accountBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAccountBalance();
  }

  Future<void> _fetchAccountBalance() async {
    try {
      final response = await http.get(Uri.parse('http://server.bouspam.yusim.space/api/account_balance'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _accountBalance = data['balance'];
        });
      } else {
        throw Exception('Ошибка при загрузке данных');
      }
    } catch (e) {
      setState(() {
        _accountBalance = 0.0;
      });
      print('Ошибка: $e');
    }
  }

  String getText(String key) {
    switch (widget.languageCode) {
      case 'pt':
        return {
          'onAccount': 'NA CONTA',
          'pay': 'Pagar',
          'topUp': 'Recarregar',
          'historyOfOperations': 'Histórico de operações',
        }[key]!;
      case 'fr':
        return {
          'onAccount': 'SUR LE COMPTE',
          'pay': 'Payer',
          'topUp': 'Recharger',
          'historyOfOperations': 'Historique des opérations',
        }[key]!;
      case 'ht':
        return {
          'onAccount': 'NAN KONT',
          'pay': 'Peye',
          'topUp': 'Refè balans',
          'historyOfOperations': 'Istwa operasyon yo',
        }[key]!;
      case 'es':
        return {
          'onAccount': 'EN LA CUENTA',
          'pay': 'Pagar',
          'topUp': 'Recargar',
          'historyOfOperations': 'Historial de operaciones',
        }[key]!;
      case 'en':
      default:
        return {
          'onAccount': 'ON ACCOUNT',
          'pay': 'Pay',
          'topUp': 'Top up',
          'historyOfOperations': 'History of operations',
        }[key]!;
    }
  }

  Future<Map<String, List<String>>> fetchHistory() async {
    await Future.delayed(Duration(seconds: 1));
    return {
    };
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
                          _accountBalance.toStringAsFixed(2),
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
                  child: FutureBuilder<Map<String, List<String>>>(
                    future: fetchHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading history'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No history available'));
                      }

                      final historyData = snapshot.data!;
                      return ListView(
                        children: historyData.entries.map((entry) {
                          final date = entry.key;
                          final operations = entry.value;

                          return _buildHistorySection(
                            context,
                            title: date,
                            content: Column(
                              children: operations.map((operation) => _buildHistoryItem(operation)).toList(),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAccountBalance,
        child: Icon(Icons.refresh),
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

  Widget _buildHistoryItem(String operation) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
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
        child: Text(
          operation,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}