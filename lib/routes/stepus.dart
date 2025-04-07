import 'package:firststep/components/aiChatComponents/chatPrompter.dart';
import 'package:firststep/models/stepus.dart';
import 'package:firststep/providers/stepusChatProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepusWidget extends ConsumerWidget {
  StepusWidget({super.key});
  TextEditingController? _promptControler = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatHistory = ref.watch(stepusChatProvider.notifier);
    if (chatHistory.isThinking) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0x101010)),
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
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
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      color: Color.fromARGB(255, 78, 77, 77),
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
                  ),
                ),
                SizedBox(height: 5),

                SizedBox(height: 300, child: Chat()),

                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: chatPrompter(controller: _promptControler),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
