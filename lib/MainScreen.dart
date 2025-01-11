import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  final String languageCode;
  final int userId;

  MainScreen({required this.languageCode, required this.userId});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double _accountBalance = 0.0;
  late int _userId;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _fetchAccountBalance();
  }

  Future<void> _fetchAccountBalance() async {
    try {
      final response = await http.get(
        Uri.parse('http://server.bouspam.yusim.space/balance/$_userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is num) {
          setState(() {
            _accountBalance = data.toDouble();
          });
        } else {
          print("Balance is not a valid number in the response");
          setState(() {
            _accountBalance = 0.0;
          });
        }
      } else {
        print('Error fetching account balance: Status Code ${response.statusCode}');
        setState(() {
          _accountBalance = 0.0;
        });
      }
    } catch (e) {
      print('Exception occurred while fetching account balance: $e');
      setState(() {
        _accountBalance = 0.0;
      });
    }
  }




  Future<Map<String, List<Map<String, dynamic>>>> fetchHistory() async {
    try {
      final response = await http.get(
        Uri.parse('http://server.bouspam.yusim.space/operations_user/$_userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;

        if (data.isEmpty) {
          return {};
        }

        final Map<String, List<Map<String, dynamic>>> groupedHistory = {};
        for (var operation in data) {
          final dateTime = DateTime.parse(operation['datetime']);
          final date = dateTime.toLocal().toIso8601String().split('T').first;
          final description = {
            'type': operation['type'],
            'bank_name': operation['bank_name'] ?? 'Unknown Bank',
            'balance_change': operation['balance_change'],
          };

          if (!groupedHistory.containsKey(date)) {
            groupedHistory[date] = [];
          }
          groupedHistory[date]?.add(description);
        }
        return groupedHistory;
      } else {
        throw Exception('Error fetching operations history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching history: $e');
      return {};
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
          'type': 'Tipo',
          'bank': 'Banco',
          'balanceChange': 'Alteração de saldo',
        }[key]!;
      case 'fr':
        return {
          'onAccount': 'SUR LE COMPTE',
          'pay': 'Payer',
          'topUp': 'Recharger',
          'historyOfOperations': 'Historique des opérations',
          'type': 'Type',
          'bank': 'Banque',
          'balanceChange': 'Changement de solde',
        }[key]!;
      case 'ht':
        return {
          'onAccount': 'NAN KONT',
          'pay': 'Peye',
          'topUp': 'Refè balans',
          'historyOfOperations': 'Istwa operasyon yo',
          'type': 'Kalite',
          'bank': 'Bank',
          'balanceChange': 'Chanjman nan balans',
        }[key]!;
      case 'es':
        return {
          'onAccount': 'EN LA CUENTA',
          'pay': 'Pagar',
          'topUp': 'Recargar',
          'historyOfOperations': 'Historial de operaciones',
          'type': 'Tipo',
          'bank': 'Banco',
          'balanceChange': 'Cambio de saldo',
        }[key]!;
      case 'en':
      default:
        return {
          'onAccount': 'ON ACCOUNT',
          'pay': 'Pay',
          'topUp': 'Top up',
          'historyOfOperations': 'History of operations',
          'type': 'Type',
          'bank': 'Bank',
          'balanceChange': 'Balance Change',
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
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
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
                  child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                    future: fetchHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading history: ${snapshot.error}'));
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
                )
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
        Container(
          width: double.infinity,
          color: Color.fromRGBO(138, 123, 137, 0.8),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: screenWidth * 0.03),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        content,
      ],
    );
  }


  Widget _buildHistoryItem(Map<String, dynamic> operation) {
    final type = operation['type'];
    final bankName = operation['bank_name'];
    final balanceChange = operation['balance_change'];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${getText('type')}: $type', style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('${getText('bank')}: $bankName', style: TextStyle(fontSize: 16, color: Colors.black)),
            Text('${getText('balanceChange')}: $balanceChange', style: TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }

}
