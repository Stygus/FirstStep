import 'dart:convert';
import 'package:firststep/models/user.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Category {
  final int id;
  final String name;
  final String description;

  Category({required this.id, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'],
    );
  }
}

class Course {
  int id;
  int creatorId;
  int testId;
  String title;
  String description;
  String difficultyLevel; // Enum: [ BASIC, INTERMEDIATE, ADVANCED ]
  DateTime creationDate;
  DateTime modificationDate;
  int studentCount;
  String status; // Enum: [ DRAFT, PUBLISHED, ARCHIVED ]
  List<Category> categories;

  Course({
    required this.id,
    required this.creatorId,
    required this.testId,
    required this.title,
    required this.description,
    required this.difficultyLevel,
    required this.creationDate,
    required this.modificationDate,
    required this.studentCount,
    required this.status,
    required this.categories,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: int.parse(json['id'].toString()),
      creatorId: int.parse(json['creatorId'].toString()),
      testId: int.parse(json['testId'].toString()),
      title: json['title'],
      description: json['description'],
      difficultyLevel: json['difficultyLevel'],
      creationDate: DateTime.parse(json['creationDate']),
      modificationDate: DateTime.parse(json['modificationDate']),
      studentCount: json['studentCount'] ?? 0,
      status: json['status'],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((cat) => Category.fromJson(cat))
              .toList() ??
          [],
    );
  }
}

class CourseList extends ChangeNotifier {
  List<Course> courses = [];
  List<Course> bestCourses = [];
  List<Course> myCourses = [];

  void updateCourses() {
    // courses.sort((a, b) => b.studentCount.compareTo(a.studentCount));
    bestCourses = courses.toList();
    myCourses = courses.toList();
    bestCourses.sort((a, b) => b.studentCount.compareTo(a.studentCount));
    myCourses.sort((a, b) => a.creationDate.compareTo(b.creationDate));

    notifyListeners();
  }

  void addCourse(Course course) {
    courses.add(course);
    notifyListeners();
  }

  void removeCourse(int id) {
    courses.removeWhere((course) => course.id == id);
    notifyListeners();
  }

  Future<void> getAllCoursesFromApi(String token, String name) async {
    token = 'Bearer $token';
    final url = Uri.parse(dotenv.env['SERVER_URL']! + '/courses/' + name);
    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': token},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      courses = data.map((item) => Course.fromJson(item)).toList();
      updateCourses();
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

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500, // szerokość na sztywno
      height: 300, // wysokość na sztywno (zwiększona)
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 38, 38, 38),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          course.description,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 14,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.visibility, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${course.studentCount}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '5.0', // Placeholder for ratings
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      Text(
                        course.status,
                        style: TextStyle(
                          color: _getStatusColor(course.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'poziom trudności',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                      Text(
                        course.difficultyLevel,
                        style: TextStyle(
                          color: _getDifficultyColor(course.difficultyLevel),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      'Edytuj',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children:
                    course.categories.isNotEmpty
                        ? course.categories
                            .map((cat) => _buildCategoryChip(cat.name))
                            .toList()
                        : [_buildCategoryChip('Brak kategorii')],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PUBLISHED':
        return Colors.green;
      case 'DRAFT':
        return Colors.orange;
      case 'ARCHIVED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toUpperCase()) {
      case 'BASIC':
        return Colors.green;
      case 'INTERMEDIATE':
        return Colors.orange;
      case 'ADVANCED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
