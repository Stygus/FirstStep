import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestyPage extends StatelessWidget {
  const TestyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Lista testów
    final List<Map<String, dynamic>> tests = [
      {
        'title': 'Test Pierwszej Pomocy',
        'description': 'Sprawdź swoją wiedzę z zakresu pierwszej pomocy.',
        'questions': 10,
        'progress': 0.5, // 50% ukończone
      },
      {
        'title': 'Test Ratownictwa',
        'description': 'Test wiedzy o narzędziach ratowniczych.',
        'questions': 15,
        'progress': 0.2, // 20% ukończone
      },
      {
        'title': 'Test Medyczny',
        'description': 'Zweryfikuj swoją wiedzę medyczną.',
        'questions': 20,
        'progress': 0.0, // Jeszcze nie rozpoczęty
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
                      'Testy',
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

          // Lista testów
          Expanded(
            child: ListView.builder(
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
                return Card(
                  color: const Color(0xFF202020),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      test['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test['description']!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Liczba pytań: ${test['questions']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: test['progress'],
                          backgroundColor: Colors.grey[800],
                          color: Colors.green,
                          minHeight: 5,
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  TestSolvePage(testTitle: test['title']!),
                        ),
                      );
                    },
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

class TestSolvePage extends StatelessWidget {
  final String testTitle;

  const TestSolvePage({super.key, required this.testTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(testTitle, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1D1D1D),
      ),
      backgroundColor: const Color(0xFF101010),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rozwiązywanie testu: $testTitle',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika rozwiązywania testu
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Rozpocznij test'),
            ),
          ],
        ),
      ),
    );
  }
}
