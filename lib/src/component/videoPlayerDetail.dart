// ignore_for_file: non_constant_identifier_names

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';


// ignore: camel_case_types, must_be_immutable
class videoPlayerDetail extends StatefulWidget {
  String Url;
  videoPlayerDetail({ required this.Url, Key? key}) : super(key: key);

  @override
  State<videoPlayerDetail> createState() => _videoPlayerDetailState();
}

// ignore: camel_case_types
class _videoPlayerDetailState extends State<videoPlayerDetail> {

  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController:
        VideoPlayerController.network(widget.Url),
        autoPlay: true
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
            videoFit: BoxFit.fitWidth,
            controls: FlickPortraitControls(),
          ),
          flickManager: flickManager
      ),
    );
  }
}




/// Default portrait controls.
// class playerControls extends StatelessWidget {
//   const playerControls(
//       {Key? key,
//         this.iconSize = 20,
//         this.fontSize = 12,
//         this.progressBarSettings})
//       : super(key: key);
//
//   /// Icon size.
//   ///
//   /// This size is used for all the player icons.
//   final double iconSize;
//
//   /// Font size.
//   ///
//   /// This size is used for all the text.
//   final double fontSize;
//
//   /// [FlickProgressBarSettings] settings.
//   final FlickProgressBarSettings? progressBarSettings;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Positioned.fill(
//           child: FlickShowControlsAction(
//             child: FlickSeekVideoAction(
//               child: Center(
//                 child: FlickVideoBuffer(
//                   child: FlickAutoHideChild(
//                     showIfVideoNotInitialized: false,
//                     child: FlickPlayToggle(
//                       size: 30,
//                       color: Colors.black,
//                       padding: EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white70,
//                         borderRadius: BorderRadius.circular(40),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Positioned.fill(
//           child: FlickAutoHideChild(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       FlickPlayToggle(
//                         size: iconSize,
//                       ),
//                       ,
//                       FlickSoundToggle(
//                         size: iconSize,
//                       ),
//                       Row(
//                         children: <Widget>[
//                           FlickCurrentPosition(
//                             fontSize: fontSize,
//                           ),
//                           FlickAutoHideChild(
//                             child: Text(
//                               ' / ',
//                               style: TextStyle(
//                                   color: Colors.white, fontSize: fontSize),
//                             ),
//                           ),
//                           FlickTotalDuration(
//                             fontSize: fontSize,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

