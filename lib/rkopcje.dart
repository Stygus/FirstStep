import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RkOpcje extends StatelessWidget {
  const RkOpcje({super.key});

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
      // Dodajemy SingleChildScrollView, aby umożliwić przewijanie zawartości
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 20), // Zmniejszony odstęp
              Text(
                textAlign: TextAlign.center,
                'Dorośli i starsze dzieci',
                style: GoogleFonts.itim(
                  fontSize: 24,
                  fontWeight: FontWeight.values[4],
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10), // Zmniejszony odstęp
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RkOpcje()),
                  );
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                  ),
                  child: Image.asset(
                    'assets/images/dorosli.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 30), // Zmniejszony odstęp
              Text(
                textAlign: TextAlign.center,
                'Dzieci do 5 roku życia',
                style: GoogleFonts.itim(
                  fontSize: 24,
                  fontWeight: FontWeight.values[4],
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10), // Zmniejszony odstęp
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RkOpcje()),
                  );
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                  ),
                  child: Image.asset(
                    'assets/images/dzieckom.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 30), // Zmniejszony odstęp
              Text(
                textAlign: TextAlign.center,
                'Niemowlaki',
                style: GoogleFonts.itim(
                  fontSize: 24,
                  fontWeight: FontWeight.values[4],
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10), // Zmniejszony odstęp
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RkOpcje()),
                  );
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.25,
                  ),
                  child: Image.asset(
                    'assets/images/niemowlak.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20), // Dodany odstęp na końcu
            ],
          ),
        ),
      ),
    );
  }
}
