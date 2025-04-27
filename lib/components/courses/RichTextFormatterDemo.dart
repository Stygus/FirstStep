import 'package:flutter/material.dart';
import 'RichTextFormatter.dart';

/// Przykładowy model danych z bazy danych
class ArticleContent {
  final String text;
  final bool isBold;
  final bool isItalic;
  final Color? color;
  final double? fontSize;
  final bool isUnderline;
  final bool hasHighlight;

  ArticleContent({
    required this.text,
    this.isBold = false,
    this.isItalic = false,
    this.color,
    this.fontSize,
    this.isUnderline = false,
    this.hasHighlight = false,
  });
}

class DatabaseExample extends StatelessWidget {
  const DatabaseExample({super.key});

  // Symulacja pobrania danych z bazy
  List<ArticleContent> _getArticleContentFromDatabase() {
    // Ta funkcja symuluje dane, które mogłyby przyjść z bazy danych
    // W rzeczywistej aplikacji dane te mogłyby pochodzić z Firebase, API itp.
    return [
      ArticleContent(
        text: "Pierwsza pomoc ",
        isBold: true,
        fontSize: 22,
        color: Colors.redAccent,
      ),
      ArticleContent(
        text:
            "to zespół czynności wykonywanych w celu ratowania osoby w stanie nagłego zagrożenia zdrowia. ",
        color: Colors.white,
      ),
      ArticleContent(
        text: "Obejmuje ona zapewnienie bezpieczeństwa, ",
        isItalic: true,
      ),
      ArticleContent(
        text: "ocenę stanu poszkodowanego, ",
        color: Colors.greenAccent,
        isUnderline: true,
      ),
      ArticleContent(
        text: "wezwanie pomocy ",
        isBold: true,
        color: Colors.amber,
      ),
      ArticleContent(
        text: "oraz wykonanie niezbędnych czynności ratunkowych. ",
        fontSize: 18,
      ),
      ArticleContent(
        text: "PAMIĘTAJ! ",
        isBold: true,
        color: Colors.red,
        hasHighlight: true,
      ),
      ArticleContent(
        text: "Szybkie działanie zwiększa szanse na przeżycie poszkodowanego.",
        isItalic: true,
        color: Colors.lightBlue,
      ),
    ];
  }

  // Konwersja danych z bazy danych do formatu używanego przez RichTextFormatter
  List<TextFragment> _convertDatabaseDataToTextFragments() {
    final articleContents = _getArticleContentFromDatabase();

    return articleContents.map((content) {
      // Tworzenie stylu na podstawie właściwości z bazy danych
      TextStyle style = TextStyle(
        fontWeight: content.isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: content.isItalic ? FontStyle.italic : FontStyle.normal,
        color: content.color ?? Colors.white,
        fontSize: content.fontSize,
        decoration: content.isUnderline ? TextDecoration.underline : null,
        backgroundColor:
            content.hasHighlight ? Colors.yellow.withOpacity(0.3) : null,
      );

      // Tworzenie fragmentu tekstu
      return TextFragment(text: content.text, style: style);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Pobranie i konwersja danych z bazy
    final textFragments = _convertDatabaseDataToTextFragments();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      appBar: AppBar(
        title: const Text(
          'Artykuł z bazy danych',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 26, 26),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pierwsza Pomoc - Podstawy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Karty z artykułami
              Card(
                color: const Color.fromARGB(255, 40, 40, 40),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Użycie komponentu RichTextFormatter do wyświetlenia tekstu z bazy danych
                      RichTextFormatter(
                        fragments: textFragments,
                        baseStyle: const TextStyle(fontSize: 16, height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Źródło: Przykładowy artykuł o pierwszej pomocy',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Drugi przykład z innym układem
              Card(
                color: const Color.fromARGB(255, 30, 50, 70),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Przykład z ograniczoną szerokością:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Kontener z ograniczoną szerokością
                      Container(
                        width: 250,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: RichTextFormatter(
                          fragments: textFragments,
                          textAlign: TextAlign.start,
                          baseStyle: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
