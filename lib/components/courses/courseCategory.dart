import 'package:firststep/models/courses/courses.dart';
import 'package:flutter/material.dart';

class CourseCategory extends StatelessWidget {
  CourseCategory({
    Key? key,
    required this.category,
    required this.course,
    required this.onCategoryRemoved,
  }) : super(key: key);

  final Category category;
  final Course course;
  final VoidCallback onCategoryRemoved;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 65, 65, 65),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category.name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              // Usuwamy kategorię z kursu
              course.categories.remove(category);

              // Wywołujemy callback do odświeżenia UI rodzica
              onCategoryRemoved();

              // Wyświetlamy krótki komunikat o usunięciu
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kategoria ${category.name} została usunięta'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
