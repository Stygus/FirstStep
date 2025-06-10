import 'package:flutter/material.dart';
import 'dart:io';

final Map<String, List<Map<String, dynamic>>> defaultItems = {
  //////////////////////////////////////////////////////////////////
  "Apteczka górska": [
    {
      "name": "Plastry różnych rozmiarów",
      "quantity": 30,
      "description":
          "Plastry w różnych rozmiarach, idealne na drobne rany i otarcia.",
      "image": "assets/images/aplastry.png",
    },
    {
      "name": "Sterylne gaziki",
      "quantity": 10,
      "description":
          "Gaziki sterylne do oczyszczania i wstępnego zabezpieczenia ran.",
      "image": "assets/images/gaziki.png",
    },
    {
      "name": "Sterylne kompresy (5×5 cm)",
      "quantity": 5,
      "description":
          "Kompresy sterylne o wymiarach 5×5 cm do zakładania opatrunków.",
      "image": "assets/images/kompresy.png",
    },
    {
      "name": "Sterylne kompresy (10×10 cm)",
      "quantity": 2,
      "description": "Większe kompresy sterylne do większych ran i otarć.",
      "image": "assets/images/kompresy.png",
    },
    {
      "name": "Bandaże elastyczne",
      "quantity": 2,
      "description":
          "Elastyczne bandaże do stabilizacji stawów i uciskowego unieruchomienia.",
      "image": "assets/images/elastyczny.png",
    },
    {
      "name": "Taśma sportowa",
      "quantity": 1,
      "description":
          "Taśma kinesiotapingowa do odciążenia i stabilizacji mięśni oraz stawów.",
      "image": "assets/images/sportowa.png",
    },
    {
      "name": "Chusta trójkątna",
      "quantity": 1,
      "description":
          "Uniwersalna chusta do unieruchamiania kończyn lub zabezpieczenia opatrunków.",
      "image": "assets/images/chustatroj.png",
    },
    {
      "name": "Nożyczki",
      "quantity": 1,
      "description": "Nożyczki medyczne do cięcia bandaży i plastrów.",
      "image": "assets/images/nozyczki.png",
    },
    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do usuwania ciał obcych z ran.",
      "image": "assets/images/peseta.png",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 4,
      "description":
          "Rękawiczki lateksowe chroniące przed zakażeniem podczas udzielania pierwszej pomocy.",
      "image": "assets/images/rekawiczki.png",
    },
    {
      "name": "Środek odkażający",
      "quantity": 10,
      "description": "Płyn do dezynfekcji ran i rąk.",
      "image": "assets/images/odkazanie.png",
    },
    {
      "name": "Folia NRC",
      "quantity": 1,
      "description":
          "Termiczna folia ratunkowa do zabezpieczenia termicznego poszkodowanego.",
      "image": "assets/images/nrc.png",
    },
    {
      "name": "Gwizdek awaryjny",
      "quantity": 1,
      "description": "Gwizdek do sygnalizacji w razie potrzeby pomocy.",
      "image": "assets/images/gwizdek.png",
    },
    {
      "name": "Tabletki przeciwbólowe",
      "quantity": 10,
      "description": "Tabletki przeciwbólowe (np. ibuprofen, paracetamol).",
      "image": "assets/images/leki-przeciwbólowe.png",
    },
    {
      "name": "Tabletki na biegunkę",
      "quantity": 5,
      "description": "Tabletki łagodzące biegunkę i dolegliwości żołądkowe.",
      "image": "assets/images/tabletki-bieg.png",
    },

    {
      "name": "Leki przeciwhistaminowe",
      "quantity": 5,
      "description": "Tabletki na reakcje alergiczne i swędzenie.",
      "image": "assets/images/lekiprzeciw.png",
    },
    {
      "name": "Elektrolity w tabletkach",
      "quantity": 2,
      "description": "Tabletki elektrolitowe w razie odwodnienia.",
      "image": "assets/images/elektrolity.png",
    },
  ],
  /////////////////////////////////////////////////////////////////////////////////////////
  "Apteczka plażowa": [
    {
      "name": "Krem chłodzący po oparzeniach",
      "quantity": 1,
      "description":
          "Krem aloesowy lub łagodzący skórę po oparzeniach słonecznych.",
      "image": "assets/images/kremaloes.png",
    },
    {
      "name": "Plastry wodoodporne",
      "quantity": 10,
      "description": "Wodoodporne plastry do zakrywania drobnych ran na plaży.",
      "image": "assets/images/plastrywodoodporne.png",
    },
    {
      "name": "Opatrunek hydrożelowy",
      "quantity": 2,
      "description": "Opatrunek hydrożelowy na oparzenia i otarcia.",
      "image": "assets/images/opatrunekhydrozel.png",
    },
    {
      "name": "Środek na ukąszenia owadów",
      "quantity": 1,
      "description": "Żel lub spray łagodzący swędzenie po ukąszeniach owadów.",
      "image": "assets/images/ukoszenia.png",
    },
    {
      "name": "Chusteczki odkażające",
      "quantity": 10,
      "description": "Chusteczki do szybkiej dezynfekcji skóry.",
      "image": "assets/images/chusteczki.png",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 6,
      "description": "Tabletki przeciwbólowe i przeciwzapalne.",
      "image": "assets/images/leki-przeciwbólowe.png",
    },
    {
      "name": "Krem z filtrem UV",
      "quantity": 1,
      "description":
          "Krem z wysokim filtrem SPF 30–50+ chroniący przed słońcem.",
      "image": "assets/images/kremuv.png",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 2,
      "description": "Rękawiczki chroniące przy zakładaniu opatrunków.",
      "image": "assets/images/rekawiczki.png",
    },
    {
      "name": "Leki przeciwhistaminowe",
      "quantity": 5,
      "description": "Tabletki na reakcje alergiczne i swędzenie.",
      "image": "assets/images/lekiprzeciw.png",
    },
    {
      "name": "Mała butelka wody",
      "quantity": 1,
      "description": "Woda do płukania ran i schładzania skóry.",
      "image": "assets/images/woda.png",
    },
    {
      "name": "Plastry na pęcherze",
      "quantity": 5,
      "description":
          "Specjalne plastry na pęcherze od chodzenia po gorącym piasku.",
      "image": "assets/images/plastrystopy.png",
    },
    {
      "name": "Elektrolity w tabletkach",
      "quantity": 2,
      "description": "Tabletki elektrolitowe w razie odwodnienia.",
      "image": "assets/images/elektrolity.png",
    },
  ],

  //////////////////////////////////////////////////////////////////////////////////////////////////
  "Apteczka samochodowa": [
    {
      "name": "Plastry",
      "quantity": 20,
      "description": "Plastry o różnych rozmiarach do zakrywania drobnych ran.",
      "image": "assets/images/aplastry.png",
    },
    {
      "name": "Sterylne gaziki",
      "quantity": 20,
      "description": "Gaziki do dezynfekcji i ochrony ran.",
      "image": "assets/images/gaziki.png",
    },
    {
      "name": "Sterylne kompresy (5×5 cm)",
      "quantity": 10,
      "description": "Kompresy do poważniejszych ran.",
      "image": "assets/images/kompresy.png",
    },
    {
      "name": "Bandaże elastyczne",
      "quantity": 1,
      "description": "Bandaż elastyczny do unieruchamiania i stabilizacji.",
      "image": "assets/images/elastyczny.png",
    },
    {
      "name": "Opaska uciskowa",
      "quantity": 1,
      "description": "Opaska do tamowania krwotoku.",
      "image": "assets/images/opaskaucisk.png",
    },
    {
      "name": "Chusta trójkątna",
      "quantity": 1,
      "description": "Do unieruchamiania kończyn przy złamaniach.",
      "image": "assets/images/chustatroj.png",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 5,
      "description": "Rękawiczki lateksowe do ochrony przed infekcją.",
      "image": "assets/images/rekawiczki.png",
    },
    {
      "name": "Nożyczki",
      "quantity": 1,
      "description": "Nożyczki medyczne do opatrunków.",
      "image": "assets/images/nozyczki.png",
    },
    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do usuwania ciał obcych.",
      "image": "assets/images/peseta.png",
    },
    {
      "name": "Płyn do dezynfekcji",
      "quantity": 10,
      "description": "Środek do odkażania ran i powierzchni.",
      "image": "assets/images/odkazanie.png",
    },
    {
      "name": "Folia NRC",
      "quantity": 1,
      "description": "Folia ratunkowa do utrzymania ciepłoty ciała.",
      "image": "assets/images/nrc.png",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 10,
      "description": "Tabletki przeciwbólowe.",
      "image": "assets/images/leki-przeciwbólowe.png",
    },

    {
      "name": "Maseczka do sztucznego oddychania",
      "quantity": 1,
      "description": "Maseczka do resuscytacji krążeniowo-oddechowej.",
      "image": "assets/images/maseczka.png",
    },
    {
      "name": "Kamizelka odblaskowa",
      "quantity": 1,
      "description": "Kamizelka odblaskowa zwiększająca widoczność.",
      "image": "assets/images/kamizelka.png",
    },
  ],
  /////////////////////////////////////////////////////////////////////
  "Apteczka rowerowa": [
    {
      "name": "Plastry",
      "quantity": 10,
      "description": "Plastry w rolce i plasterki na drobne urazy.",
      "image": "assets/images/aplastry.png",
    },
    {
      "name": "Sterylne kompresy",
      "quantity": 3,
      "description": "Małe kompresy do większych ran.",
      "image": "assets/images/kompresy.png",
    },
    {
      "name": "Bandaż elastyczny",
      "quantity": 1,
      "description": "Opaska elastyczna do unieruchamiania.",
      "image": "assets/images/elastyczny.png",
    },
    {
      "name": "Chusteczki odkażające",
      "quantity": 5,
      "description": "Chusteczki do szybkiej dezynfekcji.",
      "image": "assets/images/chusteczki.png",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 2,
      "description": "Rękawiczki do ochrony rąk.",
      "image": "assets/images/rekawiczki.png",
    },
    {
      "name": "Maść na stłuczenia",
      "quantity": 1,
      "description": "Maść chłodząca na stłuczenia.",
      "image": "assets/images/mascstluczenia.png",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 5,
      "description": "Tabletki przeciwbólowe.",
      "image": "assets/images/leki-przeciwbólowe.png",
    },
    {
      "name": "Plastry na odciski/pęcherze",
      "quantity": 5,
      "description": "Specjalne plastry na pęcherze.",
      "image": "assets/images/plastrystopy.png",
    },
    {
      "name": "Folia NRC",
      "quantity": 1,
      "description": "Termiczna folia ratunkowa kompaktowa.",
      "image": "assets/images/nrc.png",
    },
    {
      "name": "Maseczka do sztucznego oddychania",
      "quantity": 1,
      "description": "Maseczka do resuscytacji krążeniowo-oddechowej.",
      "image": "assets/images/maseczka.png",
    },
  ],
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  "Apteczka podróżna": [
    {
      "name": "Plastry",
      "quantity": 20,
      "description": "Plastry do drobnych skaleczeń.",
      "image": "assets/images/aplastry.png",
    },
    {
      "name": "Sterylne gaziki",
      "quantity": 10,
      "description": "Gaziki do dezynfekcji.",
      "image": "assets/images/gaziki.png",
    },
    {
      "name": "Sterylne kompresy",
      "quantity": 5,
      "description": "Kompresy do większych ran.",
      "image": "assets/images/kompresy.png",
    },
    {
      "name": "Bandaże elastyczne",
      "quantity": 1,
      "description": "Bandaż do unieruchomienia.",
      "image": "assets/images/elastyczny.png",
    },
    {
      "name": "Chusteczki odkażające",
      "quantity": 10,
      "description": "Chusteczki do oczyszczania.",
      "image": "assets/images/chusteczki.png",
    },
    {
      "name": "Nożyczki",
      "quantity": 1,
      "description": "Nożyczki medyczne do opatrunków.",
      "image": "assets/images/nozyczki.png",
    },
    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do usuwania ciał obcych.",
      "image": "assets/images/peseta.png",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 4,
      "description": "Dla ochrony i higieny.",
      "image": "assets/images/rekawiczki.png",
    },

    {
      "name": "Leki przeciwbólowe",
      "quantity": 10,
      "description": "Tabletki przeciwbólowe.",
      "image": "assets/images/leki-przeciwbólowe.png",
    },

    {
      "name": "Tabletki na biegunkę",
      "quantity": 5,
      "description": "Tabletki na biegunkę.",
      "image": "assets/images/tabletki-bieg.png",
    },
    {
      "name": "Krople do oczu",
      "quantity": 1,
      "description": "Krople łagodzące podrażnienia oczu.",
      "image": "assets/images/kropleoczy.png",
    },
    {
      "name": "Termometr elektroniczny",
      "quantity": 1,
      "description": "Elektroniczny termometr do pomiaru temperatury.",
      "image": "assets/images/termometr.png",
    },
    {
      "name": "Maseczka do sztucznego oddychania",
      "quantity": 1,
      "description": "Maseczka do resuscytacji krążeniowo-oddechowej.",
      "image": "assets/images/maseczka.png",
    },
    ////////////////////////////////////////////////////////////////////////////////////////////////
  ],
  "Apteczka sportowa": [
    {
      "name": "Bandaż samoprzylepny",
      "quantity": 1,
      "description": "Bandaż do stabilizacji stawów.",
      "image": "assets/images/samoprzylepny.png",
    },
    {
      "name": "Taśma kinesiotapingowa",
      "quantity": 1,
      "description": "Taśma do odciążenia mięśni.",
      "image": "assets/images/sportowa.png",
    },
    {
      "name": "Chusteczki odkażające",
      "quantity": 10,
      "description": "Chusteczki do dezynfekcji.",
      "image": "assets/images/chusteczki.png",
    },
    {
      "name": "Maść chłodząca",
      "quantity": 1,
      "description": "Maść do łagodzenia stłuczeń.",
      "image": "assets/images/mascstluczenia.png",
    },
    {
      "name": "Maść rozgrzewająca",
      "quantity": 1,
      "description": "Maść do rozgrzewania mięśni przed wysiłkiem.",
      "image": "assets/images/rozgrzewajaca.png",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 10,
      "description": "Tabletki przeciwbólowe.",
      "image": "assets/images/leki-przeciwbólowe.png",
    },
    {
      "name": "Kompresy żelowe",
      "quantity": 2,
      "description": "Kompresy żelowe na stłuczenia.",
      "image": "assets/images/opatrunekhydrozel.png",
    },

    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do precyzyjnych manipulacji.",
      "image": "assets/images/peseta.png",
    },
    {
      "name": "Rękawiczki lateksowe",
      "quantity": 2,
      "description": "Rękawiczki dla higieny.",
      "image": "assets/images/rekawiczki.png",
    },
    {
      "name": "Mini termospray na stłuczenia",
      "quantity": 1,
      "description": "Spray chłodzący w wygodnej formie.",
      "image": "assets/images/spray.png",
    },
    {
      "name": "Maseczka do sztucznego oddychania",
      "quantity": 1,
      "description": "Maseczka do resuscytacji krążeniowo-oddechowej.",
      "image": "assets/images/maseczka.png",
    },
  ],
  /////////////////////// //////////////////////////////////////////////////////  //  /       ///////
  "Apteczka codzienna": [
    {
      "name": "Plastry różnych rozmiarów",
      "quantity": 15,
      "description": "Plastry na drobne otarcia i skaleczenia.",
      "image": "assets/images/aplastry.png",
    },
    {
      "name": "Chusteczki dezynfekujące",
      "quantity": 10,
      "description": "Chusteczki do szybkiej dezynfekcji.",
      "image": "assets/images/chusteczki.png",
    },
    {
      "name": "Tabletki przeciwbólowe",
      "quantity": 3,
      "description": "Tabletki na ból głowy i inne dolegliwości.",
      "image": "assets/images/leki-przeciwbólowe.png",
    },
    {
      "name": "Pastylki na ból gardła",
      "quantity": 5,
      "description": "Pastylki łagodzące ból gardła.",
      "image": "assets/images/pastylki.png",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 1,
      "description": "Para jednorazowych rękawiczek.",
      "image": "assets/images/rekawiczki.png",
    },
    {
      "name": "Bandaż elastyczny",
      "quantity": 1,
      "description": "Mały bandaż elastyczny.",
      "image": "assets/images/elastyczny.png",
    },
    {
      "name": "Termometr",
      "quantity": 1,
      "description": "Termometr do pomiaru temperatury.",
      "image": "assets/images/termometr.png",
    },
    {
      "name": "Maseczka do sztucznego oddychania",
      "quantity": 1,
      "description": "Maseczka do resuscytacji krążeniowo-oddechowej.",
      "image": "assets/images/maseczka.png",
    },
  ],
  //////////////////////////////////////////////////////////////////////////////////////////////////
  "Apteczka domowa": [
    {
      "name": "Plastry",
      "quantity": 50,
      "description":
          "Plastry w rolce i plasterki do zatamowania drobnych krwawień.",
      "image": "assets/images/aplastry.png",
    },
    {
      "name": "Sterylne gaziki",
      "quantity": 50,
      "description": "Gaziki do oczyszczania ran.",
      "image": "assets/images/gaziki.png",
    },
    {
      "name": "Sterylne kompresy",
      "quantity": 10,
      "description": "Kompresy do opatrunków.",
      "image": "assets/images/kompresy.png",
    },
    {
      "name": "Bandaże elastyczne",
      "quantity": 2,
      "description": "Bandaże do stabilizacji.",
      "image": "assets/images/elastyczny.png",
    },
    {
      "name": "Bandaże opatrunkowe",
      "quantity": 5,
      "description": "Opatrunkowe bandaże różnych rozmiarów.",
      "image": "assets/images/bandage.png",
    },
    {
      "name": "Gazy jałowe",
      "quantity": 20,
      "description": "Gazy do wstępnego opatrywania ran.",
      "image": "assets/images/gaza.png",
    },
    {
      "name": "Gazy niejałowe",
      "quantity": 20,
      "description": "Gazy do lekkich opatrunków.",
      "image": "assets/images/niejałowa.png",
    },
    {
      "name": "Taśma medyczna",
      "quantity": 1,
      "description": "Taśma do mocowania opatrunków.",
      "image": "assets/images/lepiecopatrunki.png",
    },
    {
      "name": "Chusty trójkątne",
      "quantity": 2,
      "description": "Chusty do unieruchamiania kończyn.",
      "image": "assets/images/chustatroj.png",
    },
    {
      "name": "Nożyczki",
      "quantity": 1,
      "description": "Nożyczki medyczne do opatrunków.",
      "image": "assets/images/nozyczki.png",
    },
    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do manipulacji opatrunków.",
      "image": "assets/images/peseta.png",
    },
    {
      "name": "Rękawiczki lateksowe",
      "quantity": 10,
      "description": "Rękawiczki do ochrony przed zakażeniami.",
      "image": "assets/images/rekawiczki.png",
    },
    {
      "name": "Płyn do dezynfekcji",
      "quantity": 1,
      "description": "Płyn do odkażania skóry i narzędzi.",
      "image": "assets/images/odkazanie.png",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 20,
      "description": "Tabletki przeciwbólowe i przeciwgorączkowe.",
      "image": "assets/images/leki-przeciwbólowe.png",
    },

    {
      "name": "Termometr cyfrowy",
      "quantity": 1,
      "description": "Termometr do mierzenia temperatury.",
      "image": "assets/images/termometr.png",
    },
    {
      "name": "Ampułki do płukania oczu",
      "quantity": 5,
      "description": "Ampułki do płukania oczu.",
      "image": "assets/images/ampułkioczy.png",
    },
    {
      "name": "Krople do oczu",
      "quantity": 1,
      "description": "Krople na podrażnione oczy.",
      "image": "assets/images/kropleoczy.png",
    },

    {
      "name": "Maseczka do sztucznego oddychania",
      "quantity": 1,
      "description": "Maseczka do resuscytacji krążeniowo-oddechowej.",
      "image": "assets/images/maseczka.png",
    },
  ],
};

