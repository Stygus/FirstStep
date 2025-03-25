import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logowanie.dart' as logowanie;
import 'rejestracja.dart';
import 'menu.dart' as menu;

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
        title: 'FirstStep',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          scaffoldBackgroundColor: Color(0xFF1E1E1E),
        ),
        // Ekran startowy
        home: logowanie.Logowanie(),
        routes: {
          '/logowanie': (context) => logowanie.Logowanie(),
          '/rejestracja': (context) => Rejestracja(),
          '/menu': (context) => menu.Menu(),
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
      resizeToAvoidBottomInset: false,
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
