import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firststep/providers/userProvider.dart';

class File {
  String id;
  String filename;
  String originalName;
  String url;
  String mimeType;
  int size;
  DateTime uploadDate;

  File({
    required this.id,
    required this.filename,
    required this.originalName,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.uploadDate,
  });

  File.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      filename = json['filename'],
      originalName = json['originalName'],
      url = json['url'],
      mimeType = json['mimeType'],
      size = json['size'],
      uploadDate = DateTime.parse(json['uploadDate']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'filename': filename,
    'originalName': originalName,
    'url': url,
    'mimeType': mimeType,
    'size': size,
    'uploadDate': uploadDate.toIso8601String(),
  };
}

class FileList {
  List<File> files;
  final WidgetRef? ref;

  FileList({required this.files, this.ref});

  FileList.fromJson(Map<String, dynamic> json, this.ref)
    : files =
          (json['files'] as List<dynamic>)
              .map((fileJson) => File.fromJson(fileJson))
              .toList();

  Map<String, dynamic> toJson() => {
    'files': files.map((file) => file.toJson()).toList(),
  };

  Future<void> fetchFiles() async {
    try {
      if (ref == null) {
        throw Exception('WidgetRef is required to fetch files');
      }

      final user = ref!.read(userProvider);
      final token = await user.getToken();

      if (token == null) {
        throw Exception('User token is required to fetch files');
      }

      final url = Uri.parse('http://localhost:3000/files');
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        files =
            responseData.map((fileJson) => File.fromJson(fileJson)).toList();
      } else {
        throw Exception('Failed to load files: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching files: $e');
      rethrow; // Rzucamy wyjątek ponownie, aby wywołujący mógł go obsłużyć
    }
  }
}
