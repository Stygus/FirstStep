import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class KursyPage extends StatelessWidget {
  const KursyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xFF101010),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Kursy',
                      style: GoogleFonts.itim(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * (3 / 16),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.bottomCenter,
                        image: AssetImage('assets/images/linia.png'),
                        fit: BoxFit.fill,
                        isAntiAlias: false,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Prosta karuzela 2 zdjęć
          Center(
            child: SizedBox(
              height: 200, // Zmniejszono wysokość, aby lepiej dopasować obrazki
              child: Container(
                color: Color(0xFF1D1D1D),
                child: PageView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0), // Zmniejszono padding
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // Dodano zaokrąglenie
                        child: Image.asset(
                          'assets/images/N1.png',
                          fit: BoxFit.contain, // Dopasowanie obrazu
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0), // Zmniejszono padding
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // Dodano zaokrąglenie
                        child: Image.asset(
                          'assets/images/N2.png',
                          fit: BoxFit.contain, // Dopasowanie obrazu
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Text(
                    'Kursy\n Już wkrótce!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/logod.png',
                    height: 200,
                    width: 200,
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
