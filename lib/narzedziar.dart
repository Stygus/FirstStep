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
      'description': 'Nożyczki do cięcia bandaży i ubrań w sytuacjach awaryjnych.',
    },
    {
      'image': 'assets/images/narzedziazdjecie.png',
      'name': 'Rękawiczki jednorazowe',
      'description': 'Rękawiczki chroniące przed kontaktem z krwią i płynami ustrojowymi.',
    },
    {
      'image': 'assets/images/narzedziazdjecie.png',
      'name': 'Apteczka pierwszej pomocy',
      'description': 'Zestaw podstawowych narzędzi i materiałów do udzielania pomocy.',
    },
  ];

  final List<String> statuses = ['Do nauczenia', 'W trakcie nauki', 'Nauczone'];
  final List<String> learnedStatus = ['Do nauczenia', 'Do nauczenia', 'Do nauczenia', 'Do nauczenia'];
  int currentIndex = 0;

  void _updateStatus(int index, String status) {
    setState(() {
      learnedStatus[index] = status;
    });
  }

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FiszkaDetailsPage(
                        items: items,
                        initialIndex: currentIndex,
                        onStatusChange: _updateStatus,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  items[currentIndex]['image']!,
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
                        'Nauczone: ${learnedStatus.where((status) => status == 'Nauczone').length}',
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
                        'W trakcie nauki: ${learnedStatus.where((status) => status == 'W trakcie nauki').length}',
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
                        'Do nauczenia: ${learnedStatus.where((status) => status == 'Do nauczenia').length}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

class FiszkaDetailsPage extends StatefulWidget {
  final List<Map<String, String>> items;
  final int initialIndex;
  final Function(int, String) onStatusChange;

  const FiszkaDetailsPage({
    super.key,
    required this.items,
    required this.initialIndex,
    required this.onStatusChange,
  });

  @override
  _FiszkaDetailsPageState createState() => _FiszkaDetailsPageState();
}

class _FiszkaDetailsPageState extends State<FiszkaDetailsPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _updateStatus(String status) {
    widget.onStatusChange(currentIndex, status);

    setState(() {
      if (currentIndex < widget.items.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // Wraca na początek, jeśli to ostatni element
      }
    });
  }

  void _goToPrevious() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        currentIndex = widget.items.length - 1; // Wraca na ostatni element, jeśli to pierwszy
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.items[currentIndex];

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
                    // Strzałka do cofania
                    ElevatedButton.icon(
                      onPressed: _goToPrevious,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: const Text(''),
                    ),

                    // Zielony przycisk z "ptaszkiem"
                    ElevatedButton.icon(
                      onPressed: () => _updateStatus('Nauczone'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(''),
                    ),

                    // Pomarańczowy przycisk z klepsydrą
                    ElevatedButton.icon(
                      onPressed: () => _updateStatus('W trakcie nauki'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      icon: const Icon(Icons.hourglass_bottom, color: Colors.white),
                      label: const Text(''),
                    ),

                    // Czerwony przycisk z "X"
                    ElevatedButton.icon(
                      onPressed: () => _updateStatus('Do nauczenia'),
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
