import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RkOpcje extends StatelessWidget {
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
              'Dorośli i starsze dzieci',
              style: GoogleFonts.itim(
                fontSize: 24,
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
                  double imageSize = constraints.maxWidth * 0.4;
                  return Image.asset(
                    'assets/images/dorosli.png',
                    height: imageSize,
                    width: imageSize,
                  );
                },
              ),
            ),
            SizedBox(height: 80),
            Text(
              textAlign: TextAlign.center,
              'Dzieci do 5 roku życia',
              style: GoogleFonts.itim(
                fontSize: 24,
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
                  double imageSize = constraints.maxWidth * 0.4;
                  return Image.asset(
                    'assets/images/dzieckom.png',
                    height: imageSize,
                    width: imageSize,
                  );
                },
              ),
            ),
            SizedBox(height: 80),
            Text(
              textAlign: TextAlign.center,
              'Niemowlaki',
              style: GoogleFonts.itim(
                fontSize: 24,
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
                  double imageSize = constraints.maxWidth * 0.4;
                  return Image.asset(
                    'assets/images/niemowlak.png',
                    height: imageSize,
                    width: imageSize,
                  );
                },
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
