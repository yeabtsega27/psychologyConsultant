import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:psychological_consultation/src/model/appColors.dart';

import '../wellCome.dart';

class editeAccountPage extends StatefulWidget {
  const editeAccountPage({Key? key}) : super(key: key);

  @override
  State<editeAccountPage> createState() => _editeAccountPageState();
}

class _editeAccountPageState extends State<editeAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.primeryColor,

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

        ],
      ),
    );
  }
}
