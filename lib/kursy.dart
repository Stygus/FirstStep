import 'package:firststep/components/courses/RichTextFormatter.dart';
import 'package:firststep/components/courses/videoControls.dart';
import 'package:firststep/components/courses/videoPlayer.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firststep/narzedziar.dart';
import 'package:firststep/testy.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const KursyPage(),
        '/narzedziar': (context) => const NarzedziarPage(),
        '/testy': (context) => const TestyPage(),
      },
    ),
  );
}

class KursyPage extends ConsumerWidget {
  const KursyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 30,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF101010),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.1,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.001),
                    child: Text(
                      'Kursy',
                      style: GoogleFonts.itim(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: screenWidth * 0.15, // Zmniejszono wysokość linii
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

          Center(
            child: SizedBox(
              height: 200,
              child: Container(
                color: const Color(0xFF1D1D1D),
                child: PageView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NarzedziarPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/N1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TestyPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/N2.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Courses(),
        ],
      ),
    );
  }
}

class Courses extends ConsumerStatefulWidget {
  const Courses({super.key});

  @override
  ConsumerState<Courses> createState() => _CoursesState();
}

class _CoursesState extends ConsumerState<Courses> {
  void getCourses() async {
    final courses = ref.read(coursesProvider);
    final user = ref.read(userProvider);
    try {
      await courses.getAllCoursesFromApi(await user.getToken() ?? '');
      debugPrint('Courses: ${courses.courses.length}');
    } catch (e, stack) {
      debugPrint('Błąd pobierania kursów: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  @override
  void initState() {
    getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coursesList = ref.watch(coursesProvider);

    if (coursesList.courses.isEmpty) {
      return const Center(
        child: Text(
          'Brak kursów do wyświetlenia',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: coursesList.bestCourses.length,
        itemBuilder: (context, index) {
          final course = coursesList.bestCourses[index];
          return Card(
            color: const Color(0xFF1D1D1D),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    course.title, // poprawka: użycie 'title' zamiast 'name'
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    course.description, // poprawka: bez operatora ??
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Course(course: course),
                      ),
                    );
                  },
                ),
                if (course.categories.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        bottom: 8.0,
                        right: 16.0,
                      ),
                      child: Wrap(
                        spacing: 8,
                        children:
                            course.categories
                                .map<Widget>(
                                  (cat) => Chip(
                                    label: Text(
                                      cat.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.blueGrey[700],
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Course extends ConsumerStatefulWidget {
  final dynamic course;

  const Course({super.key, required this.course});

  @override
  ConsumerState<Course> createState() => _CourseState();
}

class _CourseState extends ConsumerState<Course> {
  // Mapa kontrolerów wideo (klucz: unikalny identyfikator elementu wideo)
  final Map<String, VideoPlayerController> _videoControllers = {};

  // Flagi formatów wideo do wykrywania
  final List<String> _videoFormats = [
    '.mp4',
    '.webm',
    '.mov',
  ]; // Znane formaty wideo
  bool _isLowBitrateMode = false; // Flaga do przełączania na niski bitrate

  @override
  void initState() {
    super.initState();
    // Załaduj elementy kursu przy starcie
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCourseElements();
    });
  }

  @override
  void dispose() {
    // Zwalniamy wszystkie kontrolery wideo przy usuwaniu widgetu
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    super.dispose();
  }

  // Metoda do uzyskania lub utworzenia kontrolera wideo dla danego URL i elementu
  Future<VideoPlayerController?> _getVideoController(
    String videoUrl, {
    required String elementId,
  }) async {
    if (videoUrl.isEmpty) {
      debugPrint('Pusty URL wideo');
      return null;
    }

    // Tworzymy unikalny klucz dla tego elementu - zapewni to osobny kontroler nawet dla elementów z tym samym URL
    final uniqueKey = 'video_$elementId';

    // Sprawdzamy, czy już mamy kontroler dla tego elementu
    if (_videoControllers.containsKey(uniqueKey)) {
      debugPrint(
        'Użycie istniejącego kontrolera wideo dla elementu: $elementId',
      );
      return _videoControllers[uniqueKey];
    }

    // Konwertujemy URL, jeśli jest localhost
    final convertedUrl = _convertLocalhostUrl(videoUrl);
    debugPrint(
      'Tworzenie nowego kontrolera wideo dla: $convertedUrl (element: $elementId)',
    );

    // Sprawdzamy czy URL wymaga modyfikacji (zmiana formatu, bitrate, itp)
    final finalUrl =
        _isLowBitrateMode ? _createLowBitrateUrl(convertedUrl) : convertedUrl;

    // Tworzymy nowy kontroler
    final controller = VideoPlayerController.networkUrl(Uri.parse(finalUrl));

    // Inicjalizujemy kontroler z obsługą błędów
    try {
      await controller.initialize();
      // Sprawdzamy czy kontroler został poprawnie zainicjalizowany
      if (controller.value.isInitialized) {
        debugPrint(
          'Kontroler wideo zainicjalizowany pomyślnie dla elementu: $elementId',
        );
        _videoControllers[uniqueKey] = controller;
        return controller;
      } else {
        debugPrint(
          'Kontroler został utworzony, ale nie zainicjalizowany poprawnie dla elementu: $elementId',
        );
        await controller.dispose();

        // Jeśli nie jesteśmy jeszcze w trybie niskiego bitrate, spróbujmy go włączyć
        if (!_isLowBitrateMode) {
          _isLowBitrateMode = true;
          debugPrint(
            'Przełączanie na tryb niskiego bitrate dla elementu: $elementId',
          );
          return _getVideoController(videoUrl, elementId: elementId);
        }
        return null;
      }
    } catch (e) {
      debugPrint(
        'Błąd inicjalizacji kontrolera wideo dla elementu $elementId: $e',
      );
      await controller.dispose();

      // Jeśli nie jesteśmy jeszcze w trybie niskiego bitrate, spróbujmy go włączyć
      if (!_isLowBitrateMode) {
        _isLowBitrateMode = true;
        debugPrint(
          'Po błędzie - przełączanie na tryb niskiego bitrate dla elementu: $elementId',
        );
        return _getVideoController(videoUrl, elementId: elementId);
      }

      // W przypadku błędu, próbujemy otworzyć URL bezpośrednio
      debugPrint(
        'Wszystkie próby zawiodły. Przygotowanie do bezpośredniego otwarcia URL dla elementu: $elementId',
      );
      return null;
    }
  }

  // Pomocnicza metoda do tworzenia URL z niskim bitrate
  String _createLowBitrateUrl(String url) {
    // Tutaj możemy modyfikować URL aby zmniejszyć bitrate lub rozdzielczość
    // Na przykład dodając parametry do URL lub zmieniając rozdzielczość
    // Zwracamy oryginalny URL jeśli nie ma możliwości modyfikacji
    return url;
  }

  Future<void> loadCourseElements() async {
    final courseElements = ref.read(courseElementsProvider);
    final user = ref.read(userProvider);
    final token = await user.getToken() ?? '';

    try {
      courseElements.courseElements.clear();
      await courseElements.getAllCourseElementsFromApi(
        token,
        widget.course.id.toString(),
      ); // Po załadowaniu elementów, inicjalizujemy kontrolery wideo dla wszystkich elementów wideo
      if (mounted) {
        for (var element in courseElements.courseElements) {
          if (element.type.toUpperCase() == 'VIDEO' &&
              element.content.isNotEmpty) {
            try {
              // Preinicjalizacja kontrolera wideo - ale nie czekamy na dokończenie
              _getVideoController(
                element.content,
                elementId: element.id.toString(),
              );
            } catch (e) {
              debugPrint(
                'Błąd wstępnej inicjalizacji wideo dla ${element.content}: $e',
              );
              // Kontynuujemy, mimo błędu - zajmiemy się tym przy wyświetlaniu
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd ładowania elementów kursu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseElements = ref.watch(courseElementsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          widget.course.title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body:
          courseElements.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount:
                    courseElements.courseElements.length +
                    1, // +1 dla nagłówka kursu
                itemBuilder: (context, index) {
                  // Pierwszy element to nagłówek z tytułem i opisem kursu
                  if (index == 0) {
                    return Container(
                      color: const Color(0xFF1D1D1D),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tytuł kursu
                          Text(
                            widget.course.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Opis kursu
                          Text(
                            widget.course.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Status i poziom trudności w jednym wierszu
                          Row(
                            children: [
                              // Status kursu
                              Text(
                                'Status: ',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.course.status,
                                style: TextStyle(
                                  color: _getStatusColor(widget.course.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Poziom trudności
                              Text(
                                'Poziom: ',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                widget.course.difficultyLevel,
                                style: TextStyle(
                                  color: _getDifficultyColor(
                                    widget.course.difficultyLevel,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          // Daty utworzenia i modyfikacji
                          Row(
                            children: [
                              Text(
                                'Utworzono: ',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                _formatDate(widget.course.creationDate),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          // Tytuł sekcji elementów kursu
                          const Divider(color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            'Zawartość kursu:',
                            style: TextStyle(
                              color: Colors.blue[300],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Dla pozostałych indeksów wyświetlamy elementy kursu
                  final element = courseElements.courseElements[index - 1];

                  return Card(
                    color: const Color.fromARGB(0, 38, 38, 38),
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: _buildCourseElement(element),
                  );
                },
              ),
    );
  }

  // Metoda pomocnicza do przekształcania URL-i lokalnych na IP serwera
  String _convertLocalhostUrl(String url) {
    if (url.isEmpty) {
      debugPrint('Pusty URL do konwersji');
      return url;
    }

    // Drukujemy oryginalny URL do diagnostyki
    debugPrint('Oryginalny URL: $url');

    // Sprawdzamy, czy URL już jest poprawny (np. zaczyna się od http:// lub https://)
    bool isValidUrl = url.startsWith('http://') || url.startsWith('https://');
    bool isLocalhost = url.contains('localhost') || url.contains('127.0.0.1');

    // Jeśli URL nie jest lokalny i jest już poprawnym URL, zwracamy go bez zmian
    if (isValidUrl && !isLocalhost) {
      debugPrint('URL jest już poprawnym adresem: $url');
      return url;
    }

    debugPrint(
      'URL wymaga konwersji - localhost: $isLocalhost, ważny URL: $isValidUrl',
    );

    try {
      // Pobieramy ścieżkę pliku
      String filePath = '';

      if (url.contains('/uploads/')) {
        filePath = url.split('/uploads/').last;
        debugPrint('Wyodrębniona ścieżka pliku z /uploads/: $filePath');
      } else if (isLocalhost) {
        // Jeśli to localhost, ale nie zawiera /uploads/, próbujemy wyodrębnić ścieżkę
        Uri uri;
        try {
          uri = Uri.parse(url);
          if (uri.pathSegments.isNotEmpty) {
            filePath = uri.pathSegments.join('/');
            debugPrint('Ścieżka pliku wyodrębniona z URI: $filePath');
          }
        } catch (e) {
          debugPrint('Błąd parsowania URI: $e');
          // Próbujemy prostszej metody
          final parts = url.split('/');
          if (parts.length > 1) {
            filePath = parts.sublist(parts.length > 3 ? 3 : 1).join('/');
            debugPrint('Ścieżka wyodrębniona z części URL: $filePath');
          }
        }
      } else if (!isValidUrl) {
        // Jeśli URL nie zaczyna się od http, prawdopodobnie jest to relatywna ścieżka
        filePath = url;
        debugPrint('Potraktowano jako ścieżkę relatywną: $filePath');
      }

      // Jeśli nie udało się wyodrębnić ścieżki, sprawdźmy czy to nie jest pełny URL
      if (filePath.isEmpty && !isValidUrl) {
        debugPrint(
          'Nie udało się wyodrębnić ścieżki pliku, próbujemy jako pełny URL',
        );
        // Sprawdźmy, czy to nie jest pełna ścieżka do pliku
        if (url.contains('.')) {
          // Jeśli zawiera kropkę, może to być nazwa pliku
          filePath = url;
        } else {
          debugPrint('Nie można przetworzyć URL, zwracam oryginalny: $url');
          return url;
        }
      }

      // Tworzymy nowy URL z adresem IP serwera
      String serverUrl = dotenv.env['SERVER_URL'] ?? 'http://192.168.1.20:3000';
      debugPrint('Adres serwera z .env: $serverUrl');

      // Upewniamy się, że ścieżka jest poprawnie sformatowana
      if (filePath.startsWith('/')) {
        filePath = filePath.substring(1);
      }

      // Dodajemy folder uploads jeśli potrzebny
      if (!filePath.startsWith('uploads/') && isLocalhost) {
        filePath = 'uploads/$filePath';
      }

      // Formatujemy końcowy URL
      String baseUrl = serverUrl.endsWith('/') ? serverUrl : '$serverUrl/';
      String realUrl = '$baseUrl$filePath';

      debugPrint('Przekonwertowany URL: $realUrl');
      return realUrl;
    } catch (e) {
      debugPrint('Błąd podczas konwersji URL: $e');
      // W przypadku błędu zwracamy oryginalny URL z ew. dodaniem http:// jeśli brakuje
      if (!isValidUrl && !url.startsWith('http')) {
        return 'http://$url';
      }
      return url;
    }
  }

  // Nowa metoda pomocnicza do wyświetlania obrazów
  Widget _buildImageWidget(String imageUrl, BuildContext context) {
    // Drukujemy oryginalny URL do diagnostyki
    debugPrint('Oryginalny URL obrazu: $imageUrl');

    // Sprawdzamy czy URL zaczyna się od localhost lub 127.0.0.1
    bool isLocalhost =
        imageUrl.contains('localhost') || imageUrl.contains('127.0.0.1');

    debugPrint('URL zawiera localhost/127.0.0.1: $isLocalhost');

    String realImageUrl = imageUrl;
    if (isLocalhost) {
      // Pobieramy ścieżkę pliku z oryginalnego URL
      String filePath = '';
      if (imageUrl.contains('/uploads/')) {
        filePath = imageUrl.split('/uploads/').last;
        debugPrint('Wyodrębniona ścieżka pliku: $filePath');
      }

      // Tworzymy nowy URL z adresem IP serwera
      String serverUrl = dotenv.env['SERVER_URL'] ?? 'http://192.168.1.20:3000';
      debugPrint('Adres serwera z .env: $serverUrl');

      realImageUrl = '$serverUrl/uploads/$filePath';
      debugPrint('Nowy URL obrazu: $realImageUrl');
    }
    if (isLocalhost) {
      // Jeśli to lokalny URL, teraz spróbujmy użyć nowego URL
      try {
        return Image.network(
          realImageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Błąd ładowania obrazu lokalnego z nowym URL: $error');
            return Container(
              width: 300,
              height: 150,
              color: Colors.grey[700],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber, color: Colors.amber, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Obraz lokalny (localhost)',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Problem z ładowaniem',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 300,
              height: 150,
              color: Colors.grey[800],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ładowanie obrazu...',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } catch (e) {
        debugPrint('Nieoczekiwany błąd podczas ładowania obrazu: $e');
        return Container(
          width: 300,
          height: 150,
          color: Colors.red[900],
          child: const Center(
            child: Text(
              'Błąd ładowania obrazu',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } else {
      // Dla normalnych URL'i próbujemy załadować obraz
      return Image.network(
        realImageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Błąd ładowania obrazu: $error');
          return Container(
            width: 300,
            height: 150,
            color: Colors.grey[700],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Nie można załadować obrazu',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 300,
            height: 150,
            color: Colors.grey[800],
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                color: Colors.white,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildCourseElement(dynamic element) {
    switch (element.type.toUpperCase()) {
      case 'HEADER':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: RichTextRenderer(jsonContent: element.content),
        );

      case 'TEXT':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: RichTextRenderer(jsonContent: element.content),
        );

      // Implementacja przypadku IMAGE
      case 'IMAGE':
        return Align(
          alignment: Alignment.centerLeft,
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Zawartość obrazu
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      if (element.additionalData != null &&
                          element.additionalData.containsKey('caption') &&
                          element.additionalData['caption'] != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            element.additionalData['caption'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        width:
                            MediaQuery.of(context).size.width > 500
                                ? 500
                                : MediaQuery.of(context).size.width * 0.9,
                        height:
                            MediaQuery.of(context).size.width > 500
                                ? 500
                                : MediaQuery.of(context).size.width * 0.9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: _buildImageWidget(element.content, context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ); // Nowa implementacja wideo dla kursy.dart
      case 'VIDEO':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<VideoPlayerController?>(
            future: _getVideoController(
              _convertLocalhostUrl(element.content),
              elementId: element.id.toString(),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.grey[800],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 8),
                        Text(
                          'Ładowanie wideo...',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                debugPrint('Błąd ładowania wideo: ${snapshot.error}');
                return Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.grey[700],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Błąd ładowania wideo',
                        style: TextStyle(color: Colors.white),
                      ),
                      // Dodajemy przycisk do próby ponownego załadowania
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Spróbuj ponownie'),
                        onPressed: () {
                          setState(() {
                            // Force rebuild to retry
                            _isLowBitrateMode = !_isLowBitrateMode;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.value.isInitialized) {
                final controller = snapshot.data!;

                debugPrint('Wideo zainicjalizowane: ${controller.dataSource}');

                // Używamy nowego komponentu VideoPlayerWidget do obsługi wideo
                return VideoPlayerWidget(controller: controller);
              } else {
                return Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.grey[700],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber,
                          size: 40,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Nie można załadować wideo',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sprawdź połączenie z internetem',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        );

      case 'CODE':
        return Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            element.content,
            style: const TextStyle(
              color: Colors.lightGreenAccent,
              fontFamily: 'monospace',
            ),
          ),
        );

      default:
        return ListTile(
          title: Text(
            'Nieznany element: ${element.type}',
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            element.content.length > 50
                ? '${element.content.substring(0, 50)}...'
                : element.content,
            style: const TextStyle(color: Colors.grey),
          ),
        );
    }
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

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }
}
