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
                  // Po kliknięciu otwiera szczegóły pierwszego elementu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => FiszkaDetailsPage(
                            item:
                                items[0], // Wyświetla pierwszy element z listy
                            onStatusChange: (String status) {
                              setState(() {
                                if (status == 'Nauczone') {
                                  learnedStatus[0] = true;
                                } else if (status == 'Do nauczenia') {
                                  learnedStatus[0] = false;
                                }
                              });
                            },
                          ),
                    ),
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
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: screenWidth * 0.08,
                      ),
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
                      Icon(
                        Icons.hourglass_bottom,
                        color: Colors.orange,
                        size: screenWidth * 0.08,
                      ),
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
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: screenWidth * 0.08,
                      ),
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
                      value:
                          learnedStatus.where((status) => status).length /
                          items.length,
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

class FiszkaDetailsPage extends StatelessWidget {
  final Map<String, String> item;
  final Function(String) onStatusChange;

  const FiszkaDetailsPage({
    super.key,
    required this.item,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']!, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1D1D1D),
      ),
      backgroundColor: const Color(0xFF101010),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    item['image']!,
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  item['description']!,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Zielony przycisk z "ptaszkiem"
                    ElevatedButton.icon(
                      onPressed: () {
                        onStatusChange('Nauczone');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(''),
                    ),

                    // Pomarańczowy przycisk z klepsydrą
                    ElevatedButton.icon(
                      onPressed: () {
                        onStatusChange('W trakcie nauki');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      icon: const Icon(Icons.hourglass_bottom, color: Colors.white),
                      label: const Text(''),
                    ),

                    // Czerwony przycisk z "X"
                    ElevatedButton.icon(
                      onPressed: () {
                        onStatusChange('Do nauczenia');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(''),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
