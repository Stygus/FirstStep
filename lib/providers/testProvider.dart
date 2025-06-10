import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firststep/models/test_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final testProvider = ChangeNotifierProvider<TestProvider>((ref) {
  return TestProvider();
});

class TestProvider extends ChangeNotifier {
  TestModel? _currentTest;
  bool _isLoading = false;
  String? _error;
  Map<int, int?> _userAnswers = {};

  TestModel? get currentTest => _currentTest;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<int, int?> get userAnswers => _userAnswers;
  Future<void> getTestById(String token, String testId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // 1. Pobierz dane testu
      final testData = await _fetchTest(token, testId);
      debugPrint('Test data: ${json.encode(testData)}');

      // 2. Pobierz pytania do testu
      final questions = await _fetchQuestions(token, testId);
      debugPrint(
        'Questions: ${json.encode(questions)}',
      ); // 3. Pobierz wszystkie odpowiedzi do testu
      final allAnswers = await _fetchAllAnswers(token, testId);
      debugPrint('All answers: ${json.encode(allAnswers)}');

      // Debugowanie struktury odpowiedzi
      if (allAnswers.isNotEmpty) {
        debugPrint('Struktura pierwszej odpowiedzi:');
        allAnswers.first.forEach((key, value) {
          debugPrint('$key: $value (${value.runtimeType})');
        });
      } // 4. Przypisz odpowiedzi do odpowiednich pytań
      for (var question in questions) {
        final questionId = question['id'];
        // Filtruj odpowiedzi dla danego pytania
        final questionAnswers =
            allAnswers.where((answer) {
              // Sprawdź różne możliwe nazwy pól i formaty
              bool matchesQuestionId = false;

              // Sprawdź pole questionId
              if (answer.containsKey('questionId')) {
                if (answer['questionId'] == questionId) {
                  matchesQuestionId = true;
                } else if (answer['questionId'] is String &&
                    answer['questionId'] == questionId.toString()) {
                  matchesQuestionId = true;
                }
              }

              // Sprawdź pole question_id
              if (answer.containsKey('question_id')) {
                if (answer['question_id'] == questionId) {
                  matchesQuestionId = true;
                } else if (answer['question_id'] is String &&
                    answer['question_id'] == questionId.toString()) {
                  matchesQuestionId = true;
                }
              }

              return matchesQuestionId;
            }).toList(); // Dodaj klucz is_correct jeśli go nie ma
        for (var answer in questionAnswers) {
          // Upewnij się, że wszystkie wymagane pola są obecne
          if (!answer.containsKey('id')) {
            answer['id'] = 0; // domyślne ID
          }

          if (!answer.containsKey('content')) {
            answer['content'] = ''; // domyślna treść
          }

          if (!answer.containsKey('is_correct') &&
              !answer.containsKey('isCorrect')) {
            answer['is_correct'] = false; // domyślna wartość
          } else if (answer.containsKey('isCorrect') &&
              !answer.containsKey('is_correct')) {
            answer['is_correct'] = answer['isCorrect'];
          } else if (answer.containsKey('is_correct') &&
              answer['is_correct'] == null) {
            answer['is_correct'] =
                false; // domyślna wartość gdy is_correct jest null
          }

          if (!answer.containsKey('question_id')) {
            answer['question_id'] = questionId; // przypisz ID pytania
          }
        }
        question['answers'] = questionAnswers;
        debugPrint(
          'Answers for question $questionId: ${json.encode(questionAnswers)}',
        );
      }

      // 4. Utwórz model testu z dostosowaniem kluczy
      final testModelData = {
        'id': testData['id'],
        'title': testData['title'],
        'description':
            testData['courseId'] != null
                ? 'Kurs ID: ${testData["courseId"]}'
                : '',
        'questions': questions,
        'created_at':
            testData['creationDate'] ?? DateTime.now().toIso8601String(),
        'updated_at':
            testData['creationDate'] ?? DateTime.now().toIso8601String(),
      };

      _currentTest = TestModel.fromJson(testModelData);

      // 5. Inicjalizuj odpowiedzi użytkownika
      _userAnswers = {};
    } catch (e) {
      _error = 'Wystąpił błąd: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Metoda do pobierania danych testu
  Future<Map<String, dynamic>> _fetchTest(String token, String testId) async {
    final serverUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:3000';
    final response = await http.get(
      Uri.parse('$serverUrl/tests/$testId'),
      headers: {
        'accept': 'application/json',
        'Authorization': "bearer ${token}",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Nie udało się pobrać testu. Kod błędu: ${response.statusCode} ${response.body}',
      );
    }
  }

  // Metoda do pobierania pytań testu
  Future<List<dynamic>> _fetchQuestions(String token, String testId) async {
    final serverUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:3000';
    final response = await http.get(
      Uri.parse('$serverUrl/tests/$testId/questions'),
      headers: {
        'accept': 'application/json',
        'Authorization': "bearer ${token}",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Nie udało się pobrać pytań. Kod błędu: ${response.statusCode}',
      );
    }
  } // Metoda do pobierania wszystkich odpowiedzi do testu

  Future<List<dynamic>> _fetchAllAnswers(String token, String testId) async {
    final serverUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:3000';
    final response = await http.get(
      Uri.parse('$serverUrl/tests/$testId/answers'),
      headers: {
        'accept': 'application/json',
        'Authorization': "bearer ${token}",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Nie udało się pobrać odpowiedzi. Kod błędu: ${response.statusCode}',
      );
    }
  }

  // Metoda do zapisywania odpowiedzi użytkownika
  void setUserAnswer(int questionId, int answerId) {
    _userAnswers[questionId] = answerId;
    notifyListeners();
  }

  // Metoda do obliczania wyniku testu
  int calculateScore() {
    if (_currentTest == null) return 0;

    int score = 0;
    for (var entry in _userAnswers.entries) {
      final questionId = entry.key;
      final selectedAnswerId = entry.value;

      if (selectedAnswerId != null) {
        final question = _currentTest!.questions.firstWhere(
          (q) => q.id == questionId,
          orElse:
              () => throw Exception('Nie znaleziono pytania o ID: $questionId'),
        );

        final selectedAnswer = question.answers.firstWhere(
          (a) => a.id == selectedAnswerId,
          orElse:
              () =>
                  throw Exception(
                    'Nie znaleziono odpowiedzi o ID: $selectedAnswerId',
                  ),
        );

        if (selectedAnswer.isCorrect) {
          score++;
        }
      }
    }

    return score;
  }

  // Metoda do obliczania procentowego wyniku testu
  double calculatePercentage() {
    if (_currentTest == null || _currentTest!.questions.isEmpty) return 0.0;

    final score = calculateScore();
    return (score / _currentTest!.questions.length) * 100.0;
  }

  // Metoda do resetowania stanu
  void resetTest() {
    _currentTest = null;
    _userAnswers = {};
    _error = null;
    notifyListeners();
  }
}
