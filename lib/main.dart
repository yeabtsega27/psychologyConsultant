import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:psychological_consultation/src/model/User.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/admin/adminBottomNavigationBar.dart';
import 'package:psychological_consultation/src/screen/end_user/bottomNavigationBar.dart';
import 'package:psychological_consultation/src/screen/psychologist/psyBottomNavigationBar.dart';
import 'package:psychological_consultation/src/screen/wellCome.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final navigatorKey = GlobalKey<NavigatorState>();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    // SessionManager().destroy();
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: SessionManager().get("user"),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Scaffold(
              backgroundColor: appColors.gray,
              body: Center(
                child: Image.asset("assets/images/logo.png",width: 200,height: 200,),
              ),
            );
          }
          if(snapshot.hasData){
            print("main dart ");
            print(snapshot.data);
            User user=User.fromJson(snapshot.data);
            onUserLogin(user.user_id,user.email);

            if(user.end_user.contains("1")){
              return const bottomNavigationBar();
            }else if (user.end_user.contains("0")){
              return psyBottomNavigationBar();
            }else{
              return adminBottomNavigationBar();
            }

          }else{
            return const wellCome();
          }
        },

      ),);
  }

  void onUserLogin(String id,String name) {
    print("zego is set $id  $name");
    ZegoUIKitPrebuiltCallInvitationService(
    ).init(
      appID: 20246501 /*input your AppID*/,
      appSign: "810515845945e66933dd3e4734cb7d91ccb4e14e252d15484ffe2cada26ba5c6" /*input your AppSign*/,
      userID: id,
      userName: name,
      plugins: [ZegoUIKitSignalingPlugin()],

    );
  }


}
