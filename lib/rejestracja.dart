import 'package:firststep/logowanie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;

class Rejestracja extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: Column(
        children: [
          SizedBox(
            height: 80, // Define a fixed height
            child: rive.RiveAnimation.asset(
              'assets/Animacje/neonowy_puls.riv',
              fit: BoxFit.scaleDown,
            ),
          ),
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
                  SizedBox(height: 20),
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
                  SizedBox(height: 20), // Dodano odstęp
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
                  SizedBox(height: 24),
                  // Przycisk logowania
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Akcja po naciśnięciu przycisku
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Przycisk logowania kliknięty!'),
                          ),
                        );

                        // przejście do menu głównego
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        'Zarejestruj',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Link do logowania
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Logowanie()),
                      );
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
        ],
      ),
    );
  }
}
