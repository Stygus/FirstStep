import 'package:firststep/components/courses/videoFullScreen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ControlsOverlay extends StatefulWidget {
  const ControlsOverlay({
    super.key,
    required this.controller,
    required this.videoUrl,
  });

  final String videoUrl;

  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  State<ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  bool _showVolumeSlider = false;
  bool _needsReinitialize = false;
  bool _forceHidePlayIcon = false;

  @override
  void initState() {
    super.initState();
    // Dodajemy listener do kontrolera, aby aktualizować UI gdy zmieni się stan odtwarzania
    widget.controller.addListener(_videoControllerListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_videoControllerListener);
    super.dispose();
  }

  void _videoControllerListener() {
    if (mounted) {
      setState(() {
        // Ten setState wymusza odświeżenie UI gdy zmieni się stan kontrolera
      });
    }
  }

  // Funkcja do ponownej inicjalizacji kontrolera
  Future<void> _reinitializeController() async {
    final wasPlaying = widget.controller.value.isPlaying;
    final position = widget.controller.value.position;
    final volume = widget.controller.value.volume;
    final playbackSpeed = widget.controller.value.playbackSpeed;

    // Tymczasowo ukrywamy ikonę play podczas reinicjalizacji
    setState(() {
      _forceHidePlayIcon = true;
    });

    if (wasPlaying) {
      await widget.controller.pause();
    }

    // Wymuszamy reinicjalizację kontrolera
    await widget.controller.initialize();

    // Przywracamy wszystkie poprzednie ustawienia
    await widget.controller.setVolume(volume);
    await widget.controller.setPlaybackSpeed(playbackSpeed);
    await widget.controller.seekTo(position);

    // Przywracamy stan odtwarzania
    if (wasPlaying) {
      await widget.controller.play();
    }

    // Ponownie pokazujemy ikonę play jeśli wideo jest zatrzymane
    setState(() {
      _forceHidePlayIcon = false;
    });
  }

  // Funkcja wywoływana po powrocie z trybu pełnoekranowego
  void _onReturnFromFullScreen() async {
    // Wymuszamy reinicjalizację kontrolera
    await _reinitializeController();
  }

  @override
  Widget build(BuildContext context) {
    // Jeśli potrzebna jest reinicjalizacja, wykonaj ją
    if (_needsReinitialize) {
      _needsReinitialize = false;
      Future.delayed(Duration.zero, _reinitializeController);
    }

    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child:
              (widget.controller.value.isPlaying || _forceHidePlayIcon)
                  ? const SizedBox.shrink()
                  : const ColoredBox(
                    color: Colors.black26,
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                  ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.controller.value.isPlaying
                  ? widget.controller.pause()
                  : widget.controller.play();
            });
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.black54,
                ),
                child: IconButton(
                  icon: const Icon(Icons.fullscreen, color: Colors.white),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FullScreenedVideo(
                              videoUrl: widget.videoUrl,
                              controller: widget.controller,
                            ),
                      ),
                    );

                    // Po powrocie z trybu pełnoekranowego
                    setState(() {
                      _needsReinitialize = true;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                              child: Slider(
                                value: widget.controller.value.volume,
                                min: 0.0,
                                max: 1.0,
                                divisions: 10,
                                onChanged: (value) {
                                  setState(() {
                                    widget.controller.setVolume(value);
                                  });
                                },
                              ),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.volume_up,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (widget.controller.value.volume == 0.0) {
                                widget.controller.setVolume(1.0);
                              } else {
                                widget.controller.setVolume(0.0);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: widget.controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              widget.controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed
                    in ControlsOverlay._examplePlaybackRates)
                  PopupMenuItem<double>(value: speed, child: Text('${speed}x')),
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${widget.controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
