import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebView Page')),
      body: PageView.builder(
        itemCount: 3,
        controller: PageController(viewportFraction: 1.0),
        itemBuilder: (context, index) {
          String imagePath = 'assets/images/addr${index + 1}.png';
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () async {
                if (index == 1) {
                  // Link dla zdjęcia 2
                  final url = Uri.parse(
                    'https://planujedlugiezycie.pl/historie/dieta-i-ruch/',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Nie można otworzyć linku: $url';
                  }
                } else if (index == 2) {
                  // Link dla zdjęcia 3
                  final url = Uri.parse(
                    'https://planujedlugiezycie.pl/historie/palenie/',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Nie można otworzyć linku: $url';
                  }
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/add1.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
