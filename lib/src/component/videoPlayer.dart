

// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, no_logic_in_create_state

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';


class videoPlayer extends StatefulWidget {
  String Url;
  videoPlayer({ required this.Url, Key? key}) : super(key: key);

  @override
  State<videoPlayer> createState() => _videoPlayerState(Url);
}

class _videoPlayerState extends State<videoPlayer> {

  late FlickManager flickManager;
  String url;
  _videoPlayerState(this.url);
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(url),
      autoPlay: false
    );
  }
  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickManager.flickControlManager?.pause(); //pausing  functionality
        }
      },
      child: FlickVideoPlayer(
        flickVideoWithControls: const FlickVideoWithControls(
          videoFit: BoxFit.fill,
          controls: playerControls(),
        ),
          flickManager: flickManager
      ),
    );
  }
}




/// Default portrait controls.
class playerControls extends StatelessWidget {
  const playerControls(
      {Key? key,
        this.iconSize = 20,
        this.fontSize = 12,
        this.progressBarSettings})
      : super(key: key);

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [FlickProgressBarSettings] settings.
  final FlickProgressBarSettings? progressBarSettings;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: FlickPlayToggle(
                      size: 30,
                      color: Colors.black,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlickSoundToggle(
                        size: iconSize,
                      ),
                      Row(
                        children: <Widget>[
                          FlickCurrentPosition(
                            fontSize: fontSize,
                          ),
                          FlickAutoHideChild(
                            child: Text(
                              ' / ',
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize),
                            ),
                          ),
                          FlickTotalDuration(
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

