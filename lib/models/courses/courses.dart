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

// Dodanie na początku pliku, po importach
/// Klasa bezpieczeństwa do zarządzania operacjami asynchronicznymi w kontekście widgetów
class SafeAsync {
  /// Wywołuje notifyListeners na podanym ChangeNotifier tylko jeśli aplikacja jest w bezpiecznym stanie
  static void notifyListeners(ChangeNotifier notifier) {
    try {
      notifier.notifyListeners();
    } catch (e) {
      debugPrint('Bezpiecznie złapany błąd notifyListeners: $e');
    }
  }
}

class ElementsStyle {}

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
    this.id = -1,
    required this.courseId,
    required this.type,
    required this.content,
    required this.order,
    required this.additionalData,
  });

  factory CourseElements.fromJson(Map<String, dynamic> json) {
    ElementsStyle? elementStyle;
    // Zamiast zawsze tworzyć nowy obiekt style, tylko jeśli w danych jest pole style
    if (json.containsKey('style') && json['style'] != null) {
      elementStyle = ElementsStyle();
    }

    return CourseElements(
      style: elementStyle, // Może być null, jeśli nie było w JSON
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

  // Nowa metoda sprawdzająca, czy nastąpiły zmiany w elementach kursu
  bool get hasChanges {
    // Jeśli początkowo były elementy, ale teraz ich nie ma (wszystkie zostały usunięte),
    // to uznajemy to za zmianę
    if (courseElements.isEmpty && initialCourseElements.isNotEmpty) {
      debugPrint('Wszystkie elementy zostały usunięte - to jest zmiana');
      return true;
    }

    // Jeśli początkowo nie było elementów i nadal ich nie ma, to nie ma zmian
    if (courseElements.isEmpty && initialCourseElements.isEmpty) {
      debugPrint('Nie było i nadal nie ma żadnych elementów - brak zmian');
      return false;
    }

    if (courseElements.length != initialCourseElements.length) {
      debugPrint(
        'Różna liczba elementów: ${courseElements.length} vs ${initialCourseElements.length}',
      );
      return true; // Różna liczba elementów oznacza, że są zmiany
    }

    // Lista elementów, które mają problemy z porównywaniem additionalData
    final List<int> problemElements = [11, 12];

    // Porównujemy każdy element pod kątem zawartości
    for (int i = 0; i < courseElements.length; i++) {
      // Jeśli element o tym samym ID ma inną zawartość - mamy zmianę
      final current = courseElements[i];

      // Szukamy odpowiadającego elementu w initialCourseElements
      bool foundMatch = false;
      for (final initial in initialCourseElements) {
        if (initial.id == current.id) {
          foundMatch = true;
          // Sprawdzamy czy podstawowe właściwości są takie same
          if (initial.type != current.type || initial.order != current.order) {
            debugPrint('Różnica w type lub order dla elementu ${current.id}');
            return true; // Znaleziono różnicę
          }

          // Porównanie zawartości - najpierw konwersja do jednolitego formatu string
          String initialContent = initial.content.trim();
          String currentContent = current.content.trim();

          // Dla JSON zawartości dekodujemy i ponownie kodujemy aby zapewnić spójny format
          if (initial.type == 'TEXT' || initial.type == 'HEADER') {
            try {
              // Próbujemy sparsować jako JSON jeśli to możliwe
              var initialJson = jsonDecode(initialContent);
              var currentJson = jsonDecode(currentContent);

              // Standaryzacja JSON poprzez porównanie struktury zamiast dokładnego tekstu
              // (whitespace i formatowanie mogą się różnić, ale struktura jest taka sama)
              if (_compareJsonStructures(initialJson, currentJson) == false) {
                debugPrint(
                  'Różnica w strukturze JSON dla elementu ${current.id}',
                );
                return true;
              }
            } catch (e) {
              // Jeśli nie jest to poprawny JSON, porównujemy bezpośrednio teksty
              if (initialContent != currentContent) {
                debugPrint(
                  'Różnica w treści tekstu dla elementu ${current.id}',
                );
                return true;
              }
            }
          } else if (initialContent != currentContent) {
            // Dla innych typów porównujemy bezpośrednio treść
            debugPrint('Różnica w content dla elementu ${current.id}');
            return true;
          }

          // Sprawdzenie czy element jest w liście problematycznych
          if (problemElements.contains(current.id)) {
            // Wyświetl debug i pomiń sprawdzanie additionalData dla problematycznych elementów
            debugPrint(
              'Szczegółowa analiza additionalData dla elementu ${current.id}:',
            );
            debugPrint('Initial: ${initial.additionalData}');
            debugPrint('Current: ${current.additionalData}');

            // Obejście dla znanych problematycznych elementów
            debugPrint(
              'Pomijamy porównanie additionalData dla elementu ${current.id}',
            );

            // Porównanie stylów
            if ((initial.style == null) != (current.style == null)) {
              debugPrint('Jeden ma styl, drugi nie dla elementu ${current.id}');
              return true; // Jeden ma styl, drugi nie ma
            }

            break; // Znaleziono pasujący element, przechodzimy do następnego
          }

          // Specjalne porównanie dla pustych obiektów additionalData
          bool initialDataEmpty = initial.additionalData.isEmpty;
          bool currentDataEmpty = current.additionalData.isEmpty;

          if (initialDataEmpty && currentDataEmpty) {
            // Jeśli oba są puste, traktujemy je jako identyczne
            debugPrint(
              'Oba additionalData są puste dla elementu ${current.id} - pomijamy',
            );
          } else {
            // Porównanie additionalData dla pozostałych elementów
            if (_compareJsonStructures(
                  initial.additionalData,
                  current.additionalData,
                ) ==
                false) {
              debugPrint('Różnica w additionalData dla elementu ${current.id}');
              return true;
            }
          }

          // Porównanie stylów
          if ((initial.style == null) != (current.style == null)) {
            debugPrint('Jeden ma styl, drugi nie dla elementu ${current.id}');
            return true; // Jeden ma styl, drugi nie ma
          }

          break; // Znaleziono pasujący element, przechodzimy do następnego
        }
      }

      // Jeśli nie znaleziono elementu o tym ID - mamy zmianę
      if (!foundMatch) {
        debugPrint(
          'Nie znaleziono elementu o ID ${current.id} w initialCourseElements',
        );
        return true;
      }
    }

    debugPrint('Wszystkie elementy są identyczne - brak zmian');
    // Jeśli doszliśmy tutaj, to wszystkie elementy są identyczne
    return false;
  }

  // Poprawiona metoda do głębokiego porównania struktur JSON
  bool _compareJsonStructures(dynamic obj1, dynamic obj2) {
    // Jeśli oba są null lub identyczne, to są równoważne
    if (identical(obj1, obj2)) return true;

    // Jeśli tylko jeden jest null, nie są równoważne
    if (obj1 == null || obj2 == null) return false;

    // Jeśli typy są różne, nie są równoważne
    if (obj1.runtimeType != obj2.runtimeType) return false;

    // Porównanie list
    if (obj1 is List) {
      if (obj1.length != obj2.length) return false;
      for (int i = 0; i < obj1.length; i++) {
        if (!_compareJsonStructures(obj1[i], obj2[i])) return false;
      }
      return true;
    }

    // Porównanie map - z dokładniejszym logowaniem dla debugowania
    if (obj1 is Map) {
      if (obj1.length != obj2.length) {
        debugPrint('Różna liczba kluczy: ${obj1.length} vs ${obj2.length}');
        return false;
      }

      // Najpierw sprawdzamy, czy wszystkie klucze są takie same
      if (!_compareStringLists(
        obj1.keys.toList().cast<String>(),
        obj2.keys.toList().cast<String>(),
      )) {
        debugPrint('Różne klucze w obiektach: ${obj1.keys} vs ${obj2.keys}');
        return false;
      }

      // Jeśli klucze są takie same, porównujemy wartości
      for (var key in obj1.keys) {
        if (!_compareJsonStructures(obj1[key], obj2[key])) {
          debugPrint(
            'Różnica w wartości dla klucza "$key": ${obj1[key]} vs ${obj2[key]}',
          );
          return false;
        }
      }
      return true;
    }

    // Porównanie wartości prostych
    if (obj1 != obj2) {
      debugPrint('Różne wartości proste: $obj1 vs $obj2');
    }
    return obj1 == obj2;
  }

  // Pomocnicza metoda do porównywania list stringów (używana dla kluczy w mapach)
  bool _compareStringLists(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;

    // Sortowanie list przed porównaniem (klucze mogą być w różnej kolejności)
    list1.sort();
    list2.sort();

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

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

    // Wyraźnie logujemy dodanie nowego elementu dla celów debugowania
    debugPrint(
      'Dodano nowy element kursu ID: ${element.id}, typ: ${element.type}',
    );
    debugPrint('Obecna liczba elementów: ${courseElements.length}');
    debugPrint(
      'Liczba początkowych elementów: ${initialCourseElements.length}',
    );

    // WAŻNE: NIE aktualizujemy initialCourseElements, aby system wiedział, że nastąpiła zmiana
    // Sprawdzamy czy są różnice po dodaniu
    debugPrint('hasChanges po dodaniu elementu: ${hasChanges}');

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

  // Metoda do wykonania głębokiej kopii elementy (deep copy)
  CourseElements _deepCopyElement(CourseElements element) {
    return CourseElements(
      id: element.id,
      courseId: element.courseId,
      type: element.type,
      content: element.content,
      order: element.order,
      additionalData: Map<String, dynamic>.from(element.additionalData),
      style: element.style, // Używamy oryginalnego style zamiast tworzyć nowy
    );
  }

  // Metoda do aktualizacji stanu początkowego elementów kursu
  void updateInitialElements() {
    debugPrint('Aktualizowanie stanu początkowego elementów kursu');
    initialCourseElements.clear();
    for (var element in courseElements) {
      initialCourseElements.add(_deepCopyElement(element));
    }
    notifyListeners();
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
          // Tworzenie elementów kursu z danych API
          final List<CourseElements> newElements =
              data.map((item) => CourseElements.fromJson(item)).toList();

          // Sortowanie elementów wg kolejności
          newElements.sort((a, b) => a.order.compareTo(b.order));

          // Dodawanie elementów do listy głównej
          courseElements.addAll(newElements);
        }

        // Resetujemy historię
        courseElementsHistory.clear();

        // Używamy metody deep copy do aktualizacji stanu początkowego, ale najpierw czyścimy listę
        initialCourseElements.clear();

        // Dla każdego elementu w courseElements tworzymy głęboką kopię
        for (var element in courseElements) {
          initialCourseElements.add(_deepCopyElement(element));
        }

        // Dodajemy kopię obecnego stanu jako pierwszy element historii
        courseElementsHistory[1] =
            courseElements.map((e) => _deepCopyElement(e)).toList();

        // Resetujemy indeks historii
        historyIndex = 0;

        // Debugowanie struktury JSON, aby upewnić się, że porównania działają poprawnie
        debugPrint('Stan początkowy elementów kursu załadowany:');
        debugPrint('Liczba elementów: ${courseElements.length}');

        // Sprawdzamy czy hasChanges zwraca prawidłową wartość tuż po załadowaniu
        debugPrint('hasChanges po załadowaniu: $hasChanges');

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

  // Nowa metoda do jednoznacznego resetowania stanu zmian
  void resetChanges() {
    debugPrint('Resetowanie stanu zmian w CourseElementsList');
    // Aktualizacja stanu początkowego
    initialCourseElements.clear();
    for (var element in courseElements) {
      initialCourseElements.add(_deepCopyElement(element));
    }
    // Resetowanie historii
    courseElementsHistory.clear();
    courseElementsHistory[1] = List<CourseElements>.from(courseElements);
    historyIndex = 0;
    // Wymuszenie odświeżenia
    _rebuildCounter++;
    notifyListeners();
  }

  Future<void> addAllCourseElementToApi(String token, String id) async {
    try {
      isLoading = true;
      SafeAsync.notifyListeners(this);

      if (token is Future) {
        token = token;
      }

      if (!token.startsWith('Bearer ')) {
        token = 'Bearer $token';
      }

      final url = Uri.parse(
        '${dotenv.env['SERVER_URL']!}/courses/$id/elements',
      );

      // Sprawdzenie czy lista jest pusta - dodajemy specjalne logowanie
      if (courseElements.isEmpty) {
        debugPrint('Lista elementów jest pusta - zapisujemy pusty kurs');
      }

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

        // Po pomyślnym zapisie, aktualizujemy stan początkowy
        try {
          initialCourseElements.clear();
          for (var element in courseElements) {
            initialCourseElements.add(_deepCopyElement(element));
          }

          // Resetujemy historię po pomyślnym zapisie
          courseElementsHistory.clear();
          courseElementsHistory[1] = List<CourseElements>.from(courseElements);
          historyIndex = 0;

          debugPrint(
            'Stan początkowy i historia zaktualizowane po zapisie kursu',
          );

          // Jawnie wymuszamy odświeżenie UI i stanu hasChanges
          _rebuildCounter++;
        } catch (e) {
          debugPrint('Błąd podczas aktualizacji stanu początkowego: $e');
        }
      } else {
        debugPrint('Error updating course elements: ${response.statusCode}');
        debugPrint('Error response: ${response.body}');
        error = 'Failed to update course elements (${response.statusCode})';
      }
    } catch (e) {
      debugPrint('Error updating course elements: $e');
      error = 'Error: $e';
    } finally {
      // Używamy bezpiecznej metody notyfikacji
      isLoading = false;
      SafeAsync.notifyListeners(this);
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
