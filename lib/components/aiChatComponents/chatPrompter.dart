import 'package:firststep/providers/stepusChatProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class chatPrompter extends ConsumerWidget {
  @override
  const chatPrompter({super.key, this.controller});

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatHistory = ref.watch(stepusChatProvider.notifier);
    final isThinking = ref.watch(stepusChatProvider).isThinking;

    Widget buildLoadingIndicator() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16.0,
            height: 16.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
            ),
          ),
        ],
      );
    }

    return TextField(
      cursorColor: Colors.white54,
      cursorHeight: 20.0,
      cursorWidth: 2.0,
      maxLines: 4, // Zmniejszono maksymalną liczbę linii
      minLines: 2, // Zmniejszono minimalną liczbę linii
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        isDense: true,
        errorStyle: TextStyle(color: Colors.red, fontSize: 12),
        hintText: 'Zadaj pytanie...',
        hintStyle: TextStyle(color: Colors.white54),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ), // Zmniejszono padding
        filled: true,
        floatingLabelStyle: TextStyle(color: Colors.white54),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: TextButton(
            onPressed:
                isThinking
                    ? () => SnackBar(content: Text('Czekaj na odpowiedź...'))
                    : () {
                      if (controller!.text.isNotEmpty) {
                        chatHistory.sendMessage(controller!.text);
                        FocusScope.of(context).unfocus();
                        controller!.clear();
                      }
                    },
            style: TextButton.styleFrom(
              backgroundColor: isThinking ? Colors.grey : Color(0xFF2c2c2c),
              foregroundColor: Colors.white54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child:
                isThinking
                    ? buildLoadingIndicator()
                    : Text('Wyślij', style: TextStyle(color: Colors.white)),
          ),
        ),
        suffixStyle: TextStyle(color: Colors.white54),
        labelStyle: TextStyle(color: Colors.white54),
        fillColor: Color(0x1e1e1e),
        focusColor: Color(0x1e1e1e),
        hoverColor: Color(0x1e1e1e),
        enabled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
