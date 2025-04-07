import 'package:flutter/material.dart';

class RKO extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Ustawiono czarne tło
      appBar: AppBar(
        backgroundColor: Colors.black, // Dopasowano kolor tła
        elevation: 0, // Usunięto cień
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Strzałka powrotu
          onPressed: () {
            Navigator.pop(context); // Powrót do poprzedniego ekranu
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logod.png', // Dodano zdjęcie logod.png
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Już wkrótce', // Dodano duży napis
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
