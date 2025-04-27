import 'dart:convert';

import 'package:flutter/material.dart';

/// Widget do renderowania tekstu sformatowanego w stylu Quill JSON
class RichTextRenderer extends StatefulWidget {
  final String jsonContent;

  const RichTextRenderer({Key? key, required this.jsonContent})
    : super(key: key);

  @override
  State<RichTextRenderer> createState() => _RichTextRendererState();
}

class _RichTextRendererState extends State<RichTextRenderer> {
  List<dynamic> _parsedContent = [];

  @override
  void initState() {
    super.initState();
    _parseContent();
  }

  @override
  void didUpdateWidget(RichTextRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.jsonContent != widget.jsonContent) {
      _parseContent();
    }
  }

  void _parseContent() {
    try {
      if (widget.jsonContent.trim().isEmpty) {
        _parsedContent = [];
        return;
      }

      _parsedContent = jsonDecode(widget.jsonContent);
    } catch (e) {
      debugPrint('Błąd parsowania JSON w RichTextRenderer: $e');
      _parsedContent = [
        {'insert': 'Błąd formatu tekstu'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_parsedContent.isEmpty) {
      return const Text(
        'Pusty tekst',
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      );
    }

    return SelectableText.rich(
      TextSpan(children: _buildTextSpans(_parsedContent)),
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  List<TextSpan> _buildTextSpans(List<dynamic> deltaOperations) {
    List<TextSpan> spans = [];

    for (var operation in deltaOperations) {
      if (operation is! Map<String, dynamic>) continue;

      String? text = operation['insert']?.toString();
      if (text == null) continue;

      // Obsługa znaku nowej linii
      if (text.contains('\\n')) {
        text = text.replaceAll('\\n', '\n');
      }

      // Pozyskiwanie atrybutów formatowania
      Map<String, dynamic>? attributes =
          operation['attributes'] as Map<String, dynamic>?;

      // Tworzenie stylu tekstu na podstawie atrybutów
      TextStyle style = _buildTextStyle(attributes);

      spans.add(TextSpan(text: text, style: style));
    }

    return spans;
  }

  TextStyle _buildTextStyle(Map<String, dynamic>? attributes) {
    TextStyle style = const TextStyle(color: Colors.white, fontSize: 16.0);

    if (attributes == null) return style;

    // Obsługa pogrubienia
    if (attributes['bold'] == true) {
      style = style.copyWith(fontWeight: FontWeight.bold);
    }

    // Obsługa kursywy
    if (attributes['italic'] == true) {
      style = style.copyWith(fontStyle: FontStyle.italic);
    }

    // Obsługa podkreślenia
    if (attributes['underline'] == true) {
      style = style.copyWith(decoration: TextDecoration.underline);
    }

    // Obsługa przekreślenia
    if (attributes['strike'] == true) {
      style = style.copyWith(decoration: TextDecoration.lineThrough);
    }

    // Obsługa koloru tekstu
    if (attributes['color'] != null) {
      final colorHex = attributes['color'].toString();
      try {
        if (colorHex.startsWith('#') && colorHex.length >= 7) {
          final hex = colorHex.replaceFirst('#', '');
          final value = int.parse('FF$hex', radix: 16);
          style = style.copyWith(color: Color(value));
        }
      } catch (e) {
        debugPrint('Błąd parsowania koloru: $e');
      }
    }

    // Obsługa rozmiaru tekstu
    if (attributes['size'] != null) {
      double? fontSize;
      final size = attributes['size'].toString();

      switch (size) {
        case 'small':
          fontSize = 12.0;
          break;
        case 'large':
          fontSize = 20.0;
          break;
        case 'huge':
          fontSize = 24.0;
          break;
        default:
          if (size.endsWith('px')) {
            fontSize = double.tryParse(size.replaceAll('px', ''));
          }
      }

      if (fontSize != null) {
        style = style.copyWith(fontSize: fontSize);
      }
    }

    // Obsługa nagłówków
    if (attributes['header'] != null) {
      int headerLevel =
          attributes['header'] is int
              ? attributes['header']
              : int.tryParse(attributes['header'].toString()) ?? 0;

      double fontSize = 16.0;
      FontWeight fontWeight = FontWeight.normal;

      switch (headerLevel) {
        case 1:
          fontSize = 32.0;
          fontWeight = FontWeight.bold;
          break;
        case 2:
          fontSize = 28.0;
          fontWeight = FontWeight.bold;
          break;
        case 3:
          fontSize = 24.0;
          fontWeight = FontWeight.bold;
          break;
        case 4:
          fontSize = 20.0;
          fontWeight = FontWeight.bold;
          break;
        case 5:
          fontSize = 18.0;
          fontWeight = FontWeight.bold;
          break;
      }

      style = style.copyWith(fontSize: fontSize, fontWeight: fontWeight);
    }

    // Obsługa superscript i subscript
    if (attributes['script'] != null) {
      String script = attributes['script'].toString();
      if (script == 'super') {
        style = style.copyWith(
          fontSize: (style.fontSize ?? 16.0) * 0.8,
          height: 0.5,
        );
      } else if (script == 'sub') {
        style = style.copyWith(
          fontSize: (style.fontSize ?? 16.0) * 0.8,
          height: 2.0,
        );
      }
    }

    // Obsługa kodu
    if (attributes['code'] == true) {
      style = style.copyWith(
        fontFamily: 'monospace',
        backgroundColor: Colors.black45,
        color: Colors.lightGreenAccent,
      );
    }

    return style;
  }
}

/// Fragment tekstu z określonym stylem, używany do budowania złożonych tekstów
class TextFragment {
  final String text;
  final TextStyle style;

  TextFragment({required this.text, required this.style});
}
