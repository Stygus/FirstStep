import 'package:firststep/apteczkav2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApteczkaPage extends StatefulWidget {
  const ApteczkaPage({super.key});

  @override
  _ApteczkaPageState createState() => _ApteczkaPageState();
}

class _ApteczkaPageState extends State<ApteczkaPage> {
  String? _selectedOption;
  final List<Map<String, dynamic>> _options = [
    {'title': 'Apteczka górska', 'icon': Icons.terrain},
    {'title': 'Apteczka plażowa', 'icon': Icons.beach_access},
    {'title': 'Apteczka samochodowa', 'icon': Icons.directions_car},
    {
      'title': 'Apteczka rowerowa',
      'icon': Icons.pedal_bike,
    }, // Zamieniona opcja
    {'title': 'Apteczka podróżna', 'icon': Icons.flight},
    {'title': 'Apteczka sportowa', 'icon': Icons.sports_soccer},
    {'title': 'Apteczka codzienna', 'icon': Icons.local_hospital},
    {'title': 'Apteczka domowa', 'icon': Icons.home},
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
          SizedBox(
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  final option = _options[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedOption = option['title'];
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ApteczkaV2Page(
                                selectedApteczka: option['title'],
                              ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1D1D1D),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(option['icon'], color: Colors.white, size: 40),
                          SizedBox(height: 10),
                          Text(
                            option['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