class ApteczkaV2Page extends StatefulWidget {
  final String selectedApteczka;

  const ApteczkaV2Page({super.key, required this.selectedApteczka});

  @override
  _ApteczkaV2PageState createState() => _ApteczkaV2PageState();
}

class _ApteczkaV2PageState extends State<ApteczkaV2Page> {
  List<Map<String, dynamic>> _items = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (defaultItems.containsKey(widget.selectedApteczka)) {
      _items = List<Map<String, dynamic>>.from(
        defaultItems[widget.selectedApteczka]!,
      );
    }
  }

  void _addItem(String name, String description) {
    setState(() {
      _items.add({
        'name': name,
        'description': description,
        'image': 'assets/images/logod.png', // Tymczasowe zdjęcie
        'quantity': 1,
      });
    });
  }

  void _showAddItemMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF1D1D1D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dodaj element',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nazwa elementu',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF2D2D2D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Opis elementu',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF2D2D2D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _descriptionController.text.isNotEmpty) {
                    _addItem(_nameController.text, _descriptionController.text);
                    _nameController.clear();
                    _descriptionController.clear();
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Dodaj'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Tymczasowe miejsce na dodawanie zdjęcia
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dodawanie zdjęcia wkrótce!')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text('Dodaj zdjęcie'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _viewItemDetails(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemDetailsPage(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectedApteczka,
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
                child:
                    _items.isEmpty
                        ? Center(
                          child: Text(
                            'Brak elementów w apteczce',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                        : ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _viewItemDetails(_items[index]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1D1D1D),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.13, // responsywnie, ok. 48px na typowym ekranie
                                        height:
                                            MediaQuery.of(context).size.width *
                                            0.13,
                                        child:
                                            _items[index]['image'] != null
                                                ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.0,
                                                      ),
                                                  child: Image.asset(
                                                    _items[index]['image'],
                                                    fit: BoxFit.contain,
                                                  ),
                                                )
                                                : Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                  size:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.13,
                                                ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _items[index]['name'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Ilość: ${_items[index]['quantity'] ?? 1}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (_items[index]['quantity'] >
                                                    1) {
                                                  _items[index]['quantity']--;
                                                }
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _items[index]['quantity'] =
                                                    (_items[index]['quantity'] ??
                                                        1) +
                                                    1;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _removeItem(index),
                                      ),
                                    ],
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
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showAddItemMenu,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(
                'Dodaj element',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemDetailsPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name'], style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1D1D1D),
      ),
      backgroundColor: Color(0xFF101010),
      body: SingleChildScrollView(
        // Dodano przewijanie
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
              ),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFF1D1D1D),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.red, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services, color: Colors.red, size: 50),
                  SizedBox(height: 16),
                  item['image'] != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double maxImgSize =
                                MediaQuery.of(context).size.width * 0.7;
                            return Image.asset(
                              item['image'],
                              width: maxImgSize,
                              height: maxImgSize,
                              fit: BoxFit.contain,
                            );
                          },
                        ),
                      )
                      : Icon(Icons.image, color: Colors.grey, size: 120),
                  SizedBox(height: 16),
                  Text(
                    item['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    item['description'],
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
