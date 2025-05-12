import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestyPage extends StatelessWidget {
  const TestyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> tests = [
      {
        'title': 'Test Pierwszej Pomocy',
        'description': 'Sprawdź swoją wiedzę z zakresu pierwszej pomocy.',
        'questions': 10,
        'difficulty': 'łatwy',
      },
      {
        'title': 'Test Ratownictwa',
        'description': 'Test wiedzy o narzędziach ratowniczych.',
        'questions': 15,
        'difficulty': 'średni',
      },
      {
        'title': 'Test Medyczny',
        'description': 'Zweryfikuj swoją wiedzę medyczną.',
        'questions': 20,
        'difficulty': 'trudny',
      },
      {
        'title': 'Test Anatomii',
        'description': 'Sprawdź swoją znajomość anatomii człowieka.',
        'questions': 12,
        'difficulty': 'łatwy',
      },
      {
        'title': 'Test Farmakologii',
        'description': 'Zweryfikuj swoją wiedzę o lekach i ich działaniu.',
        'questions': 18,
        'difficulty': 'trudny',
      },
      {
        'title': 'Test Ratownictwa Drogowego',
        'description': 'Test wiedzy o zasadach ratownictwa drogowego.',
        'questions': 14,
        'difficulty': 'średni',
      },
      {
        'title': 'Test Psychologii Kryzysowej',
        'description':
            'Sprawdź swoją wiedzę o wsparciu psychologicznym w kryzysie.',
        'questions': 16,
        'difficulty': 'trudny',
      },
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.1,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Stack(
          children: [
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
      backgroundColor: const Color(0xFF101010),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color(0xFF202020),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Testy',
                  style: GoogleFonts.itim(
                    color: Colors.white,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Wybierz test, aby sprawdzić swoją wiedzę!',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: screenWidth * 0.045,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 10,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Łatwy',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.yellow,
                          radius: 10,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Średni',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 10,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Trudny',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF181818),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
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
                      leading: CircleAvatar(
                        backgroundColor: _getDifficultyColor(
                          test['difficulty'],
                        ),
                        child: Text(
                          '${test['questions']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        test['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        test['description']!,
                        style: const TextStyle(color: Colors.grey),
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
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'łatwy':
        return Colors.green;
      case 'średni':
        return Colors.yellow;
      case 'trudny':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class TestSolvePage extends StatelessWidget {
  final String testTitle;

  const TestSolvePage({super.key, required this.testTitle});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.1,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Stack(
          children: [
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
      backgroundColor: const Color(0xFF101010),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nagłówek testu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF202020),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Rozwiązywanie testu',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: screenWidth * 0.05,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    testTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Opis testu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Ten test sprawdzi Twoją wiedzę w zakresie wybranej tematyki. '
                'Odpowiedz na wszystkie pytania, aby uzyskać wynik końcowy.',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: screenWidth * 0.045,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            // Przycisk rozpoczęcia testu
            ElevatedButton(
              onPressed: () {
                // Logika rozpoczęcia testu
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.2,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Rozpocznij test',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
