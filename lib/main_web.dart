import 'package:firststep/providers/userProvider.dart';
import 'package:firststep/webApp/welcome.dart';
import 'package:firststep/models/user.dart';
import 'package:flutter/material.dart';
import 'package:firststep/webApp/appPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  initializeHttpClient();

  // Tworzymy stałe style do użycia w QuillEditor
  final customTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),

    textTheme: const TextTheme(
      // Definiujemy style tekstu, które będą później używane przez DefaultStyles.getInstance()
      displayLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ), // h1
      displayMedium: TextStyle(
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ), // h2
      displaySmall: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ), // h3
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white), // paragraph
      bodyMedium: TextStyle(
        fontSize: 14.0,
        fontFamily: 'monospace',
        color: Color(0xFFABFFAB),
      ), //
      titleLarge: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ), // title
    ),
    // Inne elementy motywu
    // ...
  );

  runApp(
    UncontrolledProviderScope(
      container: ProviderContainer(),
      child: MaterialApp(
        title: 'FirstStep Web',
        theme: customTheme,
        localizationsDelegates: [
          FlutterQuillLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pl'), // Polski
          Locale('en'), // Angielski
        ],
        home: WebHome(),
      ),
    ),
  );
}

final loginProvider = StateProvider<bool>((ref) => true);

class WebHome extends ConsumerStatefulWidget {
  const WebHome({super.key});

  @override
  ConsumerState<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends ConsumerState<WebHome> {
  @override
  void initState() {
    super.initState();
    // Dodanie callbacka, który zostanie wywołany po pierwszym wyrenderowaniu ramki
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userDetected();
    });
  }

  void userDetected() async {
    debugPrint('Wykryto użytkownika');
    final user = ref.watch(userProvider);
    user.getToken().then((token) {
      if (token != null) {
        user.authorize(token).then((userr) {
          if (userr != null) {
            user.setUser(userr);
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    backgroundColor: Color.fromARGB(255, 26, 26, 26),
                    title: Text(
                      'Wykryto logowanie',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Text(
                            'Czy chcesz przejść do panelu administracyjnego\n zalogowany jako: ',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            user.nickname,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          user.signOut();
                        },

                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            19,
                            255,
                            255,
                            255,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ).copyWith(
                          overlayColor: WidgetStateProperty.all(
                            const Color.fromARGB(19, 255, 0, 0),
                          ),
                        ),

                        child: Text(
                          'Wyloguj',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => AppPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            19,
                            255,
                            255,
                            255,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ).copyWith(
                          overlayColor: WidgetStateProperty.all(
                            const Color.fromARGB(19, 255, 0, 0),
                          ),
                        ),
                        child: Text(
                          'Zaloguj',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
            );
          } else {
            debugPrint('Nie można zalogować użytkownika');
          }
        });
      } else {
        debugPrint('Brak tokena użytkownika');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 16, 16),
      appBar: AppBar(
        title: Text(
          'Panel Administracyjny',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: Image.asset('assets/images/logoBig.png'),
            ),
            SizedBox(width: 100),
            Flexible(child: login ? Logowanie() : Rejestracja()),
          ],
        ),
      ),
    );
  }
}
