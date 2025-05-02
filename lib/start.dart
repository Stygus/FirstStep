import 'package:firststep/logowanie.dart';
import 'package:firststep/menu.dart';
import 'package:firststep/models/user.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:firststep/rko.dart';
import 'package:firststep/routes/stepus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void switchToApp(User user, BuildContext context) async {
  user
      .getToken()
      .then((token) {
        if (int.tryParse(user.id) != -1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Menu()),
          );
          return;
        } else if (token != "") {
          debugPrint('Token: $token');
          user
              .authorize(token)
              .then((user) {
                if (user == null) {
                  debugPrint('Błąd: Autoryzacja nie powiodła się');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Logowanie()),
                  );
                  return;
                }

                debugPrint('User authorized: ${user.nickname}');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Menu()),
                );
              })
              .catchError((error) {
                debugPrint('Błąd podczas autoryzacji: $error');
              });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Logowanie()),
          );
        }
      })
      .catchError((error) {
        debugPrint('Błąd podczas pobierania tokenu: $error');
      });
}

class Start extends ConsumerWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF1E1E1E), // Kolor tła dla start.dart
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Image.asset('assets/images/logod.png', height: 240, width: 240),
          SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RKO(),
                ), // Poprawiono nawigację do RKO
              );
            },
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    'assets/images/rko.png',
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Panel RKO', // Przeniesiono tekst pod zdjęcie
                  style: GoogleFonts.itim(
                    fontSize: 24,
                    fontWeight: FontWeight.values[4],
                    color: Colors.white,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StepusWidget()),
              );
            },

            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    'assets/images/porada.png',
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Szybka Porada',
                  style: GoogleFonts.itim(
                    fontSize: 24,
                    fontWeight: FontWeight.values[4],
                    color: Colors.white,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Logowanie(),
                ), // Przeniesienie do logowania
              );
            },
            child: Column(
              children: [
                Text(
                  'Przejdź do aplikacji',
                  style: GoogleFonts.itim(
                    fontSize: 32,
                    fontWeight: FontWeight.values[3],
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Image.asset(
                  'assets/images/liniaOG.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class testowy extends ConsumerWidget {
//   const testowy({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 50),
//             FilledButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => StepusWidget()),
//                 );
//               },
//               child: Text('Test'),
//             ),
//             SizedBox(height: 50),
//             Container(
//               width: 250,
//               height: 250,
//               child: Stack(
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Transform.rotate(
//                       angle: 45 * math.pi / 180,
//                       child: ClipPath(
//                         child: Container(
//                           width: 100,
//                           height: 100,
//                           color: const Color.fromARGB(
//                             255,
//                             244,
//                             225,
//                             54,
//                           ), // Pierwszy kontener (na spodzie)
//                         ),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: Transform.rotate(
//                       angle: 45 * math.pi / 180,
//                       child: ClipPath(
//                         child: Container(
//                           width: 100,
//                           height: 100,
//                           color: Colors.red, // Pierwszy kontener (na spodzie)
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 50),
//             TextButton(
//               onPressed: () async {
//                 final user = ref.watch(userProvider.notifier);
//                 debugPrint(user.nickname);
//               },
//               child: Text('Testowy przycisk'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
