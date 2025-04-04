import 'dart:math' as math;

import 'package:firststep/components/aiChatComponents/chatPrompter.dart';
import 'package:firststep/models/stepus.dart';
import 'package:firststep/providers/animationsProvider.dart';
import 'package:firststep/providers/stepusChatProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class stepusTest extends ConsumerWidget {
  TextEditingController? _promptControler = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
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
                    child: StepusAnimation(),
                  ),
                ),
                SizedBox(height: 10),

                SizedBox(height: 400, child: Chat()),

                chatPrompter(controller: _promptControler),
              ],
            ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
