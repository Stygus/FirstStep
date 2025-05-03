import 'dart:convert';
import 'dart:math' as Math;
import 'package:firststep/components/courses/courseCreatorPage.dart';
import 'package:firststep/components/courses/showCourse.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ElementsStyle {
  bool isBold;
  bool isItalic;
  Color? color;
  double? fontSize;
  bool isUnderline;
  bool hasHighlight;
  String? id;
  String? courseElementId;

  ElementsStyle({
    this.isBold = false,
    this.isItalic = false,
    this.color,
    this.fontSize,
    this.isUnderline = false,
    this.hasHighlight = false,
    this.id,
    this.courseElementId,
  });

  factory ElementsStyle.fromJson(Map<String, dynamic> json) {
    return ElementsStyle(
      isBold: json['isBold'] ?? false,
      isItalic: json['isItalic'] ?? false,
      color:
          json['color'] != null
              ? (json['color'] is String
                  ? (json['color'].toString().startsWith('#')
                      ? Color(
                        int.parse(
                          'FF${json['color'].toString().substring(1)}',
                          radix: 16,
                        ),
                      )
                      : Color(int.parse(json['color'].toString())))
                  : null)
              : null,
      // Obsługa wartości która może już być typu double
      fontSize:
          json['fontSize'] != null
              ? (json['fontSize'] is double
                  ? json['fontSize']
                  : double.tryParse(json['fontSize'].toString()))
              : null,
      isUnderline: json['isUnderline'] ?? false,
      hasHighlight: json['hasHighlight'] ?? false,
      id: json['id']?.toString(),
      courseElementId: json['courseElementId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'isBold': isBold,
      'isItalic': isItalic,
      'isUnderline': isUnderline,
      'hasHighlight': hasHighlight,
    };

    if (id != null) {
      json['id'] = id;
    }

    if (courseElementId != null) {
      json['courseElementId'] = courseElementId;
    }

    if (fontSize != null) {
      json['fontSize'] = fontSize;
    }

    if (color != null) {
      json['color'] =
          '#${color!.value.toRadixString(16).substring(2).toUpperCase()}';
    }

    return json;
  }
}

class CourseElements {
  int id;
  int courseId;
  String type; // Enum: [ TEXT, VIDEO, QUIZ, etc. ]
  String content;
  int order;
  Map<String, dynamic> additionalData;
  ElementsStyle? style;

  CourseElements({
    required this.style,
    required this.id,
    required this.courseId,
    required this.type,
    required this.content,
    required this.order,
    required this.additionalData,
  });

  factory CourseElements.fromJson(Map<String, dynamic> json) {
    ElementsStyle? elementStyle;

    // Obsługa pola 'styles' zamiast 'style'
    if (json['styles'] != null &&
        json['styles'] is List &&
        (json['styles'] as List).isNotEmpty) {
      // Pobieramy pierwszy element z listy styles
      Map<String, dynamic> styleData = json['styles'][0];

      elementStyle = ElementsStyle.fromJson(styleData);
      debugPrint('Style parsed successfully');
    } else {
      debugPrint('No styles found in element');
    }

    return CourseElements(
      style: elementStyle,
      id: int.parse(json['id'].toString()),
      courseId: int.parse(json['courseId'].toString()),
      type: json['type'],
      content: json['content'],
      order: int.parse(json['order'].toString()),
      additionalData: json['additionalData'] ?? {},
    );
  }

  void updateElement(CourseElements element) {
    id = element.id;
    courseId = element.courseId;
    type = element.type;
    content = element.content;
    order = element.order;
    additionalData = element.additionalData;
    style = element.style;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'courseId': courseId,
      'type': type,
      'content': content,
      'order': order,
      'additionalData': additionalData,
    };

    if (style != null) {
      json['styles'] = [
        {
          'isBold': style!.isBold,
          'isItalic': style!.isItalic,
          'isUnderline': style!.isUnderline,
          'hasHighlight': style!.hasHighlight,
          if (style!.fontSize != null) 'fontSize': style!.fontSize,
          if (style!.color != null)
            'color':
                '#${style!.color!.value.toRadixString(16).substring(2).toUpperCase()}',
        },
      ];
    }

    return json;
  }
}

class CourseElementsList extends ChangeNotifier {
  List<CourseElements> courseElements = [];
  List<CourseElements> initialCourseElements = [];
  Map<int, List<CourseElements>> courseElementsHistory = {};

  int historyIndex = 0;

  bool isLoading = false;
  String? error;

  // Dodaję licznik przebudowy, który pomoże w wymuszeniu odświeżenia widgetów
  int _rebuildCounter = 0;
  int get rebuildCounter => _rebuildCounter;

