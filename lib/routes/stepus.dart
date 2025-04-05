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
        title: const Text('Stepus'),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
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
    );
    ;
  }
}
