import 'package:firststep/providers/stepusChatProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClearChatAlert extends ConsumerWidget {
  const ClearChatAlert({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("Alert"),
      content: const Text("Czy na pewno chcesz usunąć całą historię czatu?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(stepusChatProvider.notifier).unhit();
          },
          child: const Text("Anuluj"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Clear the chat history
            ref.read(stepusChatProvider.notifier).clearChatHistory();
            ref.read(stepusChatProvider.notifier).unhit();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
