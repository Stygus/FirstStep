import 'package:flutter/material.dart';

class ApteczkaV2Page extends StatelessWidget {
  final String selectedApteczka; // Wybrana apteczka przekazana z apteczka.dart

  const ApteczkaV2Page({super.key, required this.selectedApteczka});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wirtualna Apteczka',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1D1D1D),
      ),
      backgroundColor: Color(0xFF101010),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF1D1D1D),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    selectedApteczka,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Podgląd: $selectedApteczka')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Skopiowano: $selectedApteczka')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Udostępniono: $selectedApteczka'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
