import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'menu.dart';

class ZadlawienieInstrukcja extends StatefulWidget {
  const ZadlawienieInstrukcja({super.key});

  @override
  State<ZadlawienieInstrukcja> createState() => _ZadlawienieInstrukcjaState();
}

class _ZadlawienieInstrukcjaState extends State<ZadlawienieInstrukcja> {
  int currentStep = 0;

  final List<Map<String, dynamic>> steps = [
    {
      'title':
          'Zadławienie niemowlęcia możesz przewinąć kroki jeśli potrzebujesz instrukcji o zadławieniu dorosłych',
      'text': 'Postepowanie w przypadku zadławienia niemowlęcia.',
      'image': 'assets/images/niemow0.png',
    },
    {
      'title': 'Krok 1',
      'text':
          'Sprawdź, czy niemowlę się dławi – jeśli nie może oddychać, kaszleć lub wydawać dźwięków, natychmiast wezwij pomoc i rozpocznij działania.',
      'image': 'assets/images/niemow1.png',
      'tip':
          'Zwróć uwagę na objawy zadławienia: trudności w oddychaniu, sinica, brak płaczu.',
    },

    {
      'title': 'Krok 2',
      'text':
          'Ułóż niemowlę na brzuchu na swoim przedramieniu, głową w dół, i wykonaj 5 energicznych uderzeń w plecy między łopatkami otwartą dłonią.',
      'image': 'assets/images/niemow2.png',
      'tip': 'Podtrzymuj głowę niemowlęcia i trzymaj ją niżej niż tułów.',
    },

    {
      'title': 'Krok 3',
      'text':
          'Odwróć niemowlę na plecy i wykonaj 5 uciśnięć klatki piersiowej dwoma palcami – jak przy resuscytacji.',
      'image': 'assets/images/niemow3.png',
      'tip':
          'Uciskaj dolną połowę mostka, zachowując rytm i głębokość odpowiednią dla niemowlęcia.',
    },

    {
      'title': 'Krok 4',
      'text':
          'Kontynuuj naprzemiennie 5 uderzeń w plecy i 5 uciśnięć klatki piersiowej do momentu usunięcia przeszkody lub utraty przytomności.',
      'image': 'assets/images/niemow4.png',
      'tip':
          'Nie wkładaj palców do ust niemowlęcia na ślepo – możesz wepchnąć ciało obce głębiej.',
    },

    {
      'title': 'Krok 5',
      'text':
          'Jeśli niemowlę straci przytomność, rozpocznij resuscytację krążeniowo-oddechową.',
      'image': 'assets/images/niemow5.png',
      'tip':
          'Wykonuj 30 uciśnięć klatki piersiowej i 2 oddechy ratownicze, dostosowane do wieku dziecka czyli uciśnięcia 2 palcami.',
    },

    {
      'title': 'Koniec',
      'text':
          'To już wszystkie kroki instrukcji dotyczącej postępowania w przypadku zadławienia u niemowlęcia. Kliknij dalej by przejść do dorosłych .',
      'image': 'assets/images/rd9.png',
      'tip':
          'Powtarzaj czynności ratowniczę do skutku lub przyjazdu karetki.  Kliknij dalej by przejść do dorosłych',
    },
    {
      'title': 'Krok 1',
      'text':
          'Sprawdź, czy osoba się dławi i jeśli tak wołaj o pomoc i zacznij działać.',
      'image': 'assets/images/zadławienie1.png',
      'tip':
          'Zwróć uwagę na objawy zadławienia: trudności w oddychaniu, sinica',
    },

    {
      'title': 'Krok 2',
      'text': 'Zachęcaj do kaszlu, jeśli osoba jest przytomna.',
      'image': 'assets/images/zadławienie2.png',
      'tip': 'Kaszel może pomóc usunąć przeszkodę.',
    },
    {
      'title': 'Krok 3',
      'text': 'Wykonaj 5 uderzeń w plecy między łopatkami.',
      'image': 'assets/images/zadławienie3.png',
      'tip': 'Stań z boku lub z tyłu osoby i pochyl ją lekko do przodu.',
    },
    {
      'title': 'Krok 4',
      'text': 'Wykonaj 5 ucisków nadbrzusza (manewr Heimlicha).',
      'image': 'assets/images/zadławienie4a.png',
      'tip':
          'Obejmij osobę powyżej pępka i wykonaj uciski do siebie i ku górze.',
    },
    {
      'title': 'Krok 5',
      'text': 'Powtarzaj naprzemiennie uderzenia w plecy i uciski nadbrzusza.',
      'image': 'assets/images/zadławienie4.png',
      'tip':
          'Kontynuuj do momentu usunięcia przeszkody lub utraty przytomności.',
    },
    {
      'title': 'Krok 6',
      'text': 'Jeśli osoba straci przytomność, rozpocznij RKO.',
      'image': 'assets/images/zadławienie5.png',
      'tip': 'Wykonuj 30 uciśnięć klatki piersiowej i 2 oddechy ratownicze.',
    },
    {
      'title': 'Koniec dla dorosłych',
      'text':
          'To już wszystkie kroki instrukcji dotyczącej postępowania w przypadku zadławienia dorosłych.',
      'image': 'assets/images/rd9.png',
      'tip': 'Powtarzaj czynności ratowniczę do skutku lub przyjazdu karetki.',
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
                      'Zadławienie',
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
