import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;
import 'dart:math' as math;

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menu główne',
              style: GoogleFonts.roboto(
                fontSize: 32,
                fontWeight: FontWeight.values[3],
                color: Colors.white,
                height: 1,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF101010),
      ),
      backgroundColor: Color(0xFF101010),
      body: Column(
        children: [
          SizedBox(
            height: 80, // Define a fixed height
            child: rive.RiveAnimation.asset(
              'assets/Animacje/neonowy_puls.riv',
              fit: BoxFit.scaleDown,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Już wkrótce!',
                    style: GoogleFonts.roboto(
                      fontSize: 32,
                      fontWeight: FontWeight.values[3],
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/images/logod.png',
                    height: 180,
                    width: 180,
                  ),
                  SizedBox(height: 20),

                  // Tytuł aplikacji
                  Container(
                    width: 250,
                    height: 250,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Transform.rotate(
                            angle: 45 * math.pi / 180,
                            child: ClipPath(
                              child: Container(
                                width: 100,
                                height: 100,
                                color: const Color.fromARGB(
                                  255,
                                  244,
                                  225,
                                  54,
                                ), // Pierwszy kontener (na spodzie)
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: ClipPath(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/rkob.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipPath(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double size =
                                    constraints.maxWidth *
                                    0.5; // Increased size to 50% of parent width
                                return Container(
                                  width: size,
                                  height: size,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/poradab.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Transform.rotate(
                            angle: 45 * math.pi / 180,
                            child: Container(
                              width: 100,
                              height: 100,
                              color:
                                  Colors.blue, // Trzeci kontener (na wierzchu)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
