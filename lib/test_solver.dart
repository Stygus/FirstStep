import 'package:firststep/providers/testProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TestSolverPage extends ConsumerStatefulWidget {
  final String testId;
  final String testTitle;

  const TestSolverPage({
    Key? key,
    required this.testId,
    required this.testTitle,
  }) : super(key: key);

  @override
  ConsumerState<TestSolverPage> createState() => _TestSolverPageState();
}

class _TestSolverPageState extends ConsumerState<TestSolverPage> {
  int _currentQuestionIndex = 0;
  final Map<int, int?> _userAnswers = {};
  bool _isSubmitting = false;
  bool _testCompleted = false;
  int _score = 0;
  double _percentage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    final user = ref.read(userProvider);
    final token = await user.getToken() ?? '';

    try {
      await ref.read(testProvider).getTestById(token, widget.testId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Błąd ładowania testu: $e')));
      }
    }
  }

  void _selectAnswer(int questionId, int answerId) {
    setState(() {
      _userAnswers[questionId] = answerId;
    });
    // Zapisz odpowiedź również w providerze
    ref.read(testProvider).setUserAnswer(questionId, answerId);
  }

  void _nextQuestion() {
    final testData = ref.read(testProvider).currentTest;
    if (testData == null) return;

    if (_currentQuestionIndex < testData.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitTest() async {
    final testData = ref.read(testProvider).currentTest;
    if (testData == null) return;

    setState(() {
      _isSubmitting = true;
    });

    // Obliczamy wynik korzystając z providera
    final provider = ref.read(testProvider);
    _score = provider.calculateScore();
    _percentage = provider.calculatePercentage();

    setState(() {
      _isSubmitting = false;
      _testCompleted = true;
    });
  }

  void _restartTest() {
    setState(() {
      _currentQuestionIndex = 0;
      _userAnswers.clear();
      _testCompleted = false;
      _score = 0;
      _percentage = 0.0;
    });
    // Resetuj również stan w providerze
    ref.read(testProvider).resetTest();
    _loadTest(); // Załaduj test ponownie
  }

  @override
  Widget build(BuildContext context) {
    final testState = ref.watch(testProvider);
    final testData = testState.currentTest;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          widget.testTitle,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body:
          testState.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : testState.error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Błąd pobierania testu',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      testState.error!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Spróbuj ponownie'),
                      onPressed: _loadTest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
              : testData == null
              ? const Center(
                child: Text(
                  'Brak danych testu',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : _testCompleted
              ? _buildResultsView(testData.questions.length)
              : _buildQuestionView(testData),
    );
  }

  Widget _buildQuestionView(testData) {
    if (testData.questions.isEmpty) {
      return const Center(
        child: Text(
          'Ten test nie zawiera pytań',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final question = testData.questions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pasek postępu
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / testData.questions.length,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
          ),
          const SizedBox(height: 8),

          // Informacja o postępie
          Text(
            'Pytanie ${_currentQuestionIndex + 1} z ${testData.questions.length}',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Treść pytania
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              question.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Odpowiedzi
          Expanded(
            child: ListView.builder(
              itemCount: question.answers.length,
              itemBuilder: (context, index) {
                final answer = question.answers[index];
                final isSelected = _userAnswers[question.id] == answer.id;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _selectAnswer(question.id, answer.id),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.blue[700]
                                  : const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.blue[400]!
                                    : Colors.grey[700]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    isSelected
                                        ? Colors.blue[400]
                                        : Colors.grey[600],
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                answer.content,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Przyciski nawigacji
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      _currentQuestionIndex > 0 ? _previousQuestion : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Poprzednie'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[900],
                    disabledForegroundColor: Colors.grey[700],
                  ),
                ),
                if (_currentQuestionIndex == testData.questions.length - 1)
                  ElevatedButton.icon(
                    onPressed:
                        _userAnswers.length == testData.questions.length
                            ? _submitTest
                            : null,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Zakończ test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[900],
                      disabledForegroundColor: Colors.grey[700],
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _nextQuestion,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Następne'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(int totalQuestions) {
    Color resultColor;
    String resultMessage;

    if (_percentage >= 80) {
      resultColor = Colors.green;
      resultMessage = 'Gratulacje! Świetny wynik!';
    } else if (_percentage >= 60) {
      resultColor = Colors.orange;
      resultMessage = 'Dobry wynik! Można się jeszcze poprawić.';
    } else {
      resultColor = Colors.red;
      resultMessage = 'Spróbuj ponownie, aby poprawić swój wynik.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikona wyniku
            Icon(
              _percentage >= 60 ? Icons.check_circle : Icons.error,
              color: resultColor,
              size: 80,
            ),
            const SizedBox(height: 24),

            // Nagłówek wyniku
            Text(
              'Test ukończony',
              style: GoogleFonts.itim(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Wiadomość o wyniku
            Text(
              resultMessage,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Karta wyników
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Punktacja
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Poprawne odpowiedzi:',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        '$_score / $totalQuestions',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Procent
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Procent poprawnych:',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        '${_percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: resultColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Pasek postępu
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _percentage / 100,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(resultColor),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Przyciski akcji
            LayoutBuilder(
              builder: (context, constraints) {
                // Sprawdź szerokość ekranu i dostosuj układ przycisków
                if (constraints.maxWidth < 400) {
                  // Układ w kolumnie dla małych ekranów
                  return Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _restartTest,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Rozpocznij ponownie'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Wróć do kursu'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Układ w wierszu dla większych ekranów
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: _restartTest,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Rozpocznij ponownie'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Wróć do kursu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
