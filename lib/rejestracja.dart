import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Rejestracja extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Rejestracja',
          style: GoogleFonts.roboto(
            fontSize: 32,
            fontWeight: FontWeight.values[3],
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0x101010),
      ),
      backgroundColor: Color(0x101010),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tytuł aplikacji
              Text(
                'FirstStep',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              // Pole do wpisania nazwy konta
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nazwa konta*',
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
              // Pole do wpisania adresu e-mail
              TextField(
                decoration: InputDecoration(
                  labelText: 'Adres e-mail*',
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
              SizedBox(height: 16),
              // Pole do wpisania hasła
              TextField(
                decoration: InputDecoration(
                  labelText: 'Hasło*',
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
              // Przycisk rejestracji
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Logika rejestracji
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF27813A),
                  ),
                  child: Text(
                    'Zarejestruj się',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Link do logowania
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/logowanie');
                },
                child: Text(
                  'Masz już konto? \n Zaloguj się',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
