import 'dart:convert';

import 'package:flutter/material.dart';

/// Widget do renderowania tekstu sformatowanego w stylu Quill JSON
class RichTextRenderer extends StatefulWidget {
  final String jsonContent;

  const RichTextRenderer({super.key, required this.jsonContent});

  @override
  State<RichTextRenderer> createState() => _RichTextRendererState();
}

class _RichTextRendererState extends State<RichTextRenderer> {
  List<dynamic> _parsedContent = [];
  // Dodajemy zmienną do śledzenia aktualnego typu listy
  String? _currentListType;
  // Licznik dla list numerowanych
  int _orderedListCounter = 1;

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

    return _buildRichTextContent();
  }

  Widget _buildRichTextContent() {
    List<Widget> contentWidgets = [];
    _currentListType = null;
    _orderedListCounter = 1;

    List<Map<String, dynamic>> paragraphs = _groupIntoParagraphs();

    for (var paragraph in paragraphs) {
      Widget paragraphWidget = _buildParagraphWidget(paragraph);
      contentWidgets.add(paragraphWidget);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentWidgets,
    );
  }

  List<Map<String, dynamic>> _groupIntoParagraphs() {
    List<Map<String, dynamic>> paragraphs = [];
    Map<String, dynamic> currentParagraph = {
      'content': <dynamic>[],
      'attributes': <String, dynamic>{},
    };

    for (int i = 0; i < _parsedContent.length; i++) {
      var operation = _parsedContent[i];
      if (operation is! Map<String, dynamic>) continue;

      String? text = operation['insert']?.toString();
      if (text == null) continue;

      Map<String, dynamic>? attributes =
          operation['attributes'] as Map<String, dynamic>?;

      // Jeśli to jest tylko znak nowej linii z atrybutami (np. header)
      if (text == '\n' &&
          attributes != null &&
          currentParagraph['content'].isNotEmpty) {
        // Przypisz atrybuty do całego paragrafu
        currentParagraph['attributes'] = attributes;
        paragraphs.add(Map<String, dynamic>.from(currentParagraph));
        currentParagraph = {
          'content': <dynamic>[],
          'attributes': <String, dynamic>{},
        };
        continue;
      }

      // Standardowa obsługa: jeśli tekst zawiera \n, dzielimy na linie
      if (text.contains('\n')) {
        var lines = text.split('\n');
        for (int j = 0; j < lines.length; j++) {
          String line = lines[j];
          if (line.isNotEmpty) {
            var lineOp = Map<String, dynamic>.from(operation);
            lineOp['insert'] = line;
            currentParagraph['content'].add(lineOp);
          }
          if (j < lines.length - 1) {
            paragraphs.add(Map<String, dynamic>.from(currentParagraph));
            currentParagraph = {
              'content': <dynamic>[],
              'attributes': <String, dynamic>{},
            };
          }
        }
      } else {
        currentParagraph['content'].add(operation);
      }
    }
    if ((currentParagraph['content'] as List).isNotEmpty) {
      paragraphs.add(currentParagraph);
    }
    return paragraphs;
  }

  Widget _buildParagraphWidget(Map<String, dynamic> paragraph) {
    List<dynamic> content = paragraph['content'];
    Map<String, dynamic>? attributes = paragraph['attributes'];

    // Przekazujemy atrybuty paragrafu do _buildTextSpans
    TextSpan paragraphSpan = TextSpan(
      children: _buildTextSpans(content, paragraphAttributes: attributes),
    );

    // Ustawienia podstawowe
    TextAlign textAlign = TextAlign.start;

    // Konfiguracja wyrównania tekstu
    if (attributes != null && attributes['align'] != null) {
      switch (attributes['align'].toString()) {
        case 'justify':
          textAlign = TextAlign.justify;
          break;
        case 'center':
          textAlign = TextAlign.center;
          break;
        case 'right':
          textAlign = TextAlign.right;
          break;
        default:
          textAlign = TextAlign.start;
      }
    }

    // Blok kodu
    if (attributes != null && attributes['code-block'] == true) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: SelectableText.rich(
          paragraphSpan,
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Colors.lightGreenAccent,
            fontSize: 16.0,
          ),
        ),
      );
    }

    // Listy
    Widget? prefixWidget;
    if (attributes != null && attributes['list'] != null) {
      String listType = attributes['list'].toString();

      // Reset licznika przy zmianie typu listy
      if (_currentListType != listType) {
        if (listType == 'ordered') {
          _orderedListCounter = 1;
        }
        _currentListType = listType;
      }

      switch (listType) {
        case 'ordered':
          prefixWidget = Container(
            width: 24.0,
            margin: const EdgeInsets.only(right: 8.0),
            child: Text(
              '${_orderedListCounter++}.',
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
              textAlign: TextAlign.right,
            ),
          );
          break;
        case 'bullet':
          prefixWidget = Container(
            width: 24.0,
            margin: const EdgeInsets.only(right: 8.0),
            child: const Text(
              '•',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          );
          break;
        case 'checked':
          prefixWidget = Container(
            width: 24.0,
            margin: const EdgeInsets.only(right: 8.0),
            child: const Icon(Icons.check_box, color: Colors.white, size: 16.0),
          );
          break;
        case 'unchecked':
          prefixWidget = Container(
            width: 24.0,
            margin: const EdgeInsets.only(right: 8.0),
            child: const Icon(
              Icons.check_box_outline_blank,
              color: Colors.white,
              size: 16.0,
            ),
          );
          break;
      }
    } else {
      _currentListType = null;
    }

    // Styl nagłówka dla całego paragrafu (jeśli jest header)
    TextStyle paragraphStyle = _buildTextStyle(attributes);

    // Jeśli mamy prefix (lista), używamy Row do połączenia elementów
    if (prefixWidget != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            prefixWidget,
            Expanded(
              child: SelectableText.rich(
                paragraphSpan,
                textAlign: textAlign,
                style: paragraphStyle,
              ),
            ),
          ],
        ),
      );
    }

    // Jeśli to nagłówek, opakuj w ConstrainedBox + FittedBox, aby szerokość była dopasowana do tekstu, ale nie większa niż 80% ekranu
    if (attributes != null && attributes['header'] != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SelectableText.rich(
              paragraphSpan,
              textAlign: textAlign,
              style: paragraphStyle,
            ),
          ),
        ),
      );
    }

    // Standardowy paragraf
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SelectableText.rich(
        paragraphSpan,
        textAlign: textAlign,
        style: paragraphStyle,
      ),
    );
  }

  List<TextSpan> _buildTextSpans(
    List<dynamic> deltaOperations, {
    Map<String, dynamic>? paragraphAttributes,
  }) {
    List<TextSpan> spans = [];

    // Najpierw usuwamy entery z końca zawartości
    if (deltaOperations.isNotEmpty) {
      var lastOperation = deltaOperations.last;
      if (lastOperation is Map<String, dynamic> &&
          lastOperation['insert'] is String &&
          lastOperation['insert'].toString().endsWith('\n')) {
        lastOperation['insert'] =
            lastOperation['insert'].toString().trimRight();
      }
    }

    for (var operation in deltaOperations) {
      if (operation is! Map<String, dynamic>) continue;

      String? text = operation['insert']?.toString();
      if (text == null) continue;

      // Obsługa znaku nowej linii
      if (text.contains('\\n')) {
        text = text.replaceAll('\\n', '\n');
      }

      // Usuwamy dodatkowe entery z końca tekstu
      if (operation == deltaOperations.last) {
        text = text.trimRight();
      }

      // Pozyskiwanie atrybutów formatowania
      Map<String, dynamic>? attributes =
          operation['attributes'] as Map<String, dynamic>?;

      // Jeśli nie ma atrybutu header w tym fragmencie, a jest w paragrafie, kopiujemy go
      if ((attributes == null || !attributes.containsKey('header')) &&
          paragraphAttributes != null &&
          paragraphAttributes['header'] != null) {
        attributes = {...?attributes, 'header': paragraphAttributes['header']};
      }

      // Tworzenie stylu tekstu na podstawie atrybutów
      TextStyle style = _buildTextStyle(attributes);

      spans.add(TextSpan(text: text, style: style));
    }

    return spans;
  }

  TextStyle _buildTextStyle(Map<String, dynamic>? attributes) {
    TextStyle style = const TextStyle(color: Colors.white, fontSize: 20.0);

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

      double fontSize = 20.0;
      FontWeight fontWeight = FontWeight.bold;

      switch (headerLevel) {
        case 1:
          fontSize = 26.0;
          break;
        case 2:
          fontSize = 32.0;
          break;
        case 3:
          fontSize = 38.0;
          break;
        default:
          fontSize = 20.0;
          fontWeight = FontWeight.normal;
      }

      style = style.copyWith(fontSize: fontSize, fontWeight: fontWeight);
    }

    // Obsługa superscript i subscript
    if (attributes['script'] != null) {
      String script = attributes['script'].toString();
      if (script == 'super') {
        style = style.copyWith(
          fontSize: (style.fontSize ?? 20.0) * 0.8,
          height: 0.5,
        );
      } else if (script == 'sub') {
        style = style.copyWith(
          fontSize: (style.fontSize ?? 20.0) * 0.8,
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
