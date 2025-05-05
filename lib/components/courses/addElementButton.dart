import 'dart:math' as Math;
import 'dart:convert';

import 'package:firststep/components/courses/fileSelector.dart';
import 'package:firststep/models/courses/courses.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddElement extends ConsumerWidget {
  const AddElement({
    super.key,
    required this.courseElementOrder,
    required this.courseId,
  });

  final int courseElementOrder;
  final int courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pobieramy coursesProvider wcześniej, żeby uniknąć używania ref po zniszczeniu widgetu
    final courseElementsNotifier = ref.read(courseElementsProvider.notifier);

    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color.fromARGB(255, 45, 45, 45),
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.3,
              maxChildSize: 0.7,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Wybierz rodzaj elementu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.text_fields,
                              color: Colors.white,
                            ),
                            title: const Text(
                              'Text',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              CourseElements courseElement = CourseElements(
                                additionalData: {},
                                order:
                                    courseElementOrder, // Order elementu pozostaje taki jak pozycja wstawienia
                                style: ElementsStyle(),
                                type: 'TEXT',
                                content: jsonEncode([
                                  {"insert": "Nowy tekst\n"},
                                ]),
                                courseId: courseId,
                              );

                              // Przekazujemy courseElementOrder jako miejsce wstawienia
                              courseElementsNotifier.addCourseElement(
                                courseElement,
                                courseElementOrder,
                              );

                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.title,
                              color: Colors.white,
                            ),
                            title: const Text(
                              'Nagłówek',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              CourseElements courseElement = CourseElements(
                                additionalData: {},
                                order:
                                    courseElementOrder, // Order elementu pozostaje taki jak pozycja wstawienia
                                style: ElementsStyle(),
                                id: Math.Random().nextInt(10000),
                                type: 'HEADER',
                                content: jsonEncode([
                                  {"insert": "Nowy nagłówek\n"},
                                ]),
                                courseId: courseId,
                              );

                              // Przekazujemy courseElementOrder jako miejsce wstawienia
                              courseElementsNotifier.addCourseElement(
                                courseElement,
                                courseElementOrder,
                              );

                              Navigator.of(context).pop();
                            },
                          ),
                          FileSelector(
                            onFileSelected: (selectedFile) {
                              // Zamknij bottom sheet
                              Navigator.of(context).pop();

                              // Określ typ elementu na podstawie typu pliku
                              String elementType = 'IMAGE';
                              if (selectedFile.mimeType.startsWith('video/')) {
                                elementType = 'VIDEO';
                              }

                              // Dodaj nowy element kursu
                              CourseElements courseElement = CourseElements(
                                order:
                                    courseElementOrder, // Order elementu pozostaje taki jak pozycja wstawienia
                                style: ElementsStyle(),
                                id: Math.Random().nextInt(10000),
                                type: elementType,
                                content: selectedFile.url,
                                courseId: courseId,
                                additionalData: {},
                              );

                              // Przekazujemy courseElementOrder jako miejsce wstawienia
                              courseElementsNotifier.addCourseElement(
                                courseElement,
                                courseElementOrder,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      icon: const Icon(Icons.add, color: Colors.blue, size: 30),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromARGB(255, 26, 26, 26),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
