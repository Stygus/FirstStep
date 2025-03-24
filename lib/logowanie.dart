import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logowanie extends ConsumerWidget {
  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    user.getToken().then((token) {
      if (token != null) {
        user.authorize(token).then((user) {
          if (user != null) {
            ref.read(userProvider).setUser(user);
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('Logowanie')),
      backgroundColor: Color(0x101010),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'FirstStep',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Adres e-mail',
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Hasło',
                  labelStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                style: TextStyle(color: Colors.black),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Logika logowania
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF27813A),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Zaloguj się',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/rejestracja');
                  },
                  child: Text(
                    'Nie masz konta? \n Zarejestruj się',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
