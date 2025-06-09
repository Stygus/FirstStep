import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/courses/courses.dart';

class TestEditor extends ConsumerStatefulWidget {
  final Test? test;
  const TestEditor({super.key, this.test});

  @override
  ConsumerState<TestEditor> createState() => _TestEditorState();
}

class _TestEditorState extends ConsumerState<TestEditor> {
  late Test _test;
  int _questionIdCounter = 100000;
  int _answerIdCounter = 1000000;

  @override
  void initState() {
    super.initState();
    _test =
        widget.test ??
        Test(
          id: 0,
          creatorId: 0,
          courseId: 0,
          title: '',
          duration: 10,
          creationDate: DateTime.now(),
          questions: [],
        );
    if (_test.questions.isNotEmpty) {
      _questionIdCounter =
          _test.questions
              .map((q) => q.id)
              .fold(_questionIdCounter, (a, b) => a > b ? a : b) +
          1;
      final allAnswers = _test.questions.expand((q) => q.answers);
      if (allAnswers.isNotEmpty) {
        _answerIdCounter =
            allAnswers
                .map((a) => a.id)
                .fold(_answerIdCounter, (a, b) => a > b ? a : b) +
            1;
      }
    }
  }

  void _addQuestion() {
    setState(() {
      _test.addQuestion(
        TestQuestion(
          id: _questionIdCounter++,
          testId: _test.id,
          content: '',
          questionType: QuestionType.SINGLE_CHOICE,
          points: 1,
          order: _test.questions.length,
          answers: [],
        ),
      );
    });
  }

  void _removeQuestion(int questionId) {
    setState(() {
      _test.removeQuestion(questionId);
    });
  }

  void _addAnswer(TestQuestion question) {
    setState(() {
      question.addAnswer(
        Answer(
          id: _answerIdCounter++,
          questionId: question.id,
          content: '',
          isCorrect: false,
          order: question.answers.length,
        ),
      );
    });
  }

  void _removeAnswer(TestQuestion question, int answerId) {
    setState(() {
      question.removeAnswer(answerId);
    });
  }

  void _setCorrectAnswer(TestQuestion question, int answerIdx, bool? value) {
    setState(() {
      if (question.questionType == QuestionType.SINGLE_CHOICE ||
          question.questionType == QuestionType.TRUE_FALSE) {
        for (int i = 0; i < question.answers.length; i++) {
          question.answers[i] = Answer(
            id: question.answers[i].id,
            questionId: question.id,
            content: question.answers[i].content,
            isCorrect: i == answerIdx ? true : false,
            order: question.answers[i].order,
          );
        }
      } else {
        question.answers[answerIdx] = Answer(
          id: question.answers[answerIdx].id,
          questionId: question.id,
          content: question.answers[answerIdx].content,
          isCorrect: value ?? false,
          order: question.answers[answerIdx].order,
        );
      }
    });
  }

  Future<void> _saveQuestionsAndAnswers(WidgetRef ref) async {
    final String token = await ref.read(userProvider).getToken() ?? '';
    final int testId = _test.id;
    final questions =
        _test.questions
            .map(
              (q) => {
                'id': q.id,
                'testId': testId,
                'content': q.content,
                'questionType': q.questionType.toString().split('.').last,
                'points': q.points,
                'order': q.order,
              },
            )
            .toList();
    final answers =
        _test.questions
            .expand(
              (q) => q.answers.map(
                (a) => {
                  'id': a.id,
                  'questionId': a.questionId,
                  'content': a.content,
                  'isCorrect': a.isCorrect,
                  'order': a.order,
                },
              ),
            )
            .toList();
    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    // Zapisz pytania
    final questionsRes = await http.put(
      Uri.parse('${dotenv.env['SERVER_URL']!}/tests/$testId/questions'),
      headers: headers,
      body: jsonEncode({'questions': questions}),
    );
    // Zapisz odpowiedzi
    final answersRes = await http.put(
      Uri.parse('${dotenv.env['SERVER_URL']!}/tests/$testId/answers'),
      headers: headers,
      body: jsonEncode({'answers': answers}),
    );
    debugPrint(
      'Questions response: \\${questionsRes.statusCode} \\${questionsRes.body}',
    );
    debugPrint(
      'Answers response: \\${answersRes.statusCode} \\${answersRes.body}',
    );
    if (questionsRes.statusCode == 200 && answersRes.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Test zapisany!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Błąd zapisu: \\${questionsRes.statusCode}, \\${answersRes.statusCode}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 38, 38),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        title: const Text('Edycja testu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await _saveQuestionsAndAnswers(ref);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              initialValue: _test.title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                labelText: 'Tytuł testu',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged:
                  (v) => setState(
                    () =>
                        _test = Test(
                          id: _test.id,
                          creatorId: _test.creatorId,
                          courseId: _test.courseId,
                          title: v,
                          duration: _test.duration,
                          creationDate: _test.creationDate,
                          questions: _test.questions,
                        ),
                  ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: _test.duration.toString(),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Czas trwania (minuty)',
                labelStyle: TextStyle(color: Colors.white),
              ),
              keyboardType: TextInputType.number,
              onChanged:
                  (v) => setState(
                    () =>
                        _test = Test(
                          id: _test.id,
                          creatorId: _test.creatorId,
                          courseId: _test.courseId,
                          title: _test.title,
                          duration: int.tryParse(v) ?? 10,
                          creationDate: _test.creationDate,
                          questions: _test.questions,
                        ),
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pytania',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                ElevatedButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text('Dodaj pytanie'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ..._test.questions.map((q) => _buildQuestionCard(q)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(TestQuestion question) {
    return Card(
      color: const Color(0xFF232323),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: question.content,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      labelText: 'Treść pytania',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onChanged: (v) => setState(() => question.content = v),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeQuestion(question.id),
                ),
              ],
            ),
            Row(
              children: [
                DropdownButton<QuestionType>(
                  value: question.questionType,
                  dropdownColor: const Color(0xFF232323),
                  style: const TextStyle(color: Colors.white),
                  items:
                      QuestionType.values
                          .map(
                            (qt) => DropdownMenuItem(
                              value: qt,
                              child: Text(qt.toString().split('.').last),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (qt) => setState(
                        () =>
                            question.questionType =
                                qt ?? QuestionType.SINGLE_CHOICE,
                      ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: question.points.toString(),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Punkty',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged:
                        (v) => setState(
                          () => question.points = int.tryParse(v) ?? 1,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Odpowiedzi', style: TextStyle(color: Colors.white)),
                ElevatedButton.icon(
                  onPressed: () => _addAnswer(question),
                  icon: const Icon(Icons.add),
                  label: const Text('Dodaj odpowiedź'),
                ),
              ],
            ),
            ...question.answers.asMap().entries.map((entry) {
              final idx = entry.key;
              final answer = entry.value;
              return Row(
                children: [
                  if (question.questionType == QuestionType.SINGLE_CHOICE ||
                      question.questionType == QuestionType.TRUE_FALSE)
                    Radio<bool>(
                      value: true,
                      groupValue: answer.isCorrect,
                      onChanged: (_) => _setCorrectAnswer(question, idx, true),
                      activeColor: Colors.green,
                    )
                  else
                    Checkbox(
                      value: answer.isCorrect,
                      onChanged: (v) => _setCorrectAnswer(question, idx, v),
                      activeColor: Colors.green,
                    ),
                  Expanded(
                    child: TextFormField(
                      initialValue: answer.content,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Treść odpowiedzi',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      onChanged: (v) => setState(() => answer.content = v),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeAnswer(question, answer.id),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
