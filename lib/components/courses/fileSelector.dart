import 'package:firststep/models/files.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' as io; // Alias dla dart:io File
import 'dart:typed_data';

class FileCard extends StatefulWidget {
  const FileCard({super.key, required this.file, this.onTap});

  final File file;
  final VoidCallback? onTap;

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  VideoPlayerController? videoPlayerController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.file.mimeType == 'video/mp4') {
      videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.file.url),
        )
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
          });
        });
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 150,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Zawartość karty
              widget.file.mimeType == 'video/mp4'
                  ? _isInitialized && videoPlayerController != null
                      ? AspectRatio(
                        aspectRatio: videoPlayerController!.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController!),
                      )
                      : const Center(child: CircularProgressIndicator())
                  : widget.file.mimeType == 'image/png' ||
                      widget.file.mimeType == 'image/jpeg'
                  ? Image.network(widget.file.url, fit: BoxFit.cover)
                  : Icon(Icons.error, color: Colors.black),

              // Przezroczysta warstwa do przechwytywania dotknięć
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FileSelector extends ConsumerWidget {
  const FileSelector({super.key, this.onFileSelected});

  // Callback do przekazania wybranego pliku
  final void Function(File)? onFileSelected;

  Future<File?> _showAlert(BuildContext context, WidgetRef ref) async {
    // Pokaż dialog z ładowaniem
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Ładowanie plików...'),
            ],
          ),
        );
      },
    );

    // Pobierz pliki
    FileList fileList = FileList(files: [], ref: ref);
    try {
      await fileList.fetchFiles();

      // Zamknij dialog ładowania
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Pokaż dialog z plikami
      if (context.mounted) {
        final result = await showDialog<File>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 44, 44, 44),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              contentTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              title: const Text('Wybierz plik'),
              content: Stack(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child:
                        fileList.files.isEmpty
                            ? const Center(
                              child: Text('Brak dostępnych plików'),
                            )
                            : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 1.0,
                                  ),
                              itemCount: fileList.files.length,
                              itemBuilder: (context, index) {
                                return FileCard(
                                  file: fileList.files[index],
                                  onTap: () {
                                    print(
                                      "Plik wybrany: ${fileList.files[index].filename}",
                                    );
                                    Navigator.of(
                                      context,
                                    ).pop(fileList.files[index]);
                                  },
                                );
                              },
                            ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      // Otwieramy selektora plików
                      final result = await FilePicker.platform.pickFiles(
                        type:
                            FileType
                                .media, // Ograniczamy do mediów (obrazów i wideo)
                        allowMultiple: false,
                      );

                      if (result != null && result.files.isNotEmpty) {
                        // Pokazujemy dialog z informacją o przesyłaniu
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              backgroundColor: Color.fromARGB(255, 44, 44, 44),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text(
                                    'Przesyłanie pliku...',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        final token = await ref.read(userProvider).getToken();

                        if (token == null || token.isEmpty) {
                          if (context.mounted) {
                            Navigator.of(
                              context,
                            ).pop(); // Zamykamy dialog ładowania
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nie jesteś zalogowany.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          return;
                        }

                        // Przesyłamy plik używając Dio
                        final file = result.files.first;
                        final bytes = file.bytes;
                        final fileName = file.name;
                        final mimeType = _getMimeType(fileName);

                        // Jeśli nie mamy bajtów ale mamy ścieżkę pliku, musimy wczytać plik
                        final filePath = file.path;
                        Uint8List? fileBytes;

                        if (bytes != null) {
                          fileBytes = bytes;
                        } else if (filePath != null) {
                          // Odczytujemy plik z dysku
                          fileBytes = await io.File(filePath).readAsBytes();
                        }

                        if (fileBytes == null) {
                          if (context.mounted) {
                            Navigator.of(
                              context,
                            ).pop(); // Zamykamy dialog ładowania
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nie udało się odczytać pliku.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          return;
                        }

                        // Tworzymy FormData do wysłania pliku
                        final formData = FormData.fromMap({
                          'file': MultipartFile.fromBytes(
                            fileBytes,
                            filename: fileName,
                            contentType: MediaType.parse(mimeType),
                          ),
                        });

                        // Wysyłamy plik
                        final dio = Dio();
                        final response = await dio.post(
                          '${dotenv.env['SERVER_URL']!}/files/upload',
                          data: formData,
                          options: Options(
                            headers: {
                              'Authorization':
                                  token.startsWith('Bearer ')
                                      ? token
                                      : 'Bearer $token',
                              'accept': 'application/json',
                            },
                          ),
                        );

                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pop(); // Zamykamy dialog ładowania
                        }

                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          // Plik został przesłany pomyślnie
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Plik został pomyślnie przesłany!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Zamykamy dialog ładowania
                            Navigator.of(
                              context,
                            ).pop(); // Zamykamy dialog wyboru pliku

                            // Odświeżamy listę plików i pokazujemy nowy dialog z odświeżoną listą
                            if (context.mounted) {
                              // Krótkie opóźnienie, aby API mogło przetworzyć plik
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );

                              // Pobieramy nowo dodany plik z API
                              final uploadedFileData = response.data;
                              debugPrint(
                                'Upload response data: $uploadedFileData',
                              );

                              // Otwieramy dialog z odświeżoną listą plików
                              final selectedFile = await _showAlert(
                                context,
                                ref,
                              );
                              if (selectedFile != null &&
                                  onFileSelected != null) {
                                onFileSelected!(selectedFile);
                              }
                            }
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Błąd podczas przesyłania pliku: ${response.statusCode}',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).pop(); // Zamykamy dialog ładowania jeśli jest otwarty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Wystąpił błąd: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      debugPrint('Błąd przesyłania pliku: $e');
                    }
                  },
                  child: const Text(
                    'Prześlij nowy plik',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Anuluj',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
        return result;
      }
    } catch (e) {
      // Zamknij dialog ładowania
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Pokaż dialog z błędem
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Błąd'),
              content: Text('Nie udało się załadować plików: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if (onFileSelected != null) {
    //   Navigator.of(context).pop(onFileSelected);
    // }
    return ListTile(
      leading: const Icon(Icons.video_library, color: Colors.white),
      title: const Text(
        'Plik (Zdjęcie/Wideo)',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () async {
        final selectedFile = await _showAlert(context, ref);
        if (selectedFile != null && onFileSelected != null) {
          onFileSelected!(selectedFile);
        }
      },
    );
  }
}

String _getMimeType(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'mp4':
      return 'video/mp4';
    default:
      return 'application/octet-stream';
  }
}
