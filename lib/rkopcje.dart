import 'package:firststep/rkosymulator_dorosli.dart';
import 'package:firststep/rkosymulator_dziecko.dart';
import 'package:firststep/rkosymulator_niemowle.dart';
import 'package:firststep/zatkanie.dart';
import 'package:firststep/aed_instrukcja.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RkOpcje extends StatelessWidget {
  const RkOpcje({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double fontSize = screenWidth * 0.06;
    double imageHeight = screenHeight * 0.22;
    double verticalSpacing = screenHeight * 0.03;

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            children: [
              SizedBox(height: verticalSpacing),
              Text(
                'Dorośli i starsze dzieci',
                textAlign: TextAlign.center,
                style: GoogleFonts.itim(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RkoSymulatorDorosli(),
                        ),
                      );
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: imageHeight),
                      child: Image.asset(
                        'assets/images/men.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalSpacing),
              Text(
                'Dzieci do 8 roku życia',
                textAlign: TextAlign.center,
                style: GoogleFonts.itim(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RkoSymulatorDziecko(),
                        ),
                      );
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: imageHeight),
                      child: Image.asset(
                        'assets/images/dziecko.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalSpacing),
              Text(
                'Niemowlaki',
                textAlign: TextAlign.center,
                style: GoogleFonts.itim(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: verticalSpacing * 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RkoSymulatorNiemowle(),
                        ),
                      );
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: imageHeight),
                      child: Image.asset(
                        'assets/images/niemowle.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: verticalSpacing),
              Column(
                children: [
                  Text(
                    'Zadławienie',
                    style: GoogleFonts.itim(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: verticalSpacing * 0.3),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ZadlawienieInstrukcja(),
                        ),
                      );
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: imageHeight),
                      child: Image.asset(
                        'assets/images/zadławienie.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.7),
                  Text(
                    'AED',
                    style: GoogleFonts.itim(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: verticalSpacing * 0.3),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AedInstrukcja(),
                        ),
                      );
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: imageHeight),
                      child: Image.asset(
                        'assets/images/aed.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
