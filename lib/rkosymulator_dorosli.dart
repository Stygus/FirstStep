import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'testy.dart';
import 'menu.dart'; // Dodaj import menu jeśli jeszcze nie ma

class RkoSymulatorDorosli extends StatefulWidget {
  const RkoSymulatorDorosli({super.key});

  @override
  State<RkoSymulatorDorosli> createState() => _RkoSymulatorDorosliState();
}

class _RkoSymulatorDorosliState extends State<RkoSymulatorDorosli> {
  int currentStep = 0;
  bool showBreathChoice = false;
  bool showRecoverySteps = false;
  int recoveryStep = 0;

  final List<Map<String, dynamic>> steps = [
    {
      'text':
          'Zadbaj o swoje bezpieczeństwo! Rozejrzyj się czy nic ci nie zagraża. Oceń czy otoczenie pozwala ci na podjęcie się pierwszej pomocy.',
      'image': 'assets/images/rd1.png',
      'tip':
          'Twoje bezpieczeństwo jest najważniejsze! Różne czynniki mogą wpłynąć na to czy możesz działać np: (pożar, niebezpieczne zwierzęta,słaba widoczność na ulicy).',
    },
    {
      'text':
          'Sprawdź przytomność – potrząśnij delikatnie, zapytaj: „Czy wszystko w porządku?”',
      'image': 'assets/images/rd2.png',
      'tip': 'Brak reakcji będzie wskazywał na utratę przytomności.',
    },
    {
      'text':
          'Zawołaj pomoc – jeśli poszkodowany nie reaguje, zawołaj głośno o pomoc.',
      'image': 'assets/images/rd3.png',
      'tip':
          'Większa ilość ratowników to znaczące wsparcie. Mogą pomóc w wezwaniu karetki oraz zmienić się w trakcie masażu serca.',
    },
    {
      'text':
          'Sprawdź oddech – odchyl głowę, sprawdź, czy oddycha: „patrz, słuchaj, czuj” przez 10 sekund.',
      'image': 'assets/images/rd4.png',
      'tip':
          'Nie spiesz się z oceną. Upewnij się że nie czujesz oddechu na policzku,klatka nie porusza się, niesłyszysz oddechu w takim wypadku przejdź dalej.',
    },
    {
      'text': 'Wezwij pomoc – zadzwoń pod 112 i opisz sytuację',
      'image': 'assets/images/rd5.png',
      'tip':
          'Spokojnie i wyraźnie podaj dokładną lokalizację i opisz sytuację. Nie rozłączaj się dopóki dyspozytor nie powie, że możesz.',
    },
    {
      'text':
          'Rozpocznij uciski klatki piersiowej:\n- Ułóż dłonie jedna na drugiej, na środku klatki piersiowej na lini sutków.\n- Ręce wyprostowane, uciskaj 5–6 cm głęboko.\n- Częstotliwość: 100–120/min.',
      'image': 'assets/images/rd6.png',
      'tip': 'Uciskaj mocno i szybko, nie bój się złamać żeber.',
    },
    {
      'text':
          'Po 30 uciśnięciach wykonaj 2 oddechy ratownicze (jeśli się na to zdecydujesz):\n- Zatkaj nos, odchyl głowę, zakryj usta swoimi ustami, dmuchnij normalnie 2 razy.',
      'image': 'assets/images/rd7.png',
      'tip':
          'Jeśli nie chcesz wykonywać oddechów – kontynuuj same uciski. Nie rób przerwy dłuższej niż 10 sekund podczas wdechami/zmianą uciskania.',
    },
    {
      'text': 'Kontynuuj 30:2 aż do przybycia pomocy lub powrotu oddechu.',
      'image': 'assets/images/rd8.png',
      'tip':
          'Nie przerywaj RKO do momentu przyjazdu karetki/lub do momentu braku sił i braku możliwości zmiany z inną osobą!',
    },
    {
      'text':
          'Pomoc zakończona!\n\n To, co zrobiłeś, naprawdę ma znaczenie. Dzięki twoim działaniom poszkodowany mógł dostać drugą szansę.   To dzięki takim ludziom jak Ty świat jest bezpieczniejszy!',
      'image': 'assets/images/rd9.png',
      'tip':
          'Pamiętaj: nie przerywaj RKO, dopóki nie przyjedzie pomoc lub poszkodowany nie zacznie oddychać.',
    },
  ];

