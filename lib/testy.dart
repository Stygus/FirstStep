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
                                (context) => TestSolvePage(
                                  testTitle: test['title']!,
                                  difficulty: test['difficulty']!,
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
  final String difficulty;

  const TestSolvePage({
    super.key,
    required this.testTitle,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
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

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Poziom trudności: ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  CircleAvatar(
                    backgroundColor: _getDifficultyColor(difficulty),
                    radius: 10,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    difficulty[0].toUpperCase() + difficulty.substring(1),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
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

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TestQuestionPage(testTitle: testTitle),
                  ),
                );
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

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TestyPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.2,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Powrót do menu',
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

class TestQuestionPage extends StatefulWidget {
  final String testTitle;

  const TestQuestionPage({super.key, required this.testTitle});

  @override
  _TestQuestionPageState createState() => _TestQuestionPageState();
}

class _TestQuestionPageState extends State<TestQuestionPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswerIndex;
  bool showCorrectAnswer = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Jakie jest prawidłowe ciśnienie krwi u dorosłego człowieka?',
      'answers': ['120/80 mmHg', '140/90 mmHg', '100/60 mmHg', '160/100 mmHg'],
      'correctAnswer': 0,
    },
    {
      'question': 'Co należy zrobić w przypadku krwotoku z nosa?',
      'answers': [
        'Odchylić głowę do tyłu',
        'Pochylić głowę do przodu',
        'Położyć się na plecach',
        'Zatkać nos chusteczką',
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'Ile kości znajduje się w ludzkim ciele?',
      'answers': ['206', '208', '210', '212'],
      'correctAnswer': 0,
    },
  ];

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        showCorrectAnswer = false;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  TestResultPage(score: score, total: questions.length),
        ),
      );
    }
  }

  void selectAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
      showCorrectAnswer = true;

      if (index == questions[currentQuestionIndex]['correctAnswer']) {
        score++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1D),
        automaticallyImplyLeading: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF101010),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Pytanie
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF202020),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                questions[currentQuestionIndex]['question'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Odpowiedzi
            Expanded(
              child: ListView.builder(
                itemCount: questions[currentQuestionIndex]['answers'].length,
                itemBuilder: (context, index) {
                  Color answerColor = const Color(0xFF181818);

                  if (showCorrectAnswer) {
                    if (index ==
                        questions[currentQuestionIndex]['correctAnswer']) {
                      answerColor = Colors.green;
                    } else if (index == selectedAnswerIndex) {
                      answerColor = Colors.red;
                    }
                  }

                  return GestureDetector(
                    onTap: showCorrectAnswer ? null : () => selectAnswer(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: answerColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        questions[currentQuestionIndex]['answers'][index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: selectedAnswerIndex != null ? nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedAnswerIndex != null ? Colors.green : Colors.grey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Następne pytanie',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestResultPage extends StatelessWidget {
  final int score;
  final int total;

  const TestResultPage({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1D),
        automaticallyImplyLeading: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF101010),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Twój wynik:',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: screenWidth * 0.06,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$score / $total',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TestSolvePage(
                          testTitle: 'Test',
                          difficulty: 'łatwy',
                        ),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Powrót',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestQuestionPage(testTitle: 'Test'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Rozwiąż ponownie',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
