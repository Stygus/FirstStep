import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Course {
  int id;
  String title;
  String description;
  String difficultyLevel; // Enum: [ BASIC, INTERMEDIATE, ADVANCED ]
  DateTime creationDate;
  DateTime modificationDate;
  int studentCount;
  String status; // Enum: [ DRAFT, PUBLISHED, ARCHIVED ]
  // List<String> categorys;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.creationDate,
    required this.modificationDate,
    required this.studentCount,
    required this.status,
    // required this.categorys,
  });
}

class CourseList extends ChangeNotifier {
  List<Course> courses = [];

  void addCourse(Course course) {
    courses.add(course);
    notifyListeners();
  }

  void removeCourse(int id) {
    courses.removeWhere((course) => course.id == id);
    notifyListeners();
  }

  Future<void> getAllCoursesFromApi(String token) async {
    token = 'Bearer $token';
    final url = Uri.parse(dotenv.env['SERVER_URL']! + '/courses');
    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': token},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      courses =
          data
              .map(
                (item) => Course(
                  id: int.parse(item['id'].toString()),
                  title: item['title'],
                  description: item['description'],
                  difficultyLevel: item['difficultyLevel'],
                  creationDate: DateTime.parse(item['creationDate']),
                  modificationDate: DateTime.parse(item['modificationDate']),
                  studentCount: item['studentCount'] ?? 0,
                  status: item['status'],
                  // categorys: List<String>.from(item['categorys'] ?? []),
                ),
              )
              .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Course? getCourse(int id) {
    return courses.firstWhere(
      (course) => course.id == id,
      orElse: () => throw Exception('Course not found'),
    );
  }

  List<Course> getAllCourses() {
    return courses;
  }
}
