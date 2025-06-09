import 'package:firststep/components/aiChatComponents/chatPrompter.dart';
import 'package:firststep/models/stepus.dart';
import 'package:firststep/providers/stepusChatProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepusWidget extends ConsumerWidget {
  StepusWidget({super.key});
  final TextEditingController _promptControler = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatHistory = ref.watch(stepusChatProvider.notifier);

    // Auto scroll gdy AI myśli
    if (chatHistory.isThinking && _scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0x00101010)),
        title: const Text(
          'Stepus',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color(0xFF101010),
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF550000),
              Color(0xFF8B0000),
              Color(0xFF5C0000),
              Color(0xFF580000),
              Color(0xFF000000),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            final isKeyboardOpen = keyboardHeight > 0;

            // Minimalna wysokość dla animacji (nieco mniejsza gdy klawiatura otwarta)
            final minAnimationHeight = isKeyboardOpen ? 120.0 : 200.0;
            final maxAnimationHeight = MediaQuery.of(context).size.width * 0.6;
            final animationHeight = maxAnimationHeight.clamp(
              minAnimationHeight,
              maxAnimationHeight,
            );

            return Column(
              children: [
                // Animacja Stepusa - zawsze widoczna z minimalną wysokością
                Container(
                  height: animationHeight,
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        color: Color.fromARGB(255, 78, 77, 77),
                        child: SizedBox(
                          width: animationHeight - 30, // minus padding
                          height: animationHeight - 30,
                          child: StepusAnimation(),
                        ),
                      ),
                    ),
                  ),
                ),
                // Chat - elastyczna wysokość
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chat(scrollController: _scrollController),
                  ),
                ),

                // Prompter - zawsze widoczny na dole
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 14.0,
                      right: 14.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: chatPrompter(controller: _promptControler),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
