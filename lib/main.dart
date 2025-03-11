import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logowanie.dart';
import 'rejestracja.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: Logowanie(),
        routes: {
          '/logowanie': (context) => Logowanie(),
          '/rejestracja': (context) => Rejestracja(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/logowanie');
            },
            child: Text('Logowanie'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/rejestracja');
            },
            child: Text('Rejestracja'),
          ),
        ],
      ),
    );
  }
}
