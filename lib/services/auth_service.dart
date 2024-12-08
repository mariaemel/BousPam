import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> registerUser(String name, String surname, String phone, String password, String password2) async {
  final url = Uri.parse('http://127.0.0.1:8000/registration/');
  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    "name": name,
    "surname": surname,
    "password": password,
    "phone_number": phone,
    "password2": password2,
  });

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
