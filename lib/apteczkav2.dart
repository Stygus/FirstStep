import 'package:flutter/material.dart';
import 'dart:io';

final Map<String, List<Map<String, dynamic>>> defaultItems = {
  "Apteczka górska": [
    {
      "name": "Plastry różnych rozmiarów",
      "quantity": 30,
      "description":
          "Plastry w różnych rozmiarach, idealne na drobne rany i otarcia.",
    },
    {
      "name": "Sterylne gaziki",
      "quantity": 10,
      "description":
          "Gaziki sterylne do oczyszczania i wstępnego zabezpieczenia ran.",
    },
    {
      "name": "Sterylne kompresy (5×5 cm)",
      "quantity": 5,
      "description":
          "Kompresy sterylne o wymiarach 5×5 cm do zakładania opatrunków.",
    },
    {
      "name": "Sterylne kompresy (10×10 cm)",
      "quantity": 2,
      "description": "Większe kompresy sterylne do większych ran i otarć.",
    },
    {
      "name": "Bandaże elastyczne",
      "quantity": 2,
      "description":
          "Elastyczne bandaże do stabilizacji stawów i uciskowego unieruchomienia.",
    },
    {
      "name": "Taśma sportowa",
      "quantity": 1,
      "description":
          "Taśma kinesiotapingowa do odciążenia i stabilizacji mięśni oraz stawów.",
    },
    {
      "name": "Chusta trójkątna",
      "quantity": 1,
      "description":
          "Uniwersalna chusta do unieruchamiania kończyn lub zabezpieczenia opatrunków.",
    },
    {
      "name": "Nożyczki",
      "quantity": 1,
      "description": "Nożyczki medyczne do cięcia bandaży i plastrów.",
    },
    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do usuwania ciał obcych z ran.",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 4,
      "description":
          "Rękawiczki lateksowe chroniące przed zakażeniem podczas udzielania pierwszej pomocy.",
    },
    {
      "name": "Środek odkażający",
      "quantity": 10,
      "description": "Chusteczki lub płyn do dezynfekcji ran i rąk.",
    },
    {
      "name": "Folia NRC",
      "quantity": 1,
      "description":
          "Termiczna folia ratunkowa do zabezpieczenia termicznego poszkodowanego.",
    },
    {
      "name": "Gwizdek awaryjny",
      "quantity": 1,
      "description": "Gwizdek do sygnalizacji w razie potrzeby pomocy.",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 10,
      "description": "Tabletki przeciwbólowe (np. ibuprofen, paracetamol).",
    },
    {
      "name": "Lek na chorobę wysokościową",
      "quantity": 5,
      "description": "Tabletki łagodzące objawy choroby wysokościowej.",
    },
    {
      "name": "Tabletki na biegunkę",
      "quantity": 5,
      "description": "Tabletki łagodzące biegunkę i dolegliwości żołądkowe.",
    },
    {
      "name": "Maść przeciwzapalna",
      "quantity": 1,
      "description":
          "Maść na stłuczenia i skręcenia z działaniem przeciwzapalnym.",
    },
    {
      "name": "Notatnik + długopis",
      "quantity": 1,
      "description":
          "Notatnik i długopis do notowania objawów i danych ratunkowych.",
    },
  ],
  "Apteczka plażowa": [
    {
      "name": "Krem chłodzący po oparzeniach",
      "quantity": 1,
      "description":
          "Krem aloesowy lub łagodzący skórę po oparzeniach słonecznych.",
    },
    {
      "name": "Plastry wodoodporne",
      "quantity": 10,
      "description": "Wodoodporne plastry do zakrywania drobnych ran na plaży.",
    },
    {
      "name": "Opatrunek hydrożelowy",
      "quantity": 2,
      "description": "Opatrunek hydrożelowy na oparzenia i otarcia.",
    },
    {
      "name": "Środek na ukąszenia owadów",
      "quantity": 1,
      "description": "Żel lub spray łagodzący swędzenie po ukąszeniach owadów.",
    },
    {
      "name": "Chusteczki odkażające",
      "quantity": 10,
      "description": "Chusteczki do szybkiej dezynfekcji skóry.",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 6,
      "description": "Tabletki przeciwbólowe i przeciwzapalne.",
    },
    {
      "name": "Krem z filtrem UV",
      "quantity": 1,
      "description":
          "Krem z wysokim filtrem SPF 30–50+ chroniący przed słońcem.",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 2,
      "description": "Rękawiczki chroniące przy zakładaniu opatrunków.",
    },
    {
      "name": "Leki przeciwhistaminowe",
      "quantity": 5,
      "description": "Tabletki na reakcje alergiczne i swędzenie.",
    },
    {
      "name": "Mała butelka wody",
      "quantity": 1,
      "description": "Woda do płukania ran i schładzania skóry.",
    },
    {
      "name": "Plastry na pęcherze",
      "quantity": 5,
      "description":
          "Specjalne plastry na pęcherze od chodzenia po gorącym piasku.",
    },
  ],
  "Apteczka samochodowa": [
    {
      "name": "Plastry",
      "quantity": 20,
      "description": "Plastry o różnych rozmiarach do zakrywania drobnych ran.",
    },
    {
      "name": "Sterylne gaziki",
      "quantity": 20,
      "description": "Gaziki do dezynfekcji i ochrony ran.",
    },
    {
      "name": "Sterylne kompresy (5×5 cm)",
      "quantity": 10,
      "description": "Kompresy do poważniejszych ran.",
    },
    {
      "name": "Bandaże elastyczne",
      "quantity": 1,
      "description": "Bandaż elastyczny do unieruchamiania i stabilizacji.",
    },
    {
      "name": "Opaska uciskowa",
      "quantity": 1,
      "description": "Opaska do tamowania krwotoku.",
    },
    {
      "name": "Chusta trójkątna/opaska na złamanie",
      "quantity": 1,
      "description": "Do unieruchamiania kończyn przy złamaniach.",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 5,
      "description": "Rękawiczki lateksowe do ochrony przed infekcją.",
    },
    {"name": "Nożyczki", "quantity": 1, "description": "Nożyczki medyczne."},
    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do usuwania ciał obcych.",
    },
    {
      "name": "Płyn/chusteczki do dezynfekcji",
      "quantity": 10,
      "description": "Środek do odkażania ran i powierzchni.",
    },
    {
      "name": "Folia NRC",
      "quantity": 1,
      "description": "Folia ratunkowa do utrzymania ciepłoty ciała.",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 10,
      "description": "Tabletki przeciwbólowe.",
    },
    {
      "name": "Leki osłonowe na żołądek",
      "quantity": 10,
      "description": "Tabletki chroniące błonę śluzową żołądka.",
    },
    {
      "name": "Tabletki na biegunkę",
      "quantity": 5,
      "description": "Tabletki na biegunkę.",
    },
    {
      "name": "Proszek elektrolitowy",
      "quantity": 2,
      "description": "Saszetki elektrolitowe do nawodnienia.",
    },
    {
      "name": "Maseczka do sztucznego oddychania",
      "quantity": 1,
      "description": "Maseczka do resuscytacji krążeniowo-oddechowej.",
    },
    {
      "name": "Okulary ochronne",
      "quantity": 1,
      "description": "Okulary zabezpieczające oczy przed zanieczyszczeniami.",
    },
    {
      "name": "Latarka/czołówka",
      "quantity": 1,
      "description": "Latarka ręczna lub czołówka do oświetlenia w ciemności.",
    },
    {
      "name": "Kamizelka odblaskowa",
      "quantity": 1,
      "description": "Kamizelka odblaskowa zwiększająca widoczność.",
    },
    {
      "name": "Trójkąt ostrzegawczy",
      "quantity": 1,
      "description": "Trójkąt do zabezpieczenia miejsca zdarzenia.",
    },
  ],
  "Apteczka rowerowa": [
    {
      "name": "Plastry",
      "quantity": 10,
      "description": "Plastry w rolce i plasterki na drobne urazy.",
    },
    {
      "name": "Sterylne kompresy",
      "quantity": 3,
      "description": "Małe kompresy do większych ran.",
    },
    {
      "name": "Bandaż elastyczny",
      "quantity": 1,
      "description": "Opaska elastyczna do unieruchamiania.",
    },
    {
      "name": "Chusteczki odkażające",
      "quantity": 5,
      "description": "Chusteczki do szybkiej dezynfekcji.",
    },
    {
      "name": "Nożyczki turystyczne",
      "quantity": 1,
      "description": "Składane nożyczki podróżne.",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 2,
      "description": "Rękawiczki do ochrony rąk.",
    },
    {
      "name": "Maść na stłuczenia",
      "quantity": 1,
      "description": "Maść chłodząca na stłuczenia.",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 5,
      "description": "Tabletki przeciwbólowe.",
    },
    {
      "name": "Plastry na odciski/pęcherze",
      "quantity": 5,
      "description": "Specjalne plastry na pęcherze.",
    },
    {
      "name": "Folia NRC",
      "quantity": 1,
      "description": "Termiczna folia ratunkowa kompaktowa.",
    },
  ],
  "Apteczka podróżna": [
    {
      "name": "Plastry",
      "quantity": 20,
      "description": "Plastry do drobnych skaleczeń.",
    },
    {
      "name": "Sterylne gaziki",
      "quantity": 10,
      "description": "Gaziki do dezynfekcji.",
    },
    {
      "name": "Sterylne kompresy",
      "quantity": 5,
      "description": "Kompresy do większych ran.",
    },
    {
      "name": "Bandaże elastyczne",
      "quantity": 1,
      "description": "Bandaż do unieruchomienia.",
    },
    {
      "name": "Chusteczki odkażające",
      "quantity": 10,
      "description": "Chusteczki do oczyszczania.",
    },
    {"name": "Nożyczki", "quantity": 1, "description": "Nożyczki medyczne."},
    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do usuwania ciał obcych.",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 4,
      "description": "Dla ochrony i higieny.",
    },
    {
      "name": "Maść przeciwzapalna",
      "quantity": 1,
      "description": "Maść na stłuczenia i skręcenia.",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 10,
      "description": "Tabletki przeciwbólowe.",
    },
    {
      "name": "Leki przeciwwymiotne",
      "quantity": 5,
      "description": "Tabletki na mdłości i wymioty.",
    },
    {
      "name": "Tabletki na biegunkę",
      "quantity": 5,
      "description": "Tabletki na biegunkę.",
    },
    {
      "name": "Tabletki do uzdatniania wody",
      "quantity": 10,
      "description": "Tabletki do oczyszczania wody.",
    },
    {
      "name": "Krople do oczu",
      "quantity": 1,
      "description": "Krople łagodzące podrażnienia oczu.",
    },
    {
      "name": "Krople do nosa",
      "quantity": 1,
      "description": "Krople na zatkany nos.",
    },
    {
      "name": "Termometr elektroniczny",
      "quantity": 1,
      "description": "Elektroniczny termometr do pomiaru temperatury.",
    },
    {
      "name": "Maść antybiotykowa",
      "quantity": 1,
      "description": "Maść z antybiotykiem do zabezpieczenia ran.",
    },
  ],
  "Apteczka sportowa": [
    {
      "name": "Plastry sportowe",
      "quantity": 10,
      "description": "Plastry dostosowane do aktywności sportowej.",
    },
    {
      "name": "Bandaż samoprzylepny",
      "quantity": 1,
      "description": "Bandaż do stabilizacji stawów.",
    },
    {
      "name": "Taśma kinesiotapingowa",
      "quantity": 1,
      "description": "Taśma do odciążenia mięśni.",
    },
    {
      "name": "Chusteczki odkażające",
      "quantity": 10,
      "description": "Chusteczki do dezynfekcji.",
    },
    {
      "name": "Maść chłodząca",
      "quantity": 1,
      "description": "Maść do łagodzenia stłuczeń.",
    },
    {
      "name": "Maść rozgrzewająca",
      "quantity": 1,
      "description": "Maść do rozgrzewania mięśni przed wysiłkiem.",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 10,
      "description": "Tabletki przeciwbólowe.",
    },
    {
      "name": "Kompresy żelowe",
      "quantity": 2,
      "description": "Kompresy żelowe na stłuczenia.",
    },
    {
      "name": "Nożyczki sportowe",
      "quantity": 1,
      "description": "Nożyczki z zaokrąglonymi końcami.",
    },
    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do precyzyjnych manipulacji.",
    },
    {
      "name": "Rękawiczki lateksowe",
      "quantity": 2,
      "description": "Rękawiczki dla higieny.",
    },
    {
      "name": "Mini termospray na stłuczenia",
      "quantity": 1,
      "description": "Spray chłodzący w wygodnej formie.",
    },
  ],
  "Apteczka codzienna": [
    {
      "name": "Plastry różnych rozmiarów",
      "quantity": 15,
      "description": "Plastry na drobne otarcia i skaleczenia.",
    },
    {
      "name": "Chusteczki dezynfekujące",
      "quantity": 10,
      "description": "Chusteczki do szybkiej dezynfekcji.",
    },
    {
      "name": "Tabletki przeciwbólowe",
      "quantity": 3,
      "description": "Tabletki na ból głowy i inne dolegliwości.",
    },
    {
      "name": "Pastylki na ból gardła",
      "quantity": 5,
      "description": "Pastylki łagodzące ból gardła.",
    },
    {
      "name": "Maść antybiotykowa",
      "quantity": 1,
      "description": "Maść do zabezpieczenia drobnych ran.",
    },
    {
      "name": "Rękawiczki jednorazowe",
      "quantity": 1,
      "description": "Para jednorazowych rękawiczek.",
    },
    {
      "name": "Bandaż elastyczny",
      "quantity": 1,
      "description": "Mały bandaż elastyczny.",
    },
    {
      "name": "Termometr jednorazowy",
      "quantity": 1,
      "description": "Jednorazowy termometr do pomiaru temperatury.",
    },
  ],
  "Apteczka domowa": [
    {
      "name": "Plastry",
      "quantity": 50,
      "description":
          "Plastry w rolce i plasterki do zatamowania drobnych krwawień.",
    },
    {
      "name": "Sterylne gaziki",
      "quantity": 50,
      "description": "Gaziki do oczyszczania ran.",
    },
    {
      "name": "Sterylne kompresy",
      "quantity": 10,
      "description": "Kompresy do opatrunków.",
    },
    {
      "name": "Bandaże elastyczne",
      "quantity": 2,
      "description": "Bandaże do stabilizacji.",
    },
    {
      "name": "Bandaże opatrunkowe",
      "quantity": 5,
      "description": "Opatrunkowe bandaże różnych rozmiarów.",
    },
    {
      "name": "Gazy jałowe",
      "quantity": 20,
      "description": "Gazy do wstępnego opatrywania ran.",
    },
    {
      "name": "Gazy niejałowe",
      "quantity": 20,
      "description": "Gazy do lekkich opatrunków.",
    },
    {
      "name": "Taśma medyczna",
      "quantity": 1,
      "description": "Taśma do mocowania opatrunków.",
    },
    {
      "name": "Chusty trójkątne",
      "quantity": 2,
      "description": "Chusty do unieruchamiania kończyn.",
    },
    {"name": "Nożyczki", "quantity": 1, "description": "Nożyczki medyczne."},
    {
      "name": "Pęseta",
      "quantity": 1,
      "description": "Pęseta do manipulacji opatrunków.",
    },
    {
      "name": "Rękawiczki lateksowe",
      "quantity": 10,
      "description": "Rękawiczki do ochrony przed zakażeniami.",
    },
    {
      "name": "Płyn do dezynfekcji",
      "quantity": 1,
      "description": "Płyn do odkażania skóry i narzędzi.",
    },
    {
      "name": "Krem antybiotykowy",
      "quantity": 1,
      "description": "Krem z antybiotykiem do leczenia ran.",
    },
    {
      "name": "Leki przeciwbólowe",
      "quantity": 20,
      "description": "Tabletki przeciwbólowe i przeciwgorączkowe.",
    },
    {
      "name": "Tabletki na biegunkę",
      "quantity": 10,
      "description": "Tabletki na biegunkę.",
    },
    {
      "name": "Termometr cyfrowy",
      "quantity": 1,
      "description": "Termometr do mierzenia temperatury.",
    },
    {
      "name": "Ampułki do płukania oczu",
      "quantity": 5,
      "description": "Ampułki do płukania oczu.",
    },
    {
      "name": "Krople do nosa",
      "quantity": 1,
      "description": "Krople na katar.",
    },
    {
      "name": "Krople do oczu",
      "quantity": 1,
      "description": "Krople na podrażnione oczy.",
    },
    {
      "name": "Tabletki do uzdatniania wody",
      "quantity": 1,
      "description": "Tabletki do oczyszczania wody w razie potrzeby.",
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
  List<Map<String, dynamic>> _items = []; // Lista elementów apteczki
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Dodaj domyślne elementy dla wybranej apteczki
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
        'quantity': 1, // Domyślna ilość
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
                maxLines: 4, // Dodano więcej miejsca na opis
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
                    Navigator.pop(context); // Zamknij menu
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
          '${widget.selectedApteczka}',
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
                                      _items[index]['image'] != null
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                            child: Image.asset(
                                              _items[index]['image'],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                          : Icon(
                                            Icons.image,
                                            color: Colors.grey,
                                            size: 50,
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
                        child: Image.asset(
                          item['image'],
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Icon(Icons.image, color: Colors.grey, size: 200),
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
