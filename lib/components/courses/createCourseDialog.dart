import 'package:firststep/models/courses/courses.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCourseDialog extends ConsumerStatefulWidget {
  const CreateCourseDialog({super.key});

  @override
  ConsumerState<CreateCourseDialog> createState() => _CreateCourseDialogState();
}

class _CreateCourseDialogState extends ConsumerState<CreateCourseDialog> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedDifficultyLevel = 'BASIC';
  String selectedStatus = 'DRAFT';

  // Lista poziomów trudności
  final difficultyLevels = ['BASIC', 'INTERMEDIATE', 'ADVANCED'];
  // Lista statusów
  final statusOptions = ['DRAFT', 'PUBLISHED', 'ARCHIVED'];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 38, 38, 38),
      title: Text(
        'Utwórz nowy kurs',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Tytuł kursu',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę podać tytuł kursu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Opis kursu',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę podać opis kursu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Selector poziomów trudności
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Poziom trudności',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  dropdownColor: Color.fromARGB(255, 50, 50, 50),
                  style: TextStyle(color: Colors.white),
                  value: selectedDifficultyLevel,
                  items:
                      difficultyLevels.map((String level) {
                        return DropdownMenuItem<String>(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedDifficultyLevel = newValue;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                // Selector statusu
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Status kursu',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  dropdownColor: Color.fromARGB(255, 50, 50, 50),
                  style: TextStyle(color: Colors.white),
                  value: selectedStatus,
                  items:
                      statusOptions.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedStatus = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Anuluj', style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text('Utwórz kurs'),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final user = ref.read(userProvider);
              final courses = ref.read(coursesProvider);

              // Pokazujemy wskaźnik ładowania
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(width: 16),
                      Text('Tworzenie kursu...'),
                    ],
                  ),
                  backgroundColor: Colors.blue,
                ),
              );

              try {
                // Pobieramy token i tworzymy kurs
                final token = await user.getToken();
                if (token != null) {
                  final newCourse = await courses.createCourseViaApi(
                    token,
                    titleController.text,
                    descriptionController.text,
                    selectedDifficultyLevel,
                    selectedStatus,
                  );

                  Navigator.of(context).pop(); // Zamykamy dialog

                  if (newCourse != null) {
                    // Pokazujemy komunikat sukcesu
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Kurs został utworzony pomyślnie!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // Pokazujemy komunikat błędu
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Nie udało się utworzyć kursu. Spróbuj ponownie.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  Navigator.of(context).pop(); // Zamykamy dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Błąd autoryzacji. Zaloguj się ponownie.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                Navigator.of(
                  context,
                ).pop(); // Zamykamy dialog w przypadku błędu
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Wystąpił błąd: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}

// Funkcja pomocnicza do wyświetlania dialogu
void showCreateCourseDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateCourseDialog();
    },
  );
}
