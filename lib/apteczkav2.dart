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

  void _addItem() {
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      setState(() {
        _items.add({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'image': 'assets/images/logod.png',
        });
        _nameController.clear();
        _descriptionController.clear();
      });
    }
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
                            return ListTile(
                              onTap: () => _viewItemDetails(_items[index]),
                              leading:
                                  _items[index]['image'] != null
                                      ? Image.asset(
                                        _items[index]['image'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                      : Icon(Icons.image, color: Colors.grey),
                              title: Text(
                                _items[index]['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                _items[index]['description'],
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeItem(index),
                              ),
                            );
                          },
                        ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Nazwa elementu',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Color(0xFF1D1D1D),
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
                  decoration: InputDecoration(
                    hintText: 'Opis elementu',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Color(0xFF1D1D1D),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Dodaj'),
                ),
              ],
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
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text('Edytuj'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      label: Text('Powrót'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
