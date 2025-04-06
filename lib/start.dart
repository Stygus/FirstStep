import 'dart:math' as math;

import 'package:firststep/components/aiChatComponents/chatPrompter.dart';
import 'package:firststep/logowanie.dart';
import 'package:firststep/menu.dart';
import 'package:firststep/models/stepus.dart';
import 'package:firststep/models/user.dart';
import 'package:firststep/providers/animationsProvider.dart';
import 'package:firststep/providers/stepusChatProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:firststep/routes/stepus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;

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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image.asset('assets/images/logod.png', height: 240, width: 240),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StepusWidget()),
                );
              },
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/images/rko.png',
                  width: double.infinity,
                  height: 120,

                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                switchToApp(user, context);
              },
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/images/porada.png',
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  switchToApp(user, context);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/linia5.png',
                      width: double.infinity,
                      height: 120,

                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Text(
                          'Przejdź do aplikacji',
                          style: GoogleFonts.itim(
                            fontSize: 32,
                            fontWeight: FontWeight.values[3],
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
