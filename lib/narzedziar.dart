import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NarzedziarPage extends StatefulWidget {
  const NarzedziarPage({super.key});

  @override
  State<NarzedziarPage> createState() => _NarzedziarPageState();
}

class _NarzedziarPageState extends State<NarzedziarPage> {
  final List<Map<String, String>> items = [
    {
      'image': 'assets/images/narzedziazdjecie.png',
      'name': 'Bandaż elastyczny',
      'description': 'Bandaż służy do stabilizacji i ochrony ran.',
    },
    {
      'image': 'assets/images/narzedziazdjecie.png',
      'name': 'Nożyczki ratownicze',
      'description':
          'Nożyczki do cięcia bandaży i ubrań w sytuacjach awaryjnych.',
    },
    {
      'image': 'assets/images/narzedziazdjecie.png',
      'name': 'Rękawiczki jednorazowe',
      'description':
          'Rękawiczki chroniące przed kontaktem z krwią i płynami ustrojowymi.',
    },
    {
      'image': 'assets/images/narzedziazdjecie.png',
      'name': 'Apteczka pierwszej pomocy',
      'description':
          'Zestaw podstawowych narzędzi i materiałów do udzielania pomocy.',
    },
  ];

  // Lista statusów dla każdego przedmiotu
  final List<bool> learnedStatus = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          // Nagłówek z linią
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

          Column(
            children: [
              // Napis "Poznaj sprzęt!"
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Poznaj sprzęt!',
                  style: GoogleFonts.itim(
                    color: Colors.white,
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Zdjęcie narzędzia z obsługą kliknięcia
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color(0xFF202020),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Przeglądaj Fiszki',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),

                                // Lista fiszek
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: const Color(0xFF303030),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ListTile(
                                          leading: Image.asset(
                                            items[index]['image']!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.contain,
                                          ),
                                          title: Text(
                                            items[index]['name']!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            items[index]['description']!,
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                          trailing: PopupMenuButton<String>(
                                            onSelected: (value) {
                                              setState(() {
                                                if (value == 'Nauczone') {
                                                  learnedStatus[index] = true;
                                                } else if (value == 'Do nauczenia') {
                                                  learnedStatus[index] = false;
                                                }
                                              });
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'Nauczone',
                                                child: Text('Nauczone'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'W trakcie nauki',
                                                child: Text('W trakcie nauki'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'Do nauczenia',
                                                child: Text('Do nauczenia'),
                                              ),
                                            ],
                                            icon: const Icon(Icons.more_vert, color: Colors.white),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Image.asset(
                  'assets/images/narzedziazdjecie.png',
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // Statystyki nauczonych przedmiotów
              Column(
                children: [
                  Text(
                    'Statystyki:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Nauczone przedmioty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.08),
                      const SizedBox(width: 10),
                      Text(
                        'Nauczone: ${learnedStatus.where((status) => status).length}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // W trakcie nauki
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hourglass_bottom, color: Colors.orange, size: screenWidth * 0.08),
                      const SizedBox(width: 10),
                      Text(
                        'W trakcie nauki: ${items.length - learnedStatus.where((status) => status).length - learnedStatus.where((status) => !status).length}',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Do nauczenia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: screenWidth * 0.08),
                      const SizedBox(width: 10),
                      Text(
                        'Do nauczenia: ${learnedStatus.where((status) => !status).length}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Pasek postępu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: LinearProgressIndicator(
                      value: learnedStatus.where((status) => status).length / items.length,
                      backgroundColor: Colors.grey[800],
                      color: Colors.green,
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Postęp: ${(learnedStatus.where((status) => status).length / items.length * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
