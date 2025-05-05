import 'package:flutter/material.dart';
import 'dart:io';

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
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1D1D1D),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Zdjęcie elementu
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
                                    SizedBox(width: 16),
                                    // Nazwa elementu
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
                                    // Dodawanie i odejmowanie ilości
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
                                    // Przycisk usuwania
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
              child: Text('Dodaj element'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.medical_services, color: Colors.red, size: 50),
                SizedBox(height: 16),
                item['image'] != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        item['image'],
                        width: 200,
                        height: 200,
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
    );
  }
}
