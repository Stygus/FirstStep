import 'dart:math' as Math;

import 'package:firststep/models/courses/courses.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'dart:convert';

class CourseDialog extends ConsumerStatefulWidget {
  final Course course;

  const CourseDialog({super.key, required this.course});

  @override
  ConsumerState<CourseDialog> createState() => _CourseDialogState();
}

class _CourseDialogState extends ConsumerState<CourseDialog> {
  @override
  void initState() {
    super.initState();
    // Załaduj elementy kursu automatycznie po otwarciu dialogu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadElements();
    });
  }

  void loadElements() async {
    final user = ref.read(userProvider);
    final elements = widget.course.courseElementsList;
    try {
      final token = await user.getToken() ?? '';
      await elements.getAllCourseElementsFromApi(
        token,
        widget.course.id.toString(),
      );
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Błąd: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final elements = widget.course.courseElementsList;

    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informacje o kursie w scrollowalnym kontenerze
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.course.description,
                      style: TextStyle(color: Colors.grey[300], fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    _buildInfoSection(
                      "Data utworzenia:",
                      "${widget.course.creationDate.day}.${widget.course.creationDate.month}.${widget.course.creationDate.year}",
                    ),
                    SizedBox(height: 8),
                    _buildInfoSection(
                      "Ostatnia modyfikacja:",
                      "${widget.course.modificationDate.day}.${widget.course.modificationDate.month}.${widget.course.modificationDate.year}",
                    ),
                    SizedBox(height: 16),
                    _buildInfoSection(
                      "Status:",
                      widget.course.status,
                      color: _getStatusColor(widget.course.status),
                    ),
                    SizedBox(height: 8),
                    _buildInfoSection(
                      "Poziom trudności:",
                      widget.course.difficultyLevel,
                      color: _getDifficultyColor(widget.course.difficultyLevel),
                    ),
                    SizedBox(height: 8),
                    _buildInfoSection(
                      "Liczba uczestników:",
                      "${widget.course.studentCount}",
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Kategorie:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          widget.course.categories.isNotEmpty
                              ? widget.course.categories
                                  .map((cat) => _buildCategoryChip(cat.name))
                                  .toList()
                              : [_buildCategoryChip('Brak kategorii')],
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.white, thickness: 1),
                    SizedBox(height: 16),
                    Text(
                      "Zawartość kursu:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Sekcja z elementami kursu
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      child: _buildCourseElements(elements),
                    ),
                  ],
                ),
              ),
            ),

            // Przyciski akcji na dole
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Zamknij', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseElements(CourseElementsList elements) {
    if (elements.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Ładowanie elementów kursu...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (elements.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Wystąpił błąd podczas ładowania elementów',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              elements.error!,
              style: TextStyle(color: Colors.red[300], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (elements.courseElements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.grey, size: 48),
            SizedBox(height: 16),
            Text(
              'Ten kurs nie ma jeszcze żadnych elementów',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: elements.courseElements.length,
      separatorBuilder:
          (context, index) => Divider(color: Colors.grey[800], height: 1),
      itemBuilder: (context, index) {
        final element = elements.courseElements[index];
        return _buildCourseElementTile(element);
      },
    );
  }

  Widget _buildCourseElementTile(CourseElements element) {
    Widget leading;
    String subtitle;

    switch (element.type.toUpperCase()) {
      case 'HEADER':
        leading = Icon(Icons.title, color: Colors.blue);
        subtitle = "Nagłówek";
        break;
      case 'TEXT':
        leading = Icon(Icons.text_fields, color: Colors.green);
        subtitle = "Tekst";
        break;
      case 'IMAGE':
        leading = Icon(Icons.image, color: Colors.amber);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: leading,
              title: Text("Obraz", style: TextStyle(color: Colors.white)),
              trailing: Text(
                'Pozycja: ${element.order}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Image.network(
                element.content,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
          ],
        );
      case 'CODE':
        leading = Icon(Icons.code, color: Colors.purple);
        subtitle = "Kod";
        break;
      default:
        leading = Icon(Icons.help_outline, color: Colors.grey);
        subtitle = element.type;
    }

    return ListTile(
      leading: leading,
      title: Text(
        element.content.length > 50
            ? '${element.content.substring(0, 50)}...'
            : element.content,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
      trailing: Text(
        'Pozycja: ${element.order}',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, {Color? color}) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 16)),
        SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

// Funkcja pomocnicza do łatwego wyświetlania dialogu z kursem
void showCourseDialog(BuildContext context, Course course) {
  showDialog(
    context: context,
    builder: (context) => CourseDialog(course: course),
  );
}
