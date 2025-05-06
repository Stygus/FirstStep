import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rkopcje.dart'; // Import widgetu rkopcje.dart

class RKO extends StatelessWidget {
  const RKO({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: Color(0xFF101010),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              'Rozpocznij proces RKO',
              style: GoogleFonts.itim(
                fontSize: 45,
                fontWeight: FontWeight.values[4],
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RkOpcje()),
                );
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double imageSize = constraints.maxWidth * 0.7;
                  return Image.asset(
                    'assets/images/rko1.png',
                    height: imageSize,
                    width: imageSize,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
