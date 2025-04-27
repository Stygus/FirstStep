import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/courses/courses.dart';

// Provider typu StateNotifierProvider dla CourseList
final coursesProvider = ChangeNotifierProvider((ref) => CourseList());

final courseElementsProvider = ChangeNotifierProvider(
  (ref) => CourseElementsList(),
);
