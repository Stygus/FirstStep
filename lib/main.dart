import 'package:english_words/english_words.dart';
import 'package:firststep/providers/animationsProvider.dart';
import 'package:firststep/start.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'logowanie.dart';
import 'rejestracja.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final container = ProviderContainer();
  container.read(animationsProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: testowy()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'FirstStep',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          scaffoldBackgroundColor: Color(0xFF1E1E1E),
        ),
      ),
    );
  }
}