  void addCourseElement(CourseElements element, int index) {
    // Ustawiamy order elementu zgodnie z pozycją, gdzie ma być wstawiony
    element.order = index;

    // Przesuwamy order dla wszystkich elementów, które mają order >= index
    for (int i = 0; i < courseElements.length; i++) {
      if (courseElements[i].order >= index) {
        courseElements[i].order += 1;
      }
    }

    // Dodajemy nowy element do listy
    courseElements.add(element);

    // Sortujemy elementy według order, aby zachować poprawną kolejność
    courseElements.sort((a, b) => a.order.compareTo(b.order));

    // Zapisujemy stan do historii
    courseElementsHistory[courseElementsHistory.length +
        1] = List<CourseElements>.from(courseElements);

    // Zwiększamy licznik przebudowy, aby wymusić odświeżenie widgetów
    _rebuildCounter++;

    notifyListeners();
  }

  void backToPreviousState() {
    // Zwiększamy indeks historii, aby cofnąć się wstecz
    historyIndex++;

    // Sprawdzamy, czy istnieje element historii o żądanym indeksie
    final targetHistoryIndex = courseElementsHistory.length - historyIndex;

    if (courseElementsHistory.isNotEmpty &&
        courseElementsHistory.containsKey(targetHistoryIndex) &&
        courseElementsHistory[targetHistoryIndex] != null) {
      // Bezpieczne pobranie elementu z historii
      final historicElements = courseElementsHistory[targetHistoryIndex];
      if (historicElements != null && historicElements.isNotEmpty) {
        courseElements = List<CourseElements>.from(historicElements);
        _rebuildCounter++; // Zwiększamy licznik przebudowy
        notifyListeners();
      } else {
        // Cofamy zmianę indeksu, ponieważ nie znaleźliśmy prawidłowej historii
        historyIndex--;
        debugPrint(
          'Nie znaleziono poprawnej historii dla indeksu $targetHistoryIndex',
        );
      }
    } else {
      // Cofamy zmianę indeksu, ponieważ przekroczyliśmy zakres dostępnej historii
      historyIndex--;
      debugPrint(
        'Przekroczono zakres historii: $historyIndex, max: ${courseElementsHistory.length}',
      );
    }
  }

  void forwardToNextState() {
    // Sprawdzamy, czy możemy przejść naprzód w historii
    if (historyIndex <= 1) {
      debugPrint('Już jesteśmy na najnowszym stanie historii');
      return;
    }

    // Zmniejszamy indeks historii, aby przejść do przodu
    historyIndex--;

    // Sprawdzamy, czy istnieje element historii o żądanym indeksie
    final targetHistoryIndex = courseElementsHistory.length - historyIndex;

    if (courseElementsHistory.isNotEmpty &&
        courseElementsHistory.containsKey(targetHistoryIndex) &&
        courseElementsHistory[targetHistoryIndex] != null) {
      // Bezpieczne pobranie elementu z historii
      final historicElements = courseElementsHistory[targetHistoryIndex];
      if (historicElements != null && historicElements.isNotEmpty) {
        courseElements = List<CourseElements>.from(historicElements);
        _rebuildCounter++; // Zwiększamy licznik przebudowy
        notifyListeners();
      } else {
        // Przywracamy poprzedni indeks, ponieważ nie znaleźliśmy prawidłowej historii
        historyIndex++;
        debugPrint(
          'Nie znaleziono poprawnej historii dla indeksu $targetHistoryIndex',
        );
      }
    } else {
      // Przywracamy poprzedni indeks, ponieważ przekroczyliśmy zakres dostępnej historii
      historyIndex++;
      debugPrint('Nieprawidłowy indeks historii: $targetHistoryIndex');
    }
  }

  void undoAllChanges() {
    // Sprawdzamy, czy mamy początkowy stan do przywrócenia
    if (initialCourseElements.isEmpty) {
      debugPrint('Brak początkowego stanu do przywrócenia');
      return;
    }

    // Przywracamy stan początkowy
    courseElements = List<CourseElements>.from(initialCourseElements);

    // Resetujemy historię
    courseElementsHistory.clear();
    courseElementsHistory[1] = List<CourseElements>.from(courseElements);

    // Resetujemy indeks historii
    historyIndex = 0;

    // Zwiększamy licznik przebudowy
    _rebuildCounter++;

    notifyListeners();
  }

  void removeCourseElement(int id) {
    debugPrint('Removing course element with ID: $id');

    // Usunięcie elementu z listy
    courseElements.removeWhere((element) => element.id == id);

    courseElementsHistory[courseElementsHistory.length +
        1] = List<CourseElements>.from(courseElements);

    // Ponowne uporządkowanie pozostałych elementów
    reOrderCourseElements();

    // Zwiększamy licznik przebudowy, co wymusi odświeżenie wszystkich widgetów
    _rebuildCounter++;

    // Powiadomienie słuchaczy o zmianie
    notifyListeners();
  }

