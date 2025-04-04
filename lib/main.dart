import 'package:english_words/english_words.dart';
import 'package:firststep/providers/animationsProvider.dart';
import 'package:firststep/test.dart';
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
        // Ekran startowy
        home: Logowanie(),
        routes: {
          '/logowanie': (context) => Logowanie(),
          '/rejestracja': (context) => Rejestracja(),
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'FirstStep',
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//           scaffoldBackgroundColor: Color(0xFF1E1E1E),
//         ),
//         // Ekran startowy
//         home: Logowanie(),
//         routes: {
//           '/logowanie': (context) => Logowanie(),
//           '/rejestracja': (context) => Rejestracja(),
//         },
//       ),
//     );
//   }
// }

// class MyAppState extends ChangeNotifier {
//   var current = WordPair.random();
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Column(
//         children: [
//           Text(appState.current.asLowerCase),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pushNamed(context, '/logowanie');
//             },
//             child: Text('Logowanie'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pushNamed(context, '/rejestracja');
//             },
//             child: Text('Rejestracja'),
//           ),
//         ],
//       ),
//     );
//   }
// }
