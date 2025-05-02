import 'dart:convert';
import 'dart:math' as Math;

import 'package:firststep/components/courses/RichTextFormatter.dart';
import 'package:firststep/components/courses/videoControls.dart';
import 'package:firststep/models/courses/courses.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Dodany import do obsługi klawiatury
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as colorPicker;
import 'package:video_player/video_player.dart';

// Funkcja pomocnicza do konwersji niepoprawnego formatu JSON do poprawnego

class CourseCreator extends ConsumerStatefulWidget {
  CourseCreator({super.key});

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

  @override
  void dispose() {
    // Czyszczenie wszystkich kontrolerów wideo przy zamykaniu strony
    _CourseElementWidgetState.disposeAllVideoControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseElements = ref.watch(courseElementsProvider);
    debugPrint('CourseElements: ${courseElements.courseElements.length}');

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
                () async => courseElements.addAllCourseElementToApi(
                  await ref.read(userProvider).getToken() ?? '',
                  courseElements.courseElements[0].courseId.toString(),
                ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                key: ValueKey('course_list_${courseElements.rebuildCounter}'),
                itemBuilder: (context, index) {
                  final element = courseElements.courseElements[index];

                  // Obsługa pojedynczego elementu
                  return Stack(
                    key: ValueKey(
                      'course_element_${element.id}_${courseElements.rebuildCounter}',
                    ),
                    children: [
                      // Dodaj przycisk do usuwania elementu
                      Positioned(
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Dodaj logikę usuwania elementu
                            courseElements.removeCourseElement(element.id);

                            // Po usunięciu elementu, wymuszamy odświeżenie wszystkich kontrolerów wideo
                            _CourseElementWidgetState.resetVideoControllers();
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                    ],
                  );
                  // Obsługa grupy elementów tekstowych
                },
                itemCount: courseElements.courseElements.length,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Dodaj logikę dodawania nowego elementu
              },
              child: const Text('Dodaj nowy element'),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseElementWidget extends StatefulWidget {
  const CourseElementWidget({super.key, required this.courseElements});
  final CourseElements courseElements;

  @override
  State<CourseElementWidget> createState() => _CourseElementWidgetState();
}

class _CourseElementWidgetState extends State<CourseElementWidget> {
  String action = '';
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _textController;
  final QuillController _controller = QuillController.basic();
  VideoPlayerController? _videoPlayerController;
  bool _isVideoInitialized = false;
  // Dodajemy unikalny identyfikator dla każdego widżetu wideo
  final String _videoId = DateTime.now().millisecondsSinceEpoch.toString();

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

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.courseElements.content,
    );
    // Dodanie listenera do kontrolera tekstu
    _textController.addListener(() {
      widget.courseElements.content = _textController.text;
    });

    // Próba ustawienia treści dla edytora QuillEditor
    if (widget.courseElements.type == 'TEXT') {
      try {
        final json = widget.courseElements.content;
        _controller.document = Document.fromJson(jsonDecode(json));
      } catch (e) {
        debugPrint('Błąd przy ustawianiu treści QuillEditor: $e');
      }
    }

    // Inicjalizacja kontrolera wideo tutaj, a nie w didChangeDependencies
    if (widget.courseElements.type == 'VIDEO') {
      _initializeVideoPlayer();
    }
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

  void handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      if (action == 'edit') {
        setState(() {
          widget.courseElements.style?.fontSize =
              widget.courseElements.style?.fontSize ?? 24.0;
          action = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.courseElements.type) {
      case 'VIDEO':
        // Standardowa obsługa dla prawidłowego pliku wideo
        if (_videoPlayerController == null || !_isVideoInitialized) {
          return const Center(
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
          );
        }
        // Kontynuacja tylko jeśli kontroler jest zainicjalizowany
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                height: 500, // Dodana stała wysokość 300 pikseli
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
            ],
          ),
        );

      case 'HEADER':
        return Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter &&
                action == 'edit') {
              setState(() {
                widget.courseElements.style?.fontSize =
                    widget.courseElements.style?.fontSize ?? 24.0;
                action = '';
              });
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            onDoubleTap: action == 'edit' ? null : () => changeAction('edit'),
            child: switch (action) {
              'edit' => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // Wyświetl bottom sheet z wyborem koloru
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    45,
                                    45,
                                    45,
                                  ),
                                  builder: (BuildContext context) {
                                    return DraggableScrollableSheet(
                                      initialChildSize: 0.6,
                                      minChildSize: 0.3,
                                      maxChildSize: 0.9,
                                      expand: false,
                                      builder: (context, scrollController) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Wybierz kolor',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(color: Colors.grey),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                controller: scrollController,
                                                child: colorPicker.ColorPicker(
                                                  pickerColor:
                                                      widget
                                                          .courseElements
                                                          .style
                                                          ?.color ??
                                                      Colors.white,
                                                  onColorChanged: (
                                                    Color color,
                                                  ) {
                                                    setState(() {
                                                      widget
                                                          .courseElements
                                                          .style
                                                          ?.color = color;
                                                    });
                                                  },
                                                  pickerAreaHeightPercent: 0.7,
                                                  enableAlpha: true,
                                                  labelTypes: const [],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.circle,
                                color:
                                    widget.courseElements.style?.color ??
                                    Colors.white,
                              ),
                            ),
                            const Text(
                              'fontSize',
                              style: TextStyle(color: Colors.white),
                            ),
                            Slider(
                              value:
                                  widget.courseElements.style?.fontSize ?? 24.0,
                              min: 10.0,
                              max: 100.0,
                              onChanged: (value) {
                                setState(() {
                                  widget.courseElements.style?.fontSize =
                                      value.roundToDouble();
                                });
                              },
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                cursorColor: Colors.white,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'fontSize',
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                controller: TextEditingController(
                                  text:
                                      widget.courseElements.style?.fontSize
                                          .toString() ??
                                      '24.0',
                                ),
                                onSubmitted: (value) {
                                  setState(() {
                                    widget.courseElements.style?.fontSize =
                                        double.tryParse(value) ?? 24.0;
                                    action = '';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        ToggleButtons(
                          fillColor: const Color.fromARGB(129, 41, 255, 77),
                          selectedColor: const Color.fromARGB(129, 255, 41, 41),
                          color: Colors.grey,
                          isSelected: [
                            widget.courseElements.style?.isBold ?? false,
                            widget.courseElements.style?.isItalic ?? false,
                            widget.courseElements.style?.isUnderline ?? false,
                          ],
                          onPressed: (index) {
                            setState(() {
                              switch (index) {
                                case 0:
                                  widget.courseElements.style?.isBold =
                                      !(widget.courseElements.style?.isBold ??
                                          false);
                                  break;
                                case 1:
                                  widget.courseElements.style?.isItalic =
                                      !(widget.courseElements.style?.isItalic ??
                                          false);
                                  break;
                                case 2:
                                  widget.courseElements.style?.isUnderline =
                                      !(widget
                                              .courseElements
                                              .style
                                              ?.isUnderline ??
                                          false);
                                  break;
                              }
                            });
                          },
                          children: const [
                            Icon(Icons.format_bold, color: Colors.white),
                            Icon(Icons.format_italic, color: Colors.white),
                            Icon(Icons.format_underline, color: Colors.white),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            setState(() {
                              action = '';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: RawKeyboardListener(
                      focusNode: _focusNode,
                      onKey: handleKeyEvent,
                      child: TextField(
                        maxLength: null,
                        maxLines: null,
                        cursorColor: Colors.white,
                        autofocus: true,
                        controller: _textController,
                        style: TextStyle(
                          decorationColor:
                              widget.courseElements.style?.color ??
                              Colors.white,

                          fontSize:
                              widget.courseElements.style?.fontSize ?? 24.0,
                          fontWeight:
                              widget.courseElements.style?.isBold ?? false
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color:
                              widget.courseElements.style?.color ??
                              Colors.white,
                          fontStyle:
                              widget.courseElements.style?.isItalic ?? false
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                          decoration:
                              widget.courseElements.style?.isUnderline ?? false
                                  ? TextDecoration.underline
                                  : null,
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            action = '';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              _ => Text(
                widget.courseElements.content,
                style: TextStyle(
                  fontSize: widget.courseElements.style?.fontSize ?? 24.0,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationColor:
                      widget.courseElements.style?.color ?? Colors.white,
                  fontWeight:
                      widget.courseElements.style?.isBold ?? false
                          ? FontWeight.bold
                          : FontWeight.normal,
                  color: widget.courseElements.style?.color ?? Colors.white,
                  fontStyle:
                      widget.courseElements.style?.isItalic ?? false
                          ? FontStyle.italic
                          : FontStyle.normal,
                  decoration:
                      widget.courseElements.style?.isUnderline ?? false
                          ? TextDecoration.underline
                          : null,
                ),
              ),
            },
          ),
        );
      case 'TEXT':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
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
                                color: const Color.fromARGB(255, 30, 30, 30),
                                border: Border.all(color: Colors.grey.shade700),
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
                                    widget.courseElements.content = json;
                                    action = '';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Zapisz'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    : RichTextRenderer(
                      jsonContent: widget.courseElements.content,
                    ),
          ),
        );
      case 'IMAGE':
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.courseElements.additionalData.containsKey('caption') &&
                  widget.courseElements.additionalData['caption'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.courseElements.additionalData['caption'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              Image.network(
                widget.courseElements.content,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
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
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey[800],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ],
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

// Przykład widgetu z obsługą klawisza Enter
class KeyboardListenerExample extends StatefulWidget {
  const KeyboardListenerExample({super.key});

  @override
  State<KeyboardListenerExample> createState() =>
      _KeyboardListenerExampleState();
}

class _KeyboardListenerExampleState extends State<KeyboardListenerExample> {
  final FocusNode _focusNode = FocusNode();
  String _message = "Naciśnij Enter";

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            setState(() {
              _message = "Enter naciśnięty! ${DateTime.now()}";
            });
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          if (!_focusNode.hasFocus) {
            _focusNode.requestFocus();
          }
        },
        child: Container(
          color:
              _focusNode.hasFocus
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.transparent,
          padding: const EdgeInsets.all(16.0),
          child: Text(_message, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
