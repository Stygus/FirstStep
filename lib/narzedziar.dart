import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NarzedziarPage extends StatelessWidget {
  const NarzedziarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, String>> items = [
      {
        'image': 'assets/images/bandage.png',
        'name': 'Bandaż elastyczny',
        'description': 'Bandaż służy do stabilizacji i ochrony ran.',
      },
      {
        'image': 'assets/images/scissors.png',
        'name': 'Nożyczki ratownicze',
        'description':
            'Nożyczki do cięcia bandaży i ubrań w sytuacjach awaryjnych.',
      },
      {
        'image': 'assets/images/gloves.png',
        'name': 'Rękawiczki jednorazowe',
        'description':
            'Rękawiczki chroniące przed kontaktem z krwią i płynami ustrojowymi.',
      },
      {
        'image': 'assets/images/first_aid_kit.png',
        'name': 'Apteczka pierwszej pomocy',
        'description':
            'Zestaw podstawowych narzędzi i materiałów do udzielania pomocy.',
      },
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 30,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF101010),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.1,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.001),
                    child: Text(
                      'Narzędzia Ratownika',
                      style: GoogleFonts.itim(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: screenWidth * 0.15,
                    decoration: const BoxDecoration(
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

          Expanded(
            child: PageView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Zdjęcie przedmiotu
                      Image.asset(
                        item['image']!,
                        height: screenHeight * 0.3,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      // Nazwa przedmiotu
                      Text(
                        item['name']!,
                        style: GoogleFonts.itim(
                          color: Colors.white,
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      // Opis przedmiotu
                      Text(
                        item['description']!,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: screenWidth * 0.045,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
