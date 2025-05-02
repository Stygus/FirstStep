import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KursyPage extends StatelessWidget {
  const KursyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Kursy\n Już wkrótce!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 60),
            Image.asset('assets/images/logod.png', height: 200, width: 200),
          ],
        ),
      ),
    );
  }
}