  final List<Map<String, dynamic>> recoverySteps = [
    {
      'text': 'Wezwij pomoc – zadzwoń pod 112 i opisz sytuację .',
      'image': 'assets/images/rd5.png',
      'tip':
          'Spokojnie i wyraźnie podaj dokładną lokalizację i opisz sytuację. Nie rozłączaj się dopóki dyspozytor nie powie, że możesz.',
    },
    {
      'text': 'Ułóż poszkodowanego w pozycji bocznej bezpiecznej.',
      'image': 'assets/images/rdb.png',
      'tip':
          'Pozycja boczna chroni przed zadławieniem i umożliwia swobodne oddychanie. Instrukcja w następnym kroku.',
    },
    {
      'text': 'Jak ułożyć poszkodowanego w pozycji bocznej bezpiecznej?',
      'image': null,
      'tip': null,
      'steps': [
        'Ułóż poszkodowanego na boku.',
        'Połóż rękę bliższą Tobie pod kątem prostym względem tułowia (łokieć zgięty).',
        'Drugą rękę złóż na przeciwległym policzku.',
        'Zegnij bliższą Tobie nogę w kolanie.',
        'Chwyć za zgięte kolano i bark, obróć delikatnie poszkodowanego na bok, tak żeby noga opierała się o podłoże, a głowa była lekko odchylona do tyłu.',
        'Utrzymaj drożność dróg oddechowych: upewnij się, że żadne ciało obce nie blokuje ust czy gardła, i że głowa jest lekko odchylona, by ułatwić oddychanie.',
      ],
    },
    {
      'text': 'Kontroluj oddech do przyjazdu pomocy.',
      'image': 'assets/images/rd4.png',
      'tip':
          'Jeśli oddech się pogorszy lub ustanie – rozpocznij masaż serca oraz wdechy 30:2 do przyjazdu karetki lub odzyskania oddechu.',
    },
    {
      'text':
          'Pomoc zakończona!\n\n To, co zrobiłeś, naprawdę ma znaczenie. Dzięki twoim działaniom poszkodowany mógł dostać drugą szansę. To dzięki takim ludziom jak Ty świat jest bezpieczniejszy!',
      'image': 'assets/images/rd9.png',
      'tip':
          'Pamiętaj: nie przerywaj RKO, dopóki nie przyjedzie pomoc lub poszkodowany nie zacznie oddychać.',
    },
  ];

  void nextStep() {
    if (showBreathChoice) return;
    if (showRecoverySteps) {
      if (recoveryStep < recoverySteps.length - 1) {
        setState(() {
          recoveryStep++;
        });
      }
      return;
    }
    if (currentStep == 3) {
      setState(() {
        showBreathChoice = true;
      });
      return;
    }
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (showRecoverySteps) {
      if (recoveryStep > 0) {
        setState(() {
          recoveryStep--;
        });
      }
      return;
    }
    if (showBreathChoice) {
      setState(() {
        showBreathChoice = false;
      });
      return;
    }
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void restart() {
    setState(() {
      currentStep = 0;
      showBreathChoice = false;
      showRecoverySteps = false;
      recoveryStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Widget stepWidget(Map<String, dynamic> step, int stepNum, int totalSteps) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Krok $stepNum z $totalSteps',
            style: const TextStyle(color: Colors.white70, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (step['image'] != null)
            Image.asset(step['image'], height: 200, fit: BoxFit.contain),
          if (step['image'] != null) const SizedBox(height: 24),
          Text(
            step['text'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (step['steps'] != null) ...[
            const SizedBox(height: 18),
            ...List.generate(
              (step['steps'] as List).length,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}. ',
                      style: const TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        step['steps'][i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (step['tip'] != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info,
                    color: Colors.lightBlueAccent,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      step['tip'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
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
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TestyPage()),
              (route) => false,
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFF101010),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.1,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.001),
                    child: Text(
                      'Symulator RKO – Dorośli',
                      style: GoogleFonts.itim(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: screenWidth * 0.1875,
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
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.06),
                child: Builder(
                  builder: (context) {
                    if (showBreathChoice) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Oceń stan poszkodowanego.\n Czy jest przytomny? Czy oddycha?',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text(
                              'Nieprzytomny oddycha ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                showBreathChoice = false;
                                showRecoverySteps = true;
                                recoveryStep = 0;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text(
                              'Nieprzytonmy nie oddycha',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                showBreathChoice = false;
                                currentStep++;
                              });
                            },
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: previousStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Wstecz',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (showRecoverySteps) {
                      final step = recoverySteps[recoveryStep];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          stepWidget(
                            step,
                            recoveryStep + 1,
                            recoverySteps.length,
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (recoveryStep > 0)
                                ElevatedButton(
                                  onPressed: previousStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Wstecz',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              if (recoveryStep > 0) const SizedBox(width: 16),
                              if (recoveryStep < recoverySteps.length - 1)
                                ElevatedButton(
                                  onPressed: nextStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Dalej',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              if (recoveryStep == recoverySteps.length - 1) ...[
                                ElevatedButton(
                                  onPressed: restart,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontSize: 18,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Menu',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          stepWidget(
                            steps[currentStep],
                            currentStep + 1,
                            steps.length,
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (currentStep > 0)
                                ElevatedButton(
                                  onPressed: previousStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Wstecz',
                                    style: TextStyle(
                                      fontSize: 16,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Dalej',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              if (currentStep == steps.length - 1) ...[
                                ElevatedButton(
                                  onPressed: restart,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(
                                      fontSize: 18,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Menu',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
