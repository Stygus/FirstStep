import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;

class Logowanie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logowanie',
              style: GoogleFonts.roboto(
                fontSize: 32,
                fontWeight: FontWeight.values[3],
                color: Colors.white,
                height: 1,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0x101010),
      ),
      backgroundColor: Color(0x101010),
      body: Column(
        children: [
          rive.RiveAnimation.asset(
            'assets/Animacje/neonowy_puls.riv',
          ),
          // Image.asset(
          //   'assets/images/linia.png', // Ścieżka do obrazu
          //   height: 50, // Wysokość obrazu
          //   width: 1000, // Wysokość obrazu
          //   fit: BoxFit.cover,
          // ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),

                  Image.asset(
                    'assets/images/logod.png',
                    height: 180,
                    width: 180,
                  ),
                  SizedBox(height: 20),
                  // Tytuł aplikacji

                  SizedBox(height: 20), // Zwiększono odstęp
                  // Pole do wpisania adresu e-mail
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
                  SizedBox(height: 25), // Zwiększono odstęp
                  // Pole do wpisania hasła
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
                  SizedBox(height: 24), // Zwiększono odstęp
                  // Przycisk logowania
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Akcja po naciśnięciu przycisku
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Przycisk logowania kliknięty!')),
                        );

                        // przejście do menu głównego
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Poziomy prostokąt plusa
                          Container(
                            width: 110,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          // Pionowy prostokąt plusa
                          Container(
                            width: 50,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          // Tekst na przycisku
                          Text(
                            'Zaloguj',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Link do rejestracji
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
        ],
      ),
    );
  }
}
