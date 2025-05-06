import 'dart:convert';
import 'dart:math' as Math;
import 'package:firststep/components/courses/RichTextFormatter.dart';
import 'package:firststep/components/courses/addElementButton.dart';
import 'package:firststep/components/courses/videoControls.dart';
import 'package:firststep/models/courses/courses.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Dodany import do obsługi klawiatury
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as colorPicker;
import 'package:flutter_svg/flutter_svg.dart'; // Import biblioteki do obsługi plików SVG
import 'package:video_player/video_player.dart';

// Funkcja pomocnicza do konwersji niepoprawnego formatu JSON do poprawnego

class CourseCreator extends ConsumerStatefulWidget {
  CourseCreator({super.key, required this.course});

  Course course;

  @override
  ConsumerState<CourseCreator> createState() => _CourseCreatorState();
}

class _CourseCreatorState extends ConsumerState<CourseCreator> {
  final List<TextFragment> fragments = [
    TextFragment(
      text: "Pierwsza pomoc ",
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    ),
    TextFragment(
      text: "to zespół czynności ratujących życie.",
      style: const TextStyle(color: Colors.white),
    ),
  ];

  // Przenosimy stan courseEdit na poziom klasy
  String courseEdit = "not";

  // Nowa, bezpieczna metoda do aktualizacji stanu courseEdit
  void setCourseEdit(String value) {
    debugPrint('✅ Aktualizacja courseEdit z: $courseEdit na: $value');
    setState(() {
      courseEdit = value;
    });
  }

