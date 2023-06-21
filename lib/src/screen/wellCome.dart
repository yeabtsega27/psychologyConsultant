// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/auth.dart';

// ignore: camel_case_types
class wellCome extends StatefulWidget {
  const wellCome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<wellCome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: appColors.gray,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    const Expanded(
                      child: Text(
                        'PSYCHOLOGICAL CONSULTATION',
                        maxLines: 2,
                        style: TextStyle(
                          color: appColors.textP,
                          fontSize: 20,
                          overflow: TextOverflow.fade,

                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      'assets/images/welcomepage.png',
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      'Convenient and affordable therapy with Better Help anytime, anywhere.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: appColors.textP,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                FilledButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const auth()));
                    },
                  style:  FilledButton.styleFrom(
                      backgroundColor: appColors.green,
                      padding: const EdgeInsets.all(16.0),
                  ),
                    child: const Text(
                      "Get started",
                      style: TextStyle(color: appColors.textW),
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
