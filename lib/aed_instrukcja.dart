import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'menu.dart';

class AedInstrukcja extends StatefulWidget {
  const AedInstrukcja({super.key});

  @override
  State<AedInstrukcja> createState() => _AedInstrukcjaState();
}

class _AedInstrukcjaState extends State<AedInstrukcja> {
  int currentStep = 0;

  final List<Map<String, dynamic>> steps = [
    {
      'title': 'Krok 1',
      'text': 'Włącz urządzenie AED.',
      'image': 'assets/images/aed1.png',
      'tip': 'Otwórz pokrywę lub naciśnij przycisk „ON” lub „POWER”.',
    },
    {
      'title': 'Krok 2',
      'text': 'Odsłoń klatkę piersiową poszkodowanego.',
      'image': 'assets/images/aed2.png',
      'tip': 'Usuń odzież, biżuterię i osusz skórę jeśli trzeba.',
    },
    {
      'title': 'Krok 3',
      'text': 'Przyklej elektrody AED.',
      'image': 'assets/images/aed5.png',
      'tip': 'Jedna elektroda pod prawym obojczykiem, druga pod lewą piersią.',
    },
    {
      'title': 'Krok 4',
      'text': 'Pozwól AED przeanalizować rytm serca.',
      'image': 'assets/images/aed4.png',
      'tip': 'Nikt nie powinien dotykać poszkodowanego podczas analizy.',
    },
    {
      'title': 'Krok 5',
      'text': 'Wykonaj defibrylację jeśli AED zaleci.',
      'image': 'assets/images/aed3.png',
      'tip':
          'Odsuń się i naciśnij „SHOCK” lub poczekaj na automatyczny wstrząs.',
    },
    {
      'title': 'Krok 6',
      'text': 'Kontynuuj RKO zgodnie z poleceniami AED.',
      'image': 'assets/images/aed6.png',
      'tip': 'Wykonuj 30 uciśnięć klatki piersiowej i 2 oddechy ratownicze.',
    },
    {
      'title': 'Koniec',
      'text': 'To już wszystkie kroki instrukcji edukacyjnej dotyczącej AED.',
      'image': 'assets/images/rd9.png',
      'tip': 'Możesz powtórzyć instrukcję lub wrócić do menu.',
    },
  ];

  void nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void restart() {
    setState(() {
      currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[currentStep];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double baseFont = screenWidth * 0.045;
    double headerFont = screenWidth * 0.055;
    double stepFont = screenWidth * 0.042;
    double buttonFont = screenWidth * 0.045;
    double imageHeight = screenHeight * 0.28;

    Widget stepWidget(Map<String, dynamic> step, int stepNum, int totalSteps) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            step['title'] ?? 'Krok $stepNum z $totalSteps',
            style: TextStyle(
              color: Colors.white70,
              fontSize: baseFont,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.012),
          if (step['image'] != null)
            Image.asset(
              step['image'],
              height: imageHeight,
              fit: BoxFit.contain,
            ),
          if (step['image'] != null) SizedBox(height: screenHeight * 0.018),
          Text(
            step['text'] ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: headerFont,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (step['tip'] != null) ...[
            SizedBox(height: screenHeight * 0.012),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.025),
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.lightBlueAccent,
                    size: baseFont + 2,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      step['tip'],
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: stepFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF101010),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.13,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: screenWidth * 0.17,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.bottomCenter,
                        image: AssetImage('assets/images/linia.png'),
                        fit: BoxFit.fill,
                        isAntiAlias: false,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.032),
                    child: Text(
                      'AED – instrukcja krok po kroku',
                      style: GoogleFonts.itim(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screenHeight * 0.78),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        stepWidget(step, currentStep + 1, steps.length),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (currentStep > 0)
                              ElevatedButton(
                                onPressed: previousStep,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.07,
                                    vertical: screenHeight * 0.018,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Wstecz',
                                  style: TextStyle(
                                    fontSize: buttonFont * 0.9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            if (currentStep > 0) const SizedBox(width: 16),
                            if (currentStep < steps.length - 1)
                              ElevatedButton(
                                onPressed: nextStep,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.09,
                                    vertical: screenHeight * 0.022,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Dalej',
                                  style: TextStyle(
                                    fontSize: buttonFont,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            if (currentStep == steps.length - 1) ...[
                              ElevatedButton(
                                onPressed: restart,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.07,
                                    vertical: screenHeight * 0.016,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: buttonFont * 0.9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Menu(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.07,
                                    vertical: screenHeight * 0.016,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Menu',
                                  style: TextStyle(
                                    fontSize: buttonFont * 0.9,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
