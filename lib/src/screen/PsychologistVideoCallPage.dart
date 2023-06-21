import 'package:flutter/material.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class PsychologistVideoCallPage extends StatefulWidget {
  final String name;
  final String id;
  final String callId;

  const PsychologistVideoCallPage(
      {required this.name, required this.id,required this.callId, Key? key}) : super(key: key);

  @override
  State<PsychologistVideoCallPage> createState() =>
      _PsychologistVideoCallPageState();
}

class _PsychologistVideoCallPageState extends State<PsychologistVideoCallPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 20246501,
        appSign: "810515845945e66933dd3e4734cb7d91ccb4e14e252d15484ffe2cada26ba5c6",
        userID: widget.id,
        userName: widget.name,
        callID: widget.callId,

        // Modify your custom configurations here.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
            foregroundBuilder: (BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
              return user != null
                  ? Positioned(
                bottom: 5,
                left: 5,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://your_server/app/avatar/${user.id}.png',
                      ),
                    ),
                  ),
                ),
              )
                  : const SizedBox();
            },
          ),
      ),
    );
  }
}
