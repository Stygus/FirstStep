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
            height: 80,
            child: rive.RiveAnimation.asset(
              'assets/Animacje/neonowy_puls.riv',
              fit: BoxFit.scaleDown,
            ),
          ),
          Center(
            child: SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: 3,
                controller: PageController(viewportFraction: 1.0),
                itemBuilder: (context, index) {
                  String imagePath = 'assets/images/add${index + 1}.png';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/add1.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Padding(
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

                SizedBox(height: 20),

                Container(
                  width: 250,
                  height: 250,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClipPath(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double size = constraints.maxWidth * 0.6;
                              return Container(
                                width: size,
                                height: size,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/apteka.png',
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
                        alignment: Alignment.topCenter,
                        child: ClipPath(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double size = constraints.maxWidth * 0.6;
                              return Container(
                                width: size,
                                height: size,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/rkob.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
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
                                  0.6; // Increased size to 50% of parent width
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
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double size =
                                constraints.maxWidth *
                                0.6; // Set size relative to parent width
                            return Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/kursy.png', // Replace with your image path
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
