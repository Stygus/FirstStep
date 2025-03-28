import 'dart:convert';

import 'package:firststep/providers/stepusChatProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Stepus extends ChangeNotifier {
  List<Map<String, String>> chatHistory = [];

  void clearChatHistory() {
    chatHistory = [];
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

  List<Map<String, String>> getChatHistory() {
    return chatHistory;
  }

  void showMessage() {
    debugPrint(chatHistory.toString());
  }

  Future<void> sendMessage(String message) async {
    chatHistory.add({"role": "user", "content": message});
    notifyListeners();
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
      return;
    }

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

    debugPrint(chatHistory.toString());

    notifyListeners();
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
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: role == "user" ? Colors.blue : Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message ?? "",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
