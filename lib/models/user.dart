import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier {
  String id;
  String name;
  String email;
  DateTime lastLogin;
  int courseCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.lastLogin,
    required this.courseCount,
  });

  Future<void> setUser(User user) async {
    id = user.id;
    name = user.name;
    email = user.email;
    lastLogin = user.lastLogin;
    courseCount = user.courseCount;
    notifyListeners();
  }

  Future<User?> authorize(String? token) async {
    final url = Uri.parse('http://83.27.64.223:3000/auth/authenticate');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        saveToken("");
        return null;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      User user = User(
        id: responseData['id'],
        name: responseData['pseudonim'],
        email: responseData['email'],
        lastLogin: DateTime.parse(responseData['dataOstatniegoLogowania']),
        courseCount: responseData['iloscKursow'],
      );

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse('http://83.27.64.223:3000/auth/login');
    User? user;
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        await saveToken(responseData['token']);

        user = await authorize(responseData['token']);
        setUser(user!);
      } else {
        debugPrint('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse('http://83.27.64.223:3000/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      debugPrint(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    saveToken("");
    setUser(
      User(
        id: '-1',
        name: '',
        email: '',
        lastLogin: DateTime.now(),
        courseCount: 0,
      ),
    );
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
}