  @override
  void dispose() {
    // Czyszczenie wszystkich kontrolerów wideo przy zamykaniu strony
    _CourseElementWidgetState.disposeAllVideoControllers();

    // Bezpieczna obsługa przerwania operacji asynchronicznych i odśmiecanie zasobów
    try {
      // Dodatkowe zabezpieczenie przed próbami aktualizacji UI po usunięciu widgetu
      final courseElements = ref.read(courseElementsProvider);
      courseElements.isLoading =
          false; // Zatrzymujemy wszelkie trwające operacje ładowania
    } catch (e) {
      debugPrint('Błąd podczas sprzątania przy zamykaniu widoku: $e');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseElements = ref.watch(courseElementsProvider);

    bool hasChanges = false;

    if (courseElements.initialCourseElements.isNotEmpty) {
      hasChanges =
          courseElements.hasChanges ||
          (courseElements.initialCourseElements.isNotEmpty &&
              courseElements.courseElements.isEmpty);
    } else {
      hasChanges = courseElements.courseElements.isNotEmpty;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        title: const Text(
          'Course Creator',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              courseElements.backToPreviousState();
            },
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: () {
              // Dodaj logikę ponownego wykonania zmian
              courseElements.forwardToNextState();
            },
            icon: const Icon(Icons.redo),
          ),
          IconButton(
            icon: const Icon(
              Icons.keyboard_return_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              // Dodaj logikę cofania zmian
              courseElements.undoAllChanges();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed:
                hasChanges
                    ? () async {
                      await courseElements.addAllCourseElementToApi(
                        await ref.read(userProvider).getToken() ?? '',
                        courseElements.courseElements.isEmpty
                            ? ref
                                    .read(coursesProvider)
                                    .selectedCourse
                                    ?.id
                                    .toString() ??
                                "0"
                            : courseElements.courseElements[0].courseId
                                .toString(),
                      );

                      // Jawne wywołanie resetowania stanu zmian
                      courseElements.resetChanges();

                      // Wymuszamy odświeżenie widoku po zapisie
                      setState(() {
                        // setState wymusi przebudowanie widgetu i ponowne obliczenie hasChanges
                      });
                    }
                    : null,
            color: hasChanges ? Colors.blue : Colors.grey,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Wyświetl komunikat o pustej liście i duży przycisk dodawania gdy nie ma elementów
          if (courseElements.courseElements.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Kurs nie ma jeszcze elementów',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(100),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        // Dodaj pierwszy element kursu
                        if (ref.read(coursesProvider).selectedCourse != null) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: const Color.fromARGB(
                              255,
                              45,
                              45,
                              45,
                            ),
                            builder:
                                (context) => AddElement(
                                  courseElementOrder: 0,
                                  courseId:
                                      ref
                                          .read(coursesProvider)
                                          .selectedCourse!
                                          .id,
                                ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Kliknij aby dodać pierwszy element',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    key: ValueKey(
                      'course_list_${courseElements.rebuildCounter}',
                    ),
                    itemBuilder: (context, index) {
                      // Jeśli to pierwszy element, wyświetlamy container
                      if (index == 0) {
                        return Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 400,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 45, 45, 45),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(100),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onDoubleTap: () => setCourseEdit('title'),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child:
                                        courseEdit == 'title'
                                            ? TextField(
                                              autofocus: true,
                                              maxLines: 1,
                                              minLines: 1,
                                              controller: TextEditingController(
                                                text: widget.course.title,
                                              ),
                                              onChanged: (value) {
                                                widget.course.title = value;
                                              },
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                              decoration: const InputDecoration(
                                                hintText: 'Tytuł kursu',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
                                              ),
                                              // Obsługa klawisza Enter - niestandardowa
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.done,
                                              // Używamy onSubmitted do przechwycenia zdarzenia Enter
                                              onSubmitted: (value) {
                                                setCourseEdit('not');
                                              },
                                              // Dodajemy obsługę klawisza Enter poprzez fokus
                                              focusNode: FocusNode(
                                                onKeyEvent: (node, event) {
                                                  // Sprawdzamy czy to Enter bez Shifta
                                                  if (event.logicalKey ==
                                                          LogicalKeyboardKey
                                                              .enter &&
                                                      !HardwareKeyboard
                                                          .instance
                                                          .isShiftPressed) {
                                                    if (event is KeyDownEvent) {
                                                      setCourseEdit('not');
                                                      return KeyEventResult
                                                          .handled;
                                                    }
                                                  }
                                                  return KeyEventResult.ignored;
                                                },
                                              ),
                                            )
                                            : Text(
                                              widget.course.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Material(
                                  color: Colors.transparent,
                                  child: GestureDetector(
                                    onDoubleTap: () {
                                      setCourseEdit('description');
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                        horizontal: 8.0,
                                      ),
                                      child:
                                          courseEdit == 'description'
                                              ? TextField(
                                                autofocus: true,
                                                maxLines: 5,
                                                minLines: 1,
                                                controller:
                                                    TextEditingController(
                                                      text:
                                                          widget
                                                              .course
                                                              .description,
                                                    ),
                                                onChanged: (value) {
                                                  widget.course.description =
                                                      value;
                                                  debugPrint(
                                                    'Opis kursu zmieniony na: $value',
                                                  );
                                                },
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                      hintText: 'Opis kursu',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                      border: InputBorder.none,
                                                    ),
                                                // Obsługa klawisza Enter - niestandardowa
                                                keyboardType:
                                                    TextInputType.multiline,
                                                textInputAction:
                                                    TextInputAction.done,
                                                // Używamy onSubmitted do przechwycenia zdarzenia Enter
                                                onSubmitted: (value) {
                                                  debugPrint(
                                                    '✅ Zatwierdzone przez Enter: $value',
                                                  );
                                                  setCourseEdit('not');
                                                },
                                                // Dodajemy obsługę klawisza Enter poprzez fokus
                                                focusNode: FocusNode(
                                                  onKeyEvent: (node, event) {
                                                    // Sprawdzamy czy to Enter bez Shifta
                                                    if (event.logicalKey ==
                                                            LogicalKeyboardKey
                                                                .enter &&
                                                        !HardwareKeyboard
                                                            .instance
                                                            .isShiftPressed) {
                                                      if (event
                                                          is KeyDownEvent) {
                                                        // Zapisujemy tekst i wyjdź z trybu edycji
                                                        debugPrint(
                                                          '✅ Enter wciśnięty - zapisuję i wychodzę',
                                                        );
                                                        setCourseEdit('not');
                                                        return KeyEventResult
                                                            .handled;
                                                      }
                                                    }
                                                    // Dla innych klawiszy lub Shift+Enter pozwalamy na domyślne zachowanie
                                                    return KeyEventResult
                                                        .ignored;
                                                  },
                                                ),
                                              )
                                              : Text(
                                                widget.course.description,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 16.0,
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Status kursu: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        DropdownButton<String>(
                                          value:
                                              widget.course.status ?? 'DRAFT',
                                          dropdownColor: const Color.fromARGB(
                                            255,
                                            45,
                                            45,
                                            45,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.blueAccent,
                                          ),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                widget.course.status = newValue;
                                              });
                                              // Update course status in provider
                                              widget.course.status = newValue;
                                            }
                                          },
                                          items:
                                              <String>[
                                                'DRAFT',
                                                'PUBLISHED',
                                                'ARCHIVED',
                                              ].map<DropdownMenuItem<String>>((
                                                String value,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                      color:
                                                          value == 'PUBLISHED'
                                                              ? Colors.green
                                                              : value ==
                                                                  'ARCHIVED'
                                                              ? Colors.grey
                                                              : Colors.orange,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Poziom trudności: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        DropdownButton<String>(
                                          value:
                                              widget.course.difficultyLevel ??
                                              'BEGINNER',
                                          dropdownColor: const Color.fromARGB(
                                            255,
                                            45,
                                            45,
                                            45,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.blueAccent,
                                          ),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                widget.course.difficultyLevel =
                                                    newValue;
                                              });
                                            }
                                          },
                                          items:
                                              <String>[
                                                'BEGINNER',
                                                'INTERMEDIATE',
                                                'ADVANCED',
                                                'EXPERT',
                                              ].map<DropdownMenuItem<String>>((
                                                String value,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                      color:
                                                          value == 'BEGINNER'
                                                              ? Colors.green
                                                              : value ==
                                                                  'INTERMEDIATE'
                                                              ? Colors.blue
                                                              : value ==
                                                                  'ADVANCED'
                                                              ? Colors.orange
                                                              : Colors.red,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Dla pozostałych indeksów wyświetlamy elementy kursu
                      final element = courseElements.courseElements[index - 1];

                      return Stack(
                        key: ValueKey(
                          'course_element_${element.id}_${courseElements.rebuildCounter}',
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Card(
                              color: const Color.fromARGB(22, 45, 45, 45),
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: CourseElementWidget(
                                key: ValueKey(
                                  'widget_${element.id}_${courseElements.rebuildCounter}',
                                ),
                                courseElements: element,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 0,
                            bottom: 0,
                            right: 0,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Dodaj logikę usuwania elementu
                                  courseElements.removeCourseElement(
                                    element.id,
                                  );

                                  // Po usunięciu elementu, wymuszamy odświeżenie wszystkich kontrolerów wideo
                                  _CourseElementWidgetState.resetVideoControllers();
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    // +1 ponieważ pierwszy element to container
                    itemCount: courseElements.courseElements.length + 1,
                  ),
                ),
              ],
            ),

          hasChanges
              ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue,

                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed:
                          () async => courseElements.addAllCourseElementToApi(
                            await ref.read(userProvider).getToken() ?? '',
                            courseElements.courseElements.isEmpty
                                ? ref
                                        .read(coursesProvider)
                                        .selectedCourse
                                        ?.id
                                        .toString() ??
                                    "0"
                                : courseElements.courseElements[0].courseId
                                    .toString(),
                          ),
                    ),
                  ),
                ),
              )
              : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(123, 99, 104, 107),

                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.save,
                        color: Color.fromARGB(123, 255, 255, 255),
                        size: 50,
                      ),
                      onPressed: () {
                        debugPrint('Nie ma zmian do zapisania');
                      },
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class CourseElementWidget extends ConsumerStatefulWidget {
  const CourseElementWidget({super.key, required this.courseElements});
  final CourseElements courseElements;

  @override
  ConsumerState<CourseElementWidget> createState() =>
      _CourseElementWidgetState();
}

class _CourseElementWidgetState extends ConsumerState<CourseElementWidget> {
  String action = '';
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _textController;
  final QuillController _controller = QuillController.basic();
  VideoPlayerController? _videoPlayerController;
  bool _isVideoInitialized = false;
  bool hovering = false;
  bool hoveringTop =
      false; // Dodana zmienna do śledzenia najechania na górny obszar
  bool hoveringBottom = false; // Dodana zmienna do śledzenia na dolny obszar
  // Statyczna mapa do przechowywania kontrolerów wideo
  static final Map<String, VideoPlayerController> _videoControllers = {};

  // Statyczna metoda do czyszczenia wszystkich kontrolerów wideo
  static void disposeAllVideoControllers() {
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    debugPrint('Wszystkie kontrolery wideo zostały wyczyszczone');
  }

  // Metoda do resetowania kontrolerów wideo po zmianie układu elementów
  static void resetVideoControllers() {
    debugPrint('Resetowanie i odświeżanie kontrolerów wideo...');
    // Zachowujemy referencje do kontrolerów, ale resetujemy stan inicjalizacji
    // co spowoduje ponowne zainicjalizowanie kontrolerów przy kolejnym renderowaniu widżetu
    _videoControllers.forEach((key, controller) {
      if (controller.value.isInitialized) {
        // Zapisujemy czy wideo było odtwarzane
        final wasPlaying = controller.value.isPlaying;
        final position = controller.value.position;

        // Odtwarzamy wideo od tej samej pozycji jeśli było odtwarzane
        if (wasPlaying) {
          controller.seekTo(position).then((_) {
            controller.play();
          });
        }
      }
    });
  }

  void _setHeaderSelectionFromDoc() {
    final delta = _controller.document.toDelta().toJson();
    int offset = 0;
    for (final op in delta) {
      if (op['attributes'] != null && op['attributes']['header'] != null) {
        // Ustaw selection na początek tego nagłówka
        _controller.updateSelection(
          TextSelection.collapsed(offset: offset),
          ChangeSource.local,
        );
        // Ustaw styl nagłówka
        // Get the header level from the delta
        final int headerLevel = op['attributes']['header'];
        // Apply the correct header attribute based on the level
        if (headerLevel == 1) {
          _controller.formatSelection(Attribute.h1);
        } else if (headerLevel == 2) {
          _controller.formatSelection(Attribute.h2);
        } else if (headerLevel == 3) {
          _controller.formatSelection(Attribute.h3);
        }
        break;
      }
      if (op['insert'] is String) {
        offset += (op['insert'] as String).length;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(
      text: widget.courseElements.content,
    );
    _textController.addListener(() {
      widget.courseElements.content = _textController.text;
    });
    if (widget.courseElements.type == 'TEXT') {
      try {
        final json = widget.courseElements.content;
        _controller.document = Document.fromJson(jsonDecode(json));
      } catch (e) {
        debugPrint('Błąd przy ustawianiu treści QuillEditor: $e');
      }
    }
    if (widget.courseElements.type == 'HEADER') {
      try {
        final json = widget.courseElements.content;
        _controller.document = Document.fromJson(jsonDecode(json));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _setHeaderSelectionFromDoc();
        });
      } catch (e) {
        debugPrint('Błąd przy ustawianiu treści QuillEditor: $e');
      }
    }
    if (widget.courseElements.type == 'VIDEO') {
      _initializeVideoPlayer();
    }

    // Usuwamy automatyczne resetowanie stanu przy inicjalizacji, aby wykrywać zmiany
    debugPrint(
      'CourseElementWidget initialized for element ID: ${widget.courseElements.id}',
    );
  }

  void _initializeVideoPlayer() {
    if (_isVideoInitialized) return;

    try {
      final String contentUrl = widget.courseElements.content;
      // Używamy tylko ID elementu jako klucza - to jest bardziej stabilne przy przebudowie
      final String videoKey = "video_${widget.courseElements.id}";

      // Sprawdzanie, czy URL wskazuje na plik wideo, a nie obraz lub inny format
      final bool isVideo = _isVideoUrl(contentUrl);

      if (!isVideo) {
        // Jeśli to nie jest plik wideo, wyświetl placeholder obrazu
        setState(() {
          _isVideoInitialized = false;
        });
        debugPrint('URL nie wskazuje na plik wideo: $contentUrl');
        return;
      }

      // Sprawdź, czy już istnieje kontroler dla tego wideo
      if (_videoControllers.containsKey(videoKey) &&
          _videoControllers[videoKey]!.value.isInitialized &&
          _videoControllers[videoKey]!.dataSource == contentUrl) {
        debugPrint(
          'Wykorzystanie istniejącego kontrolera dla wideo ID: ${widget.courseElements.id}',
        );
        _videoPlayerController = _videoControllers[videoKey]!;
        setState(() {
          _isVideoInitialized = true;
        });
        return;
      }

      // Jeśli kontroler istnieje, ale dla innego URL, zwolnij go i utwórz nowy
      if (_videoControllers.containsKey(videoKey)) {
        debugPrint(
          'Usuwanie starego kontrolera dla wideo ID: ${widget.courseElements.id}',
        );
        _videoControllers[videoKey]!.dispose();
        _videoControllers.remove(videoKey);
      }

      // Utwórz nowy kontroler
      debugPrint(
        'Tworzenie nowego kontrolera dla wideo ID: ${widget.courseElements.id}',
      );
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(contentUrl),
        formatHint: VideoFormat.hls,
      );

      // Zapisz kontroler w mapie do potencjalnego ponownego użycia
      _videoControllers[videoKey] = _videoPlayerController!;

      _videoPlayerController!
          .initialize()
          .then((_) {
            // Upewnij się, że widget jest wciąż zamontowany
            if (mounted) {
              setState(() {
                _isVideoInitialized = true;
              });
              debugPrint(
                'Wideo zainicjalizowane dla ID: ${widget.courseElements.id}',
              );
            }
          })
          .catchError((error) {
            debugPrint('Błąd inicjalizacji wideo: $error');
            // Usuń nieudany kontroler z mapy
            if (_videoControllers.containsKey(videoKey)) {
              _videoControllers.remove(videoKey);
            }
          });
    } catch (e) {
      debugPrint('Błąd podczas tworzenia kontrolera wideo: $e');
    }
  }

  // Sprawdza, czy URL wskazuje na plik wideo na podstawie rozszerzenia
  bool _isVideoUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return false;

    final String path = uri.path.toLowerCase();
    final List<String> videoExtensions = [
      '.mp4',
      '.webm',
      '.ogg',
      '.mov',
      '.avi',
      '.m3u8',
      '.mpd',
    ];

    return videoExtensions.any((ext) => path.endsWith(ext));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Usuwamy inicjalizację wideo z didChangeDependencies
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();

    // Nie usuwamy kontrolera z mapy - będzie on mógł być ponownie użyty
    // Nie wywołujemy też dispose() na kontrolerze, żeby zapewnić jego dostępność dla pozostałych elementów
    // Kontrolery wideo są zarządzane globalnie i zostaną automatycznie wyczyszczone po zamknięciu strony

    super.dispose();
  }

  void changeAction(String newAction) {
    setState(() {
      action = newAction;
      if (newAction == 'edit') {
        _focusNode.requestFocus();
      }
    });
  }

  // Dodajemy funkcję do wymuszenia notyfikacji o zmianach
  void _notifyContentChanged() {
    try {
      if (!mounted) {
        debugPrint('Widget nie jest już zamontowany - pomijamy aktualizację');
        return;
      }

      debugPrint(
        'Powiadomienie o zmianie contentu: ${widget.courseElements.id}',
      );

      // Używamy Future.microtask aby odłożyć aktualizację na później
      Future.microtask(() {
        try {
          if (mounted) {
            final elementsProvider = ref.read(courseElementsProvider);
            // Używamy bezpiecznej metody notyfikacji z SafeAsync
            SafeAsync.notifyListeners(elementsProvider);
          }
        } catch (e) {
          debugPrint('Bezpiecznie złapany błąd podczas aktualizacji UI: $e');
        }
      });
    } catch (e) {
      debugPrint('Błąd w _notifyContentChanged: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseElements = ref.watch(courseElementsProvider);

    // Sprawdzanie zmian w logu debugowania
    debugPrint(
      'Renderowanie CourseElementWidget dla ID: ${widget.courseElements.id}, content (first 30 chars): ${widget.courseElements.content.length > 30 ? widget.courseElements.content.substring(0, 30) : widget.courseElements.content}...',
    );

    switch (widget.courseElements.type) {
      case 'VIDEO':
        if (_videoPlayerController == null || !_isVideoInitialized) {
          return MouseRegion(
            onEnter: (_) => setState(() => hovering = true),
            onExit: (_) => setState(() => hovering = false),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onPressed: () {},
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Ładowanie wideo...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        // Kontynuacja tylko jeśli kontroler jest zainicjalizowany
        return Align(
          alignment: Alignment.centerLeft,
          child: IntrinsicWidth(
            child: Column(
              children: <Widget>[
                // Górny przycisk dodawania przed elementem - osobny MouseRegion zamiast InkWell
                MouseRegion(
                  onEnter: (_) {
                    setState(() => hoveringTop = true);
                  },
                  onExit: (_) {
                    setState(() => hoveringTop = false);
                  },
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child:
                        hoveringTop
                            ? Center(
                              child: AddElement(
                                courseElementOrder: widget.courseElements.order,
                                courseId: widget.courseElements.courseId,
                              ),
                            )
                            : const SizedBox(),
                  ),
                ),

                SizedBox(
                  width: 500,
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        VideoPlayer(_videoPlayerController!),
                        ControlsOverlay(
                          controller: _videoPlayerController!,
                          videoUrl: widget.courseElements.content,
                        ),
                        VideoProgressIndicator(
                          colors: VideoProgressColors(
                            playedColor: Colors.green,
                            backgroundColor: Colors.grey,
                          ),
                          _videoPlayerController!,
                          allowScrubbing: true,
                        ),
                      ],
                    ),
                  ),
                ),
                // Dodajemy przycisk do dodawania elementu poniżej wideo
                MouseRegion(
                  onEnter: (_) {
                    setState(() => hovering = true);
                  },
                  onExit: (_) {
                    setState(() => hovering = false);
                  },
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child:
                        hovering
                            ? Center(
                              child: AddElement(
                                courseElementOrder:
                                    widget.courseElements.order + 1,
                                courseId: widget.courseElements.courseId,
                              ),
                            )
                            : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'HEADER':
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Column(
            children: [
              // Górny przycisk dodawania przed elementem - osobny MouseRegion zamiast InkWell
              MouseRegion(
                onEnter: (_) {
                  setState(() => hoveringTop = true);
                },
                onExit: (_) {
                  setState(() => hoveringTop = false);
                },
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child:
                      hoveringTop
                          ? Center(
                            child: AddElement(
                              courseElementOrder: widget.courseElements.order,
                              courseId: widget.courseElements.courseId,
                            ),
                          )
                          : const SizedBox(),
                ),
              ),

              // Zawartość nagłówka z obsługą double tap - teraz jak w TEXT używamy QuillEditor
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(() {
                      try {
                        _controller.document = Document.fromJson(
                          jsonDecode(widget.courseElements.content),
                        );
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _setHeaderSelectionFromDoc();
                        });
                      } catch (e) {
                        _controller.document = Document();
                        _controller.document.insert(
                          0,
                          widget.courseElements.content,
                        );
                        debugPrint(
                          'Inicjalizacja QuillEditor dla nagłówka: ${widget.courseElements.content}',
                        );
                      }
                      action = 'edit-header';
                    });
                  },
                  child:
                      action == 'edit-header'
                          ? SizedBox(
                            // Dodajemy określoną wysokość dla kontenera edytora - mniejsza niż dla TEXT
                            height: 400,
                            child: Column(
                              children: [
                                // Pasek narzędzi do formatowania nagłówka - własna implementacja zamiast QuillSimpleToolbar
                                Container(
                                  height: 45,
                                  color: const Color.fromARGB(255, 35, 35, 35),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.format_bold,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.bold,
                                              ),
                                          tooltip: 'Pogrubienie',
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.format_italic,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.italic,
                                              ),
                                          tooltip: 'Kursywa',
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.format_underline,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.underline,
                                              ),
                                          tooltip: 'Podkreślenie',
                                        ),
                                        const VerticalDivider(
                                          color: Colors.white54,
                                        ),
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            width: 24,
                                            'images/h1.svg',
                                            fit: BoxFit.scaleDown,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.h1,
                                              ),
                                          tooltip: 'Nagłówek 1',
                                        ),
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            width: 24,
                                            'images/h2.svg',
                                            fit: BoxFit.scaleDown,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.h2,
                                              ),
                                          tooltip: 'Nagłówek 2',
                                        ),
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            width: 24,
                                            'images/h3.svg',
                                            fit: BoxFit.scaleDown,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.h3,
                                              ),
                                          tooltip: 'Nagłówek 3',
                                        ),
                                        const VerticalDivider(
                                          color: Colors.white54,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.format_align_left,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.leftAlignment,
                                              ),
                                          tooltip: 'Wyrównanie do lewej',
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.format_align_center,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.centerAlignment,
                                              ),
                                          tooltip: 'Wyśrodkowanie',
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.format_align_right,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.rightAlignment,
                                              ),
                                          tooltip: 'Wyrównanie do prawej',
                                        ),
                                        const VerticalDivider(
                                          color: Colors.white54,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.format_color_text,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            // Otwieramy picker kolorów
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (context) => AlertDialog(
                                                    backgroundColor:
                                                        Colors.black,
                                                    title: const Text(
                                                      'Wybierz kolor tekstu',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    content: SingleChildScrollView(
                                                      child: colorPicker.ColorPicker(
                                                        pickerColor:
                                                            Colors.white,
                                                        onColorChanged: (
                                                          color,
                                                        ) {
                                                          String
                                                          hexColor = color.value
                                                              .toRadixString(16)
                                                              .padLeft(8, '0')
                                                              .substring(2);
                                                          _controller
                                                              .formatSelection(
                                                                Attribute.fromKeyValue(
                                                                  'color',
                                                                  '#$hexColor',
                                                                ),
                                                              );
                                                        },
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                            );
                                          },
                                          tooltip: 'Kolor tekstu',
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.format_clear,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _controller.formatSelection(
                                                Attribute.clone(
                                                  Attribute.link,
                                                  null,
                                                ),
                                              ),
                                          tooltip: 'Wyczyść formatowanie',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        30,
                                        30,
                                        30,
                                      ),
                                      border: Border.all(
                                        color: Colors.grey.shade700,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: QuillEditor(
                                      controller: _controller,
                                      scrollController: ScrollController(),
                                      focusNode: _focusNode,
                                      config: QuillEditorConfig(
                                        autoFocus: true,
                                        expands: false,
                                        padding: EdgeInsets.zero,
                                        enableSelectionToolbar: true,
                                        enableInteractiveSelection: true,
                                        // Używamy DefaultStyles własnych definicji
                                        customStyles: DefaultStyles(
                                          h1: DefaultTextBlockStyle(
                                            TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            const HorizontalSpacing(0, 0),
                                            const VerticalSpacing(8, 0),
                                            const VerticalSpacing(0, 8),
                                            const BoxDecoration(),
                                          ),
                                          h2: DefaultTextBlockStyle(
                                            TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            const HorizontalSpacing(0, 0),
                                            const VerticalSpacing(6, 0),
                                            const VerticalSpacing(0, 6),
                                            const BoxDecoration(),
                                          ),
                                          h3: DefaultTextBlockStyle(
                                            TextStyle(
                                              fontSize: 38,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            const HorizontalSpacing(0, 0),
                                            const VerticalSpacing(4, 0),
                                            const VerticalSpacing(0, 4),
                                            const BoxDecoration(),
                                          ),
                                          paragraph: DefaultTextBlockStyle(
                                            TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                            const HorizontalSpacing(0, 0),
                                            const VerticalSpacing(0, 0),
                                            const VerticalSpacing(0, 0),
                                            const BoxDecoration(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                OverflowBar(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          action = '';
                                        });
                                      },
                                      child: const Text(
                                        'Anuluj',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        try {
                                          // Zapisz treść JSON edytora do widget.courseElements.content
                                          final json = jsonEncode(
                                            _controller.document
                                                .toDelta()
                                                .toJson(),
                                          );

                                          setState(() {
                                            // Zapamiętujemy poprzedni content do debugowania
                                            final oldContent =
                                                widget.courseElements.content;
                                            widget.courseElements.content =
                                                json;

                                            debugPrint(
                                              'HEADER zmieniono content:',
                                            );
                                            debugPrint(
                                              'Stary: ${oldContent.substring(0, Math.min(50, oldContent.length))}...',
                                            );
                                            debugPrint(
                                              'Nowy: ${json.substring(0, Math.min(50, json.length))}...',
                                            );

                                            action = '';
                                          });

                                          // Powiadamiamy o zmianach
                                          _notifyContentChanged();
                                        } catch (e) {
                                          debugPrint(
                                            'Błąd zapisywania nagłówka: $e',
                                          );
                                          // W przypadku błędu, zachowujemy przynajmniej tekst
                                          setState(() {
                                            widget.courseElements.content =
                                                _controller.document
                                                    .toPlainText()
                                                    .trim();
                                            action = '';
                                          });
                                          // Powiadamiamy o zmianach
                                          _notifyContentChanged();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: const Text(
                                        'Zapisz',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          : Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: () {
                                // Próbujemy wyrenderować jako RichText jeśli treść jest w JSON
                                return RichTextRenderer(
                                  jsonContent: widget.courseElements.content,
                                );
                              }(),
                            ),
                          ),
                ),
              ),

              // Dolny przycisk dodawania po elemencie - osobny MouseRegion zamiast InkWell
              MouseRegion(
                onEnter: (_) {
                  setState(() => hoveringBottom = true);
                },
                onExit: (_) {
                  setState(() => hoveringBottom = false);
                },
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child:
                      hoveringBottom
                          ? Center(
                            child: AddElement(
                              courseElementOrder:
                                  widget.courseElements.order + 1,
                              courseId: widget.courseElements.courseId,
                            ),
                          )
                          : const SizedBox(),
                ),
              ),
            ],
          ),
        );
      case 'TEXT':
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Górny przycisk dodawania przed elementem - osobny MouseRegion zamiast InkWell
              MouseRegion(
                onEnter: (_) {
                  setState(() => hoveringTop = true);
                },
                onExit: (_) {
                  setState(() => hoveringTop = false);
                },
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child:
                      hoveringTop
                          ? Center(
                            child: AddElement(
                              courseElementOrder: widget.courseElements.order,
                              courseId: widget.courseElements.courseId,
                            ),
                          )
                          : const SizedBox(),
                ),
              ),
              GestureDetector(
                onDoubleTap: () {
                  // Umożliwia edycję tekstu po podwójnym kliknięciu
                  setState(() {
                    action = 'edit-rich-text';
                  });
                },
                child:
                    action == 'edit-rich-text'
                        ? SizedBox(
                          // Dodajemy określoną wysokość dla kontenera edytora
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            children: [
                              // Pasek narzędzi do formatowania tekstu
                              QuillSimpleToolbar(
                                controller: _controller,
                                config: QuillSimpleToolbarConfig(
                                  showInlineCode: false,
                                  showSuperscript: false,
                                  showFontFamily: false,
                                  showSubscript: false,
                                  showHeaderStyle: false,
                                  showFontSize: true,
                                  showAlignmentButtons: true,
                                  showBackgroundColorButton: true,
                                  showListBullets: true,
                                  showListCheck: true,
                                  showListNumbers: true,
                                  // showSearchButton: true,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      30,
                                      30,
                                      30,
                                    ),
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: QuillEditor(
                                    controller: _controller,
                                    scrollController: ScrollController(),
                                    focusNode: FocusNode(),
                                    config: QuillEditorConfig(
                                      autoFocus: true,
                                      expands: false,

                                      padding: EdgeInsets.zero,
                                      enableSelectionToolbar: true,
                                      enableInteractiveSelection: true,
                                      customStyles: DefaultStyles(
                                        // Ustawienie zerowego marginesu na końcu paragrafów
                                        paragraph: DefaultTextBlockStyle(
                                          const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                          const HorizontalSpacing(0, 0),
                                          const VerticalSpacing(0, 0),
                                          const VerticalSpacing(0, 0),
                                          const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        // Usuwamy dodatkową przestrzeń na końcu dokumentu
                                        lists: DefaultListBlockStyle(
                                          const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                          ),
                                          const HorizontalSpacing(0, 0),
                                          const VerticalSpacing(0, 0),
                                          const VerticalSpacing(0, 0),
                                          null,
                                          null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              OverflowBar(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        action = '';
                                      });
                                    },
                                    child: const Text(
                                      'Anuluj',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Zapisz treść JSON edytora do widget.courseElements.content
                                      final json = jsonEncode(
                                        _controller.document.toDelta().toJson(),
                                      );
                                      setState(() {
                                        // Zapamiętujemy poprzedni content do debugowania
                                        final oldContent =
                                            widget.courseElements.content;
                                        widget.courseElements.content = json;

                                        debugPrint('TEXT zmieniono content:');
                                        debugPrint(
                                          'Stary: ${oldContent.substring(0, Math.min(50, oldContent.length))}...',
                                        );
                                        debugPrint(
                                          'Nowy: ${json.substring(0, Math.min(50, json.length))}...',
                                        );

                                        action = '';
                                      });

                                      // Powiadamiamy o zmianach
                                      _notifyContentChanged();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text(
                                      'Zapisz',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: RichTextRenderer(
                            jsonContent: widget.courseElements.content,
                          ),
                        ),
              ),
              // Dolny przycisk dodawania po elemencie - osobny MouseRegion zamiast InkWell
              MouseRegion(
                onEnter: (_) {
                  setState(() => hoveringBottom = true);
                },
                onExit: (_) {
                  setState(() => hoveringBottom = false);
                },
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child:
                      hoveringBottom
                          ? Center(
                            child: AddElement(
                              courseElementOrder:
                                  widget.courseElements.order + 1,
                              courseId: widget.courseElements.courseId,
                            ),
                          )
                          : const SizedBox(),
                ),
              ),
            ],
          ),
        );
      case 'IMAGE':
        return Align(
          alignment: Alignment.centerLeft,
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Górny przycisk dodawania
                MouseRegion(
                  onEnter: (_) => setState(() => hoveringTop = true),
                  onExit: (_) => setState(() => hoveringTop = false),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child:
                        hoveringTop
                            ? Center(
                              child: AddElement(
                                courseElementOrder: widget.courseElements.order,
                                courseId: widget.courseElements.courseId,
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                ),

                // Zawartość obrazu
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      if (widget.courseElements.additionalData.containsKey(
                            'caption',
                          ) &&
                          widget.courseElements.additionalData['caption'] !=
                              null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            widget.courseElements.additionalData['caption'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        width: 500,
                        height: 500,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            widget.courseElements.content,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 300,
                                height: 150,
                                color: Colors.grey[700],
                                child: const Center(
                                  child: Icon(Icons.error, color: Colors.red),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 300,
                                height: 150,
                                color: Colors.grey[800],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Dolny przycisk dodawania
                MouseRegion(
                  onEnter: (_) => setState(() => hoveringBottom = true),
                  onExit: (_) => setState(() => hoveringBottom = false),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child:
                        hoveringBottom
                            ? Center(
                              child: AddElement(
                                courseElementOrder:
                                    widget.courseElements.order + 1,
                                courseId: widget.courseElements.courseId,
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'CODE':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Text(
              widget.courseElements.content,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.lightGreenAccent,
              ),
            ),
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Nieznany typ elementu: ${widget.courseElements.type}\n${widget.courseElements.content}',
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
  }
}
