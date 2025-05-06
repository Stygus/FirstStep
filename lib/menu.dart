import 'package:firststep/routes/stepus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rko.dart';
import 'apteczka.dart';
import 'kursy.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF101010),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.1,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.001),
                    child: Text(
                      'Witaj w menu głównym xyz!',
                      style: GoogleFonts.itim(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: screenWidth * 0.1875,
                    decoration: const BoxDecoration(
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
          Center(
            child: SizedBox(
              height: screenHeight * 0.3,
              child: Container(
                color: const Color(0xFF1D1D1D),
                child: PageView.builder(
                  itemCount: 5,
                  controller: PageController(viewportFraction: 1.0),
                  itemBuilder: (context, index) {
                    String imagePath = 'assets/images/addr${index + 1}.png';
                    return Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: GestureDetector(
                        onTap: () async {
                          Uri url;
                          if (index == 1) {
                            url = Uri.parse(
                              'https://planujedlugiezycie.pl/historie/dieta-i-ruch/',
                            );
                          } else if (index == 2) {
                            url = Uri.parse(
                              'https://planujedlugiezycie.pl/historie/palenie/',
                            );
                          } else if (index == 3) {
                            url = Uri.parse(
                              'https://planujedlugiezycie.pl/historie/zdrowie/',
                            );
                          } else if (index == 4) {
                            url = Uri.parse(
                              'https://planujedlugiezycie.pl/historie/psychika/',
                            );
                          } else {
                            return;
                          }

                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Nie można otworzyć linku: $url'),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
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
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: screenWidth,
                  height: screenWidth,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ApteczkaPage(),
                              ),
                            );
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double size = constraints.maxWidth * 0.5;
                              return Container(
                                width: size,
                                height: size,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/apteka.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RKO()),
                            );
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double size = constraints.maxWidth * 0.5;
                              return Container(
                                width: size,
                                height: size,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/rkob.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StepusWidget(),
                              ),
                            );
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double size = constraints.maxWidth * 0.5;
                              return Container(
                                width: size,
                                height: size,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/poradab.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KursyPage(),
                              ),
                            );
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double size = constraints.maxWidth * 0.5;
                              return Container(
                                width: size,
                                height: size,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/kursy.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
