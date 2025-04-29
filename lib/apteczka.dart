import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApteczkaPage extends StatefulWidget {
  @override
  _ApteczkaPageState createState() => _ApteczkaPageState();
}

class _ApteczkaPageState extends State<ApteczkaPage> {
  String? _selectedOption; // Wybrana opcja z listy

  final List<Map<String, dynamic>> _options = [
    {'title': 'Wyjazd w góry', 'icon': Icons.terrain},
    {'title': 'Wyjazd na plażę', 'icon': Icons.beach_access},
    {'title': 'Apteczka samochodowa', 'icon': Icons.directions_car},
    {'title': 'Apteczka domowa', 'icon': Icons.home},
    {'title': 'Apteczka podróżna', 'icon': Icons.flight},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xFF101010),
      body: Column(
        children: [
          Container(
            height: 100,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Wirtualna Apteczka',
                      style: GoogleFonts.itim(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * (3 / 16),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.bottomCenter,
                        image: AssetImage('assets/images/linia.png'),
                        fit: BoxFit.fill,
                        isAntiAlias: false,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista rozwijana
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              dropdownColor: Color(0xFF1D1D1D),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1D1D1D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              hint: Center(
                child: Text(
                  'Wybierz apteczkę',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: _selectedOption,
              items:
                  _options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['title'],
                      child: Row(
                        children: [
                          Icon(option['icon'], color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            option['title'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });

                // Wyświetlenie SnackBar po wyborze
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Wybrano: $value')));
              },
            ),
          ),
        ],
      ),
    );
  }
}
