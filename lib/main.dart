import 'package:firststep/providers/animationsProvider.dart';
import 'package:firststep/start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final container = ProviderContainer();
  container.read(animationsProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: MyApp()), // Aplikacja mobilna
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        themeAnimationStyle: AnimationStyle(
          duration: Duration(milliseconds: 500),
        ),
        title: 'FirstStep',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: Start(),
      ),
    );
  }
}
