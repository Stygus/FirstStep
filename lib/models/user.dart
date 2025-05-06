import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // Dodano import
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as enc;

// Utworzenie właściwego klienta HTTP w zależności od platformy
late http.Client client;

void initializeHttpClient() {
  if (kIsWeb) {
    // Użyj standardowego klienta HTTP dla platformy web
    client = http.Client();
    debugPrint('Inicjalizacja standardowego klienta HTTP dla web');
  } else {
    // Użyj IOClient dla platform natywnych z obsługą niestandardowych certyfikatów
    HttpClient httpClient =
        HttpClient()
          ..badCertificateCallback = (
            X509Certificate cert,
            String host,
            int port,
          ) {
            // Ignorowanie błędów certyfikatu
            debugPrint("Pomijanie błędu certyfikatu dla hosta: $host");
            return true;
          };
    client = IOClient(httpClient);
    debugPrint('Inicjalizacja IOClient dla platformy natywnej');
  }
}

class User extends ChangeNotifier {
  String id;
  String nickname;
  String email;
  DateTime lastLoginDate;
  String role;

  User({
    required this.id,
    required this.nickname,
    required this.email,
    required this.lastLoginDate,
    required this.role,
  });

  Future<void> setUser(User user) async {
    id = user.id;
    nickname = user.nickname;
    email = user.email;
    lastLoginDate = user.lastLoginDate;
    role = user.role;
    notifyListeners();
  }

  Future<User?> authorize(String? token) async {
    // Upewnij się, że klient HTTP jest zainicjalizowany
    final url = Uri.parse('${dotenv.env['SERVER_URL']!}/auth/authenticate');
    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      User user = User(
        id: responseData['id'],
        nickname: responseData['nickname'],
        email: responseData['email'],
        lastLoginDate: DateTime.parse(responseData['lastLoginDate']),
        role: responseData['role'],
      );
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    final url = Uri.parse('${dotenv.env['SERVER_URL']!}/auth/login');
    User? user;
    final key = enc.Key.fromUtf8(dotenv.env['SECRET_KEY']!);
    enc.Encrypter encrypt = enc.Encrypter(enc.AES(key));
    final hashedPassword =
        encrypt.encrypt(password, iv: enc.IV.fromLength(16)).base64;

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        await saveToken(responseData['token']);

        user = await authorize(responseData['token']);
        if (user != null) {
          await setUser(user);
        }
        return response.statusCode;
      } else {
        debugPrint('Failed to sign in: ${response.statusCode}');
        if (response.body.contains("Invalid credentials")) {
          // Użyj mounted, aby sprawdzić czy context jest aktywny
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Złe dane logowania!')));
          }
        } else {
          // Zamiast throw, tylko loguj błąd, by nie przerywać działania
          debugPrint('Unknown error podczas logowania');
        }
      }
      return response.statusCode;
    } catch (e) {
      debugPrint('Błąd podczas logowania: $e');
    }
    return 500; // Zwróć kod błędu 500 w przypadku wyjątku
  }

  Future<void> signUp(String email, String password, String nickname) async {
    final url = Uri.parse('${dotenv.env['SERVER_URL']!}/auth/register');
    try {
      final key = enc.Key.fromUtf8(dotenv.env['SECRET_KEY']!);
      enc.Encrypter encrypt = enc.Encrypter(enc.AES(key));
      final hashedPassword =
          encrypt.encrypt(password, iv: enc.IV.fromLength(16)).toString();

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': hashedPassword,
          'nickname': nickname,
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await saveToken("");

    setUser(
      User(
        id: '-1',
        nickname: '',
        email: '',
        lastLoginDate: DateTime.now(),
        role: '',
      ),
    );
    notifyListeners();
    debugPrint('User signed out');
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    debugPrint('Token zapisany w SharedPreferences');
  }
}
