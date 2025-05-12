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
      },
      {
        'title': 'Test Ratownictwa',
        'description': 'Test wiedzy o narzędziach ratowniczych.',
        'questions': 15,
      },
      {
        'title': 'Test Medyczny',
        'description': 'Zweryfikuj swoją wiedzę medyczną.',
        'questions': 20,
      },
      {
        'title': 'Test Anatomii',
        'description': 'Sprawdź swoją znajomość anatomii człowieka.',
        'questions': 12,
      },
      {
        'title': 'Test Farmakologii',
        'description': 'Zweryfikuj swoją wiedzę o lekach i ich działaniu.',
        'questions': 18,
      },
      {
        'title': 'Test Ratownictwa Drogowego',
        'description': 'Test wiedzy o zasadach ratownictwa drogowego.',
        'questions': 14,
      },
      {
        'title': 'Test Psychologii Kryzysowej',
        'description':
            'Sprawdź swoją wiedzę o wsparciu psychologicznym w kryzysie.',
        'questions': 16,
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
          // Nagłówek z opisem
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
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista testów
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
                        backgroundColor: Colors.green,
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
                                (context) => TestDifficultyPage(
                                  testTitle: test['title']!,
                                ),
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
}

class TestDifficultyPage extends StatefulWidget {
  final String testTitle;

  const TestDifficultyPage({super.key, required this.testTitle});

  @override
  _TestDifficultyPageState createState() => _TestDifficultyPageState();
}

class _TestDifficultyPageState extends State<TestDifficultyPage> {
  String selectedDifficulty = 'Łatwy'; // Domyślna trudność

  @override
  Widget build(BuildContext context) {
    Color getDifficultyColor() {
      switch (selectedDifficulty) {
        case 'Łatwy':
          return Colors.green;
        case 'Średni':
          return Colors.yellow;
        case 'Trudny':
          return Colors.red;
        default:
          return Colors.green;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.testTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1D1D1D),
      ),
      backgroundColor: const Color(0xFF101010),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wybierz trudność:',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ToggleButtons(
              isSelected: [
                selectedDifficulty == 'Łatwy',
                selectedDifficulty == 'Średni',
                selectedDifficulty == 'Trudny',
              ],
              onPressed: (index) {
                setState(() {
                  if (index == 0) selectedDifficulty = 'Łatwy';
                  if (index == 1) selectedDifficulty = 'Średni';
                  if (index == 2) selectedDifficulty = 'Trudny';
                });
              },
              color: Colors.white,
              selectedColor: Colors.black,
              fillColor: getDifficultyColor(),
              borderRadius: BorderRadius.circular(10),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Łatwy'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Średni'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Trudny'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logika rozpoczęcia testu z wybraną trudnością
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: getDifficultyColor(),
              ),
              child: const Text('Rozpocznij test'),
            ),
          ],
        ),
      ),
    );
  }
}
