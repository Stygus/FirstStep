import 'dart:convert';

class TestModel {
  final int id;
  final String title;
  final String description;
  final List<TestQuestion> questions;
  final DateTime createdAt;
  final DateTime updatedAt;

  TestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
  });
  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id:
          json['id'] == null
              ? 0
              : (json['id'] is String ? int.parse(json['id']) : json['id']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      questions:
          (json['questions'] as List)
              .map((q) => TestQuestion.fromJson(q))
              .toList(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class TestQuestion {
  final int id;
  final String content;
  final List<TestAnswer> answers;
  final int testId;

  TestQuestion({
    required this.id,
    required this.content,
    required this.answers,
    required this.testId,
  });
  factory TestQuestion.fromJson(Map<String, dynamic> json) {
    return TestQuestion(
      id:
          json['id'] == null
              ? 0
              : (json['id'] is String ? int.parse(json['id']) : json['id']),
      content: json['content'] ?? '',
      answers:
          ((json['answers'] as List?) ?? [])
              .map((a) => TestAnswer.fromJson(a))
              .toList(),
      testId:
          json['test_id'] == null
              ? 0
              : (json['test_id'] is String
                  ? int.parse(json['test_id'])
                  : json['test_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'answers': answers.map((a) => a.toJson()).toList(),
      'test_id': testId,
    };
  }
}

class TestAnswer {
  final int id;
  final String content;
  final bool isCorrect;
  final int questionId;

  TestAnswer({
    required this.id,
    required this.content,
    required this.isCorrect,
    required this.questionId,
  });
  factory TestAnswer.fromJson(Map<String, dynamic> json) {
    return TestAnswer(
      id:
          json['id'] == null
              ? 0
              : (json['id'] is String ? int.parse(json['id']) : json['id']),
      content: json['content'] ?? '',
      isCorrect:
          json['is_correct'] == null
              ? false // Domyślna wartość gdy is_correct jest null
              : (json['is_correct'] is String
                  ? json['is_correct'].toLowerCase() == 'true'
                  : json['is_correct']),
      questionId:
          json['question_id'] == null
              ? 0
              : (json['question_id'] is String
                  ? int.parse(json['question_id'])
                  : json['question_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'is_correct': isCorrect,
      'question_id': questionId,
    };
  }
}
