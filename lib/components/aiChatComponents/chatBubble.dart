import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({super.key, required this.text, required this.isUser});

  final String? text;
  final bool isUser;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:
            widget.isUser
                ? Colors.grey[800]?.withOpacity(
                  0.5,
                ) // Zmieniono na biały przeźroczysty
                : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        widget.text ?? "",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