  void reOrderCourseElements() {
    for (int i = 0; i < courseElements.length; i++) {
      if (courseElements[i].order != i) {
        courseElements[i].order = i;
      }
    }
  }

  Future<void> getAllCourseElementsFromApi(String token, String id) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      debugPrint('Fetching course elements for course ID: $id');
      if (token is Future) {
        debugPrint('Token is a Future, resolving...');
        token = token;
      }

      if (token.isEmpty) {
        error = 'Token is null or empty';
        isLoading = false;
        notifyListeners();
        return;
      }

      if (!token.startsWith('Bearer ')) {
        token = 'Bearer $token';
      }

      debugPrint('Token: ${token.substring(0, Math.min(20, token.length))}...');

      final url = Uri.parse(
        '${dotenv.env['SERVER_URL']!}/courses/$id/elements',
      );

      debugPrint('Sending request to: $url');
      final response = await http.get(
        url,
        headers: {'accept': 'application/json', 'Authorization': token},
      );

      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('Received ${data.length} elements');

        // Zapewniamy aktualizację stanu tylko jeśli nie było wyjątku
        courseElements.clear();
        if (data.isNotEmpty) {
          courseElements.addAll(
            data.map((item) => CourseElements.fromJson(item)),
          );
          debugPrint(courseElements[0].style?.color.toString());
        }
        courseElements.sort((a, b) => a.order.compareTo(b.order));
        initialCourseElements = courseElements.toList();
        courseElementsHistory.clear();
        courseElementsHistory[courseElementsHistory.length +
            1] = List<CourseElements>.from(courseElements);

        isLoading = false;
        notifyListeners();
      } else {
        debugPrint('Error response: ${response.body}');
        error = 'Failed to load course elements (${response.statusCode})';
        isLoading = false;
        notifyListeners();
        throw Exception('Failed to load course elements');
      }
    } catch (e) {
      debugPrint('Error fetching course elements: $e');
      error = 'Error: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAllCourseElementToApi(String token, String id) async {
    try {
      isLoading = true;
      notifyListeners();

      if (token is Future) {
        token = token;
      }

      if (!token.startsWith('Bearer ')) {
        token = 'Bearer $token';
      }

      final url = Uri.parse(
        '${dotenv.env['SERVER_URL']!}/courses/$id/elements',
      );

      // Przygotowanie elementów kursu do wysłania
      final List<Map<String, dynamic>> elementsJson =
          courseElements.map((element) => element.toJson()).toList();

      final Map<String, dynamic> requestBody = {'elements': elementsJson};

      debugPrint('Request body: $requestBody');

      final response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        debugPrint('Course elements updated successfully');
      } else {
        debugPrint('Error updating course elements: ${response.statusCode}');
        debugPrint('Error response: ${response.body}');
        error = 'Failed to update course elements (${response.statusCode})';
        throw Exception('Failed to update course elements');
      }
    } catch (e) {
      debugPrint('Error updating course elements: $e');
      error = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

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
  List<Category> categories = const [];
  CourseElementsList courseElementsList;

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
    this.categories = const [],
    CourseElementsList? courseElementsList,
  }) : courseElementsList = courseElementsList ?? CourseElementsList();

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
      studentCount: int.parse(json['studentCount'].toString()),
      status: json['status'],
      categories:
          (json['categories'] as List<dynamic>? ?? [])
              .map((cat) => Category.fromJson(cat))
              .toList(),
    );
  }
}

class CourseList extends ChangeNotifier {
  List<Course> courses = [];
  List<Course> bestCourses = [];
  List<Course> myCourses = [];
  Course? selectedCourse;

  void setSelectedCourse(Course course) {
    selectedCourse = course;
    notifyListeners();
  }

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
    final url = Uri.parse('${dotenv.env['SERVER_URL']!}/courses/$name');
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

class CourseCard extends ConsumerWidget {
  final Course course;

  void showCourse(WidgetRef ref, BuildContext context) {
    final courseProvider = ref.read(coursesProvider);
    courseProvider.setSelectedCourse(course);

    debugPrint(courseProvider.selectedCourse?.title ?? 'No course selected');

    // Korzystamy z funkcji showCourseDialog z pliku showCourse.dart
    showCourseDialog(context, course);
  }

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 500, // szerokość na sztywno
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 38, 38, 38),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        style: TextStyle(color: Colors.grey[300], fontSize: 14),
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
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final courseProvider = ref.read(coursesProvider);
                        final courseElements = ref.read(courseElementsProvider);
                        final token = await ref.read(userProvider).getToken();
                        courseElements.courseElements.clear();

                        courseElements.getAllCourseElementsFromApi(
                          token as String,
                          course.id.toString(),
                        );
                        courseProvider.setSelectedCourse(course);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseCreator(),
                          ),
                        );
                      },
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
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => showCourse(ref, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 136, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'Podgląd',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
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
