import 'dart:convert';
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
import 'package:video_player/video_player.dart';

// Funkcja pomocnicza do konwersji niepoprawnego formatu JSON do poprawnego

class CourseCreator extends ConsumerStatefulWidget {
  const CourseCreator({super.key});

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

                  return Stack(
                    key: ValueKey(
                      'course_element_${element.id}_${courseElements.rebuildCounter}',
                    ),
                    children: [
                      // Dodaj przycisk do usuwania elementu
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Column(
                          children: [
                            Card(
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
                          ],
                        ),
                      ),

                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: Center(
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
                      ),
                    ],
                  );
                },
                itemCount: courseElements.courseElements.length,
              ),
            ),
          ],
        ),
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
      if (op is Map &&
          op['attributes'] != null &&
          op['attributes']['header'] != null) {
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
      if (op is Map && op['insert'] is String) {
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
    final courseElements = ref.watch(courseElementsProvider);

    switch (widget.courseElements.type) {
      case 'VIDEO':
        // Standardowa obsługa dla prawidłowego pliku wideo
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
        return IntrinsicWidth(
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
        );

      case 'HEADER':
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: IntrinsicWidth(
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
                    height: 40,
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
                IntrinsicWidth(
                  child: Padding(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Column(
                                  children: [
                                    // Pasek narzędzi do formatowania nagłówka - uproszczona wersja dla nagłówków
                                    QuillSimpleToolbar(
                                      controller: _controller,
                                      config: QuillSimpleToolbarConfig(
                                        headerStyleType:
                                            HeaderStyleType.buttons,
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                        showInlineCode: false,
                                        showSuperscript: false,
                                        showFontFamily: false,
                                        showSubscript: false,
                                        showHeaderStyle:
                                            true, // Wyłączamy style nagłówków w nagłówku
                                        showFontSize:
                                            false, // Pozostawiamy rozmiar czcionki
                                        showAlignmentButtons: true,
                                        showBackgroundColorButton: false,
                                        showListBullets:
                                            false, // Wyłączamy listy w nagłówku
                                        showListCheck: false,
                                        showListNumbers: false,
                                        showCodeBlock: false,
                                        showQuote: false,
                                        showSearchButton: false,
                                        showColorButton: true, // Kolor tekstu
                                        showBoldButton: true, // Pogrubienie
                                        showItalicButton: true, // Kursywa
                                        showUnderLineButton:
                                            true, // Podkreślenie
                                        showStrikeThrough: false,
                                        showClearFormat: true,
                                        multiRowsDisplay:
                                            false, // Jedna linia narzędzi
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
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

                                              // Aktualizacja stylów nagłówka na podstawie formatowania
                                              final plainText =
                                                  _controller.document
                                                      .toPlainText()
                                                      .trim();

                                              setState(() {
                                                widget.courseElements.content =
                                                    json;

                                                // Zachowujemy również poprzednie style
                                                if (widget
                                                        .courseElements
                                                        .style !=
                                                    null) {
                                                  // Style aktualizujemy tylko jeśli już istnieją
                                                  // Font size zostaje bez zmian, bo jest kontrolowany osobno
                                                }

                                                action = '';
                                              });
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
                              : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: () {
                                  try {
                                    // Próbujemy wyrenderować jako RichText jeśli treść jest w JSON
                                    return RichTextRenderer(
                                      jsonContent:
                                          widget.courseElements.content,
                                    );
                                  } catch (e) {
                                    // Jeśli nie jest w formacie JSON, wyświetlamy jako zwykły tekst
                                    // używając IntrinsicWidth, aby tekst miał szerokość dopasowaną do zawartości
                                    return IntrinsicWidth(
                                      child: Text(
                                        widget.courseElements.content,
                                        style: TextStyle(
                                          fontSize:
                                              widget
                                                  .courseElements
                                                  .style
                                                  ?.fontSize ??
                                              24.0,
                                          fontWeight:
                                              widget
                                                          .courseElements
                                                          .style
                                                          ?.isBold ??
                                                      true
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              widget
                                                  .courseElements
                                                  .style
                                                  ?.color ??
                                              Colors.white,
                                          fontStyle:
                                              widget
                                                          .courseElements
                                                          .style
                                                          ?.isItalic ??
                                                      false
                                                  ? FontStyle.italic
                                                  : FontStyle.normal,
                                          decoration:
                                              widget
                                                          .courseElements
                                                          .style
                                                          ?.isUnderline ??
                                                      false
                                                  ? TextDecoration.underline
                                                  : null,
                                        ),
                                      ),
                                    );
                                  }
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
                    height: 40,
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
          ),
        );
      case 'TEXT':
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
                  height: 40,
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
              Padding(
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
                                          _controller.document
                                              .toDelta()
                                              .toJson(),
                                        );
                                        setState(() {
                                          widget.courseElements.content = json;
                                          action = '';
                                        });
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
                  height: 40,
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
        // Kompletnie nowa implementacja dla obrazów z użyciem ConstrainedBox zamiast IntrinsicWidth
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
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
                        widget.courseElements.additionalData['caption'] != null)
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
                    ClipRRect(
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
