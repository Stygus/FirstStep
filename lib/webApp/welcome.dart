import 'package:firststep/main_web.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:firststep/webApp/appPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Logowanie extends ConsumerWidget {
  const Logowanie({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final passwordController = TextEditingController();
    final emailController = TextEditingController();

    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Color.fromARGB(100, 26, 26, 26),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Logowanie',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Hasło',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final status = await user.signIn(
                    emailController.text,
                    passwordController.text,
                    context,
                  );
                  debugPrint(status.toString());
                  debugPrint(user.role.toString());
                  if (user.role == 'TEACHER' || user.role == 'ADMIN') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AppPage()),
                    );
                  } else {
                    user.signOut();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Nie masz uprawnień')),
                    );
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Poziomy prostokąt plusa
                    Container(
                      width: 110,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    // Pionowy prostokąt plusa
                    Container(
                      width: 50,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    // Tekst na przycisku
                    Text(
                      'Zaloguj',
                      style: GoogleFonts.itim(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                debugPrint("Rejestracja");
                ref.read(loginProvider.notifier).state = false;
              },
              child: Text(
                'Nie masz konta? Zarejestruj się',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Rejestracja extends ConsumerWidget {
  const Rejestracja({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final passwordController = TextEditingController();
    final emailController = TextEditingController();

    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Color.fromARGB(100, 26, 26, 26),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              'Rejestracja',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Hasło',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  user.signIn(
                    emailController.text,
                    passwordController.text,
                    context,
                  );
                  debugPrint(user.email);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Poziomy prostokąt plusa
                    Container(
                      width: 110,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    // Pionowy prostokąt plusa
                    Container(
                      width: 50,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    // Tekst na przycisku
                    Text(
                      'Zarejestruj',
                      style: GoogleFonts.itim(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                debugPrint("Rejestracja");
                ref.read(loginProvider.notifier).state = true;
              },
              child: Text(
                'Nie masz konta? Zarejestruj się',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
