import 'dart:convert';

import 'package:firststep/components/aiChatComponents/chatBubble.dart';
import 'package:firststep/components/aiChatComponents/clearChatAlert.dart';
import 'package:firststep/providers/animationsProvider.dart';
import 'package:firststep/providers/stepusChatProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';

class Stepus extends ChangeNotifier {
  List<Map<String, String>> chatHistory = [];
  String state = "idle";
  SMITrigger? _hit;
  SMITrigger? _unhit;
  SMITrigger? _eureka;
  SMIBool? _think;

  void clearChatHistory() {
    chatHistory = [];
    notifyListeners();
  }

  void hit() {
    _hit?.fire();
    notifyListeners();
  }

  void unhit() {
    _unhit?.fire();
    notifyListeners();
  }

  void eureka() {
    _eureka?.fire();
    notifyListeners();
  }

  void think() {
    _think?.change(!_think!.value);
    notifyListeners();
  }

  void addMessages(String message) {
    chatHistory.add({"role": "user", "content": message});
    notifyListeners();
  }

  void updateMessages(String message, int index) {
    chatHistory[index] = {"role": "assistant", "content": message};

    notifyListeners();
  }

  // List<Map<String, String>> getChatHistory() {
  //   _hit?.fire();

  //   return chatHistory;
  // }

  // void showMessage() {
  //   debugPrint(chatHistory.toString());
  // }

  Future<void> sendMessage(String message) async {
    chatHistory.add({"role": "user", "content": message});
    notifyListeners(); // Powiadomienie tylko raz na początku

    think();
    int lastIndex = chatHistory.length;

    final String messageJson = jsonEncode({"messages": chatHistory});

    final url = Uri.parse('http://10.0.2.2:3000/ai/ask');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: messageJson,
    );

    if (response.statusCode != 200) {
      debugPrint("Error: ${response.statusCode}");
      think();
      return;
    }

    eureka();
    final Map<String, dynamic> responseMap = jsonDecode(response.body);
    final String rawMessages = responseMap["message"];
    final List<String> messageChunks =
        rawMessages.split('\n').where((chunk) => chunk.isNotEmpty).toList();

    chatHistory.add({"role": "assistant", "content": ""});

    String fullMessage = '';
    for (final chunk in messageChunks) {
      final Map<String, dynamic> chunkMap = jsonDecode(chunk);
      fullMessage += chunkMap["message"]["content"];
      await Future.delayed(const Duration(milliseconds: 300));
      updateMessages(fullMessage, lastIndex);
    }
    eureka();

    notifyListeners(); // Powiadomienie tylko raz na końcu
  }
}

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final chatHistory = ref.watch(stepusChatProvider);

        return ListView.builder(
          itemCount: chatHistory.chatHistory.length,
          itemBuilder: (context, index) {
            return Message(id: index);
          },
        );
      },
    );
  }
}

class Message extends ConsumerStatefulWidget {
  final int id; // index in the chat history

  const Message({super.key, required this.id});

  @override
  ConsumerState<Message> createState() => _MessageState();
}

class _MessageState extends ConsumerState<Message> {
  @override
  Widget build(BuildContext context) {
    final role =
        ref.watch(stepusChatProvider.notifier).chatHistory[widget.id]["role"];
    final message =
        ref.watch(stepusChatProvider.notifier).chatHistory[widget
            .id]["content"];
    return Align(
      alignment: role == "user" ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: ChatBubble(text: message, isUser: role == "user"),
      ),
    );
  }
}

class StepusAnimation extends ConsumerStatefulWidget {
  StepusAnimation({super.key});

  @override
  ConsumerState<StepusAnimation> createState() => _StepusAnimationState();
}

class _StepusAnimationState extends ConsumerState<StepusAnimation> {
  RiveFile? riveFile;
  late final animations = ref.read(animationsProvider);

  void _onInit(Artboard artboard) {
    var ctrl = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (ctrl != null) {
      ctrl.isActive = true;
      artboard.addController(ctrl);

      final stepusNotifier = ref.read(stepusChatProvider.notifier);
      stepusNotifier._hit = ctrl.getTriggerInput("hit");
      stepusNotifier._unhit = ctrl.getTriggerInput("unhit");
      stepusNotifier._eureka = ctrl.getTriggerInput("eureka");
      stepusNotifier._think = ctrl.getBoolInput("think");
    } else {
      debugPrint('StateMachineController could not be initialized.');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  final riveFileNotifier = ValueNotifier<RiveFile?>(null);

  Future<void> _loadRiveFile() async {
    riveFileNotifier.value = await animations["stepus"];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RiveFile?>(
      valueListenable: riveFileNotifier,
      builder: (context, riveFile, child) {
        if (riveFile == null) {
          return const Center(
            child: Text(
              'Loading animation...',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            ref.read(stepusChatProvider.notifier).hit();
            Future.microtask(() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ClearChatAlert();
                },
              );
            });
          },
          child: RiveAnimation.direct(
            riveFile,
            alignment: Alignment.center,
            antialiasing: true,
            fit: BoxFit.contain,
            stateMachines: ["State Machine 1"],
            onInit: _onInit,
          ),
        );
      },
    );
  }
}
