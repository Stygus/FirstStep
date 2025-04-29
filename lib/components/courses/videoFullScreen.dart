import 'package:firststep/components/courses/videoControls.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenedVideo extends StatefulWidget {
  const FullScreenedVideo({
    super.key,
    required this.videoUrl,
    required this.controller,
  });

  final String videoUrl;
  final VideoPlayerController controller;

  @override
  State<FullScreenedVideo> createState() => _FullScreenedVideoState();
}

class _FullScreenedVideoState extends State<FullScreenedVideo> {
  late VideoPlayerController controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    // Sprawdź, czy kontroler jest już zainicjalizowany
    if (controller.value.isInitialized) {
      setState(() {
        _isInitialized = true;
      });
    } else {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
      // Nie uruchamiamy automatycznie odtwarzania wideo
      // controller.play(); - usuwamy tę linię
    });
  }

  @override
  void dispose() {
    // Nie wywołujemy controller.dispose() ponieważ kontroler jest współdzielony z widokiem głównym
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Przechwytujemy gesty systemowe wyjścia (np. przycisk "wstecz" na Androidzie)
      onWillPop: () async {
        // Wymuszamy prawidłowy stan kontrolera wideo przed zamknięciem ekranu
        if (mounted) {
          // Tu możemy przygotować kontroler na powrót do małego widoku
          final wasPlaying = controller.value.isPlaying;
          final position = controller.value.position;

          // Zachowujemy te dane dla małego widoku
          return true; // Zezwalamy na wyjście z ekranu
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body:
            _isInitialized
                ? Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        VideoPlayer(controller),
                        FullScreeenedControls(
                          controller: controller,
                          onExitFullScreen: () {
                            // Przed zamknięciem zapewniamy, że mały widok będzie wiedział o aktualnym stanie
                            Navigator.of(context).pop();
                          },
                        ),
                        VideoProgressIndicator(
                          controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: Colors.green,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

/// Komponent kontrolek dla trybu pełnoekranowego
class FullScreeenedControls extends StatefulWidget {
  const FullScreeenedControls({
    super.key,
    required this.controller,
    required this.onExitFullScreen,
  });

  final VideoPlayerController controller;
  final VoidCallback onExitFullScreen;

  @override
  State<FullScreeenedControls> createState() => _FullScreeenedControlsState();
}

class _FullScreeenedControlsState extends State<FullScreeenedControls> {
  bool _showVolumeSlider = false;
  double _playbackRate = 1.0;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _playbackRate = widget.controller.value.playbackSpeed;

    // Dodajemy listener do kontrolera, aby reagować na zmiany jego stanu
    _listener = () {
      if (mounted) {
        setState(() {
          // Ten pusty setState wymusza odświeżenie widoku gdy zmienia się stan kontrolera
        });
      }
    };
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    // Ważne: usuwamy listener przy usuwaniu widgetu
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  // Funkcja do bezpiecznego wyjścia z trybu pełnoekranowego
  void _exitFullScreen(BuildContext context) async {
    // Wychodzimy z trybu pełnoekranowego
    widget.onExitFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit:
          StackFit
              .expand, // Upewniamy się, że Stack zajmuje całą dostępną przestrzeń
      children: <Widget>[
        // Przycisk głośności z pionowym sliderem
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.black54,
            ),
            child: MouseRegion(
              onEnter: (_) => setState(() => _showVolumeSlider = true),
              onExit: (_) => setState(() => _showVolumeSlider = false),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_showVolumeSlider)
                    Container(
                      height: 180,
                      width: 20,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 6.0,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 10.0,
                            ),
                          ),
                          child: Slider(
                            value: _playbackRate,
                            min: 0.25,
                            max: 2.0,
                            divisions: 7,
                            onChanged: (value) {
                              setState(() {
                                _playbackRate = value;
                                widget.controller.setPlaybackSpeed(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),

        // Przycisk play/pause na środku ekranu - reaguje na całą powierzchnię
        GestureDetector(
          behavior:
              HitTestBehavior
                  .translucent, // Pozwala na obsługę dotyku na całym obszarze
          onTap: () {
            setState(() {
              if (widget.controller.value.isPlaying) {
                widget.controller.pause();
              } else {
                widget.controller.play();
              }
            });
          },
          child: Center(
            child: AnimatedOpacity(
              opacity: widget.controller.value.isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),

        // Przycisk wyjścia z trybu pełnoekranowego
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
            onPressed: () => _exitFullScreen(context),
          ),
        ),

        // Informacja o prędkości odtwarzania
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${_playbackRate}x',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
