import 'dart:math' as math;

import 'package:firststep/models/stepus.dart';
import 'package:firststep/providers/animationsProvider.dart';
import 'package:firststep/providers/stepusChatProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class stepusTest extends ConsumerStatefulWidget {
  const stepusTest({super.key, final riveFile});

  @override
  ConsumerState<stepusTest> createState() => _stepusTestState();
}

class _stepusTestState extends ConsumerState<stepusTest> {
  RiveFile? riveFile;
  late final animations = ref.read(animationsProvider);
  TextEditingController? _promptControler = TextEditingController();

  StateMachineController? _controller;
  SMITrigger? _hit;
  SMITrigger? _unhit;
  SMITrigger? _eureka;
  SMIBool? _think;

  void _onInit(Artboard artboard) {
    var ctrl = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (ctrl != null) {
      ctrl.isActive = true;
      artboard.addController(ctrl);
      _hit = ctrl.getTriggerInput("hit");
      _controller = ctrl;
      _unhit = ctrl.getTriggerInput("unhit");
      _eureka = ctrl.getTriggerInput("eureka");
      _think = ctrl.getBoolInput("think");
    } else {
      debugPrint('StateMachineController could not be initialized.');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    riveFile = await animations["stepus"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final chatHistory = ref.watch(stepusChatProvider.notifier);

    return MaterialApp(
      title: 'FirstStep',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        scaffoldBackgroundColor: Color(0xFF1E1E1E),
      ),
      // Ekran startowy
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Container(
                color: Color.fromARGB(59, 147, 230, 255),
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width *
                      0.6, // 80% of screen width
                  height:
                      MediaQuery.of(context).size.width *
                      0.6, // 80% of screen height
                  // child:
                  //     riveFile != null
                  //         ? RiveAnimation.direct(
                  //           riveFile!,
                  //           antialiasing: false,
                  //           fit: BoxFit.contain,
                  //           stateMachines: ["State Machine 1"],
                  //           onInit: _onInit,
                  //           controllers:
                  //               _controller != null ? [_controller!] : [],
                  //         )
                  //         : const Center(
                  //           child: Text(
                  //             'Loading animation...',
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         ),
                ),
              ),
              SizedBox(height: 50),

              // Row(
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         _hit?.fire();
              //       },
              //       child: Text('Hit'),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         _unhit?.fire();
              //       },
              //       child: Text('Unhit'),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         _eureka?.fire();
              //       },
              //       child: Text('Eureka'),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         _think?.value = !_think!.value;
              //       },
              //       child: Text('Think'),
              //     ),
              //   ],
              // ),
              ElevatedButton(
                onPressed: () {
                  if (_promptControler!.text != "") {
                    chatHistory.sendMessage(_promptControler!.text);
                    _promptControler!.clear();
                  }
                },
                child: Text('Wyślij wiadomość'),
              ),
              ElevatedButton(
                onPressed: () {
                  chatHistory.clearChatHistory();
                },
                child: Text('Clear'),
              ),
              ElevatedButton(
                onPressed: () {
                  chatHistory.showMessage();
                },
                child: Text('Show Message'),
              ),
              Container(
                height: 400,
                child: Consumer(
                  builder: (context, ref, child) {
                    final chatHistory = ref.watch(stepusChatProvider);

                    return ListView.builder(
                      itemCount: chatHistory.chatHistory.length,
                      itemBuilder: (context, index) {
                        return Message(id: index);
                      },
                    );
                  },
                ),
              ),
              TextField(
                controller: _promptControler,
                decoration: InputDecoration(
                  hintText: 'Wpisz wiadomość',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class testowy extends StatelessWidget {
  const testowy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => stepusTest()),
                );
              },
              child: Text('Test'),
            ),
            SizedBox(height: 50),
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
                    child: Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: ClipPath(
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.red, // Pierwszy kontener (na spodzie)
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.green, // Drugi kontener (na środku)
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
                        color: Colors.blue, // Trzeci kontener (na wierzchu)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
