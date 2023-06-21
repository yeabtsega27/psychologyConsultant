// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:psychological_consultation/src/component/Text_Field.dart';
import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/User.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/admin/adminBottomNavigationBar.dart';
import 'package:psychological_consultation/src/screen/end_user/bottomNavigationBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:psychological_consultation/src/screen/psychologist/psyBottomNavigationBar.dart';

// ignore: camel_case_types
class auth extends StatefulWidget {
  const auth({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _authWidgetState createState() => _authWidgetState();
}

// ignore: camel_case_types
class _authWidgetState extends State<auth> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailAddressLoginController = TextEditingController();
    final passwordLoginController = TextEditingController();
    final emailAddressController = TextEditingController();
    final passwordController = TextEditingController();
    final passwordConfirmController = TextEditingController();
    final lastNameController = TextEditingController();
    final firstNameController = TextEditingController();

    startLogin() async {
      var response = await http.post(Uri.parse(apiCon.apiLogin), body: {
        'email': emailAddressLoginController.text.trim(),
        //get the username text
        'password': passwordLoginController.text
        //get password text
      });
      print("email " + emailAddressLoginController.text);
      print("password " + passwordLoginController.text);

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'].toString().contains("error")) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              jsondata['message'],
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        }
        if (jsondata['status'].toString().contains("success")) {
          print(jsondata['message']['end_user']);
          User user = User(
              user_id: jsondata['message']['user_id'],
              email: jsondata['message']['email'],
              end_user: jsondata['message']['end_user']);
          await SessionManager().remove('user');
          await SessionManager().set('user', user);
          if (jsondata["message"]['end_user'].toString().contains("1")) {
            print("1");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const bottomNavigationBar()),
                (route) => false);
          } else if (jsondata["message"]['end_user'].toString().contains("0")) {
            print("2");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const psyBottomNavigationBar()),
                (route) => false);
          }
          else {
            print("3");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const adminBottomNavigationBar()),
                (route) => false);
          }
        }
      }
    }

    createAccount() async {

      print("email " + emailAddressController.text);
      print("password " + passwordConfirmController.text);
      print("passwordC " + passwordController.text);
      if (passwordConfirmController.text.contains(passwordController.text) &&
          firstNameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty) {
        //api url
        var response = await http.post(Uri.parse(apiCon.apiRegister), body: {
          'email': emailAddressController.text.trim(),
          //get the username text
          'password': passwordController.text,
          'end_user':"1"
          //get password text
        });
        if (response.statusCode == 200) {
          var jsondata = json.decode(response.body);
          if (jsondata['status'].toString().contains("error")) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                jsondata['message'],
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
          if (jsondata['status'].toString().contains("success")) {
            var response =
                await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
              'query':
                  "SELECT `user_id`, `email` FROM `user` WHERE `email`='${emailAddressController.text.trim()}'",
              //get password text
            });
            if (response.statusCode == 200) {
              var jsondata = json.decode(response.body);
              if (jsondata['status'].toString().contains("success")) {
                var useId=jsondata['message'][0]['user_id'];
                print("auth dart id"+useId);
                var response =
                await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
                  'query':
                  "INSERT INTO `end_user`(`end_user_id`, `first_name`, `last_name`) VALUES ($useId,'${firstNameController.text}','${lastNameController.text}')",
                  //get password text
                });
                if (response.statusCode == 200) {
                  var jsondata = json.decode(response.body);
                  if (jsondata['status'].toString().contains("success")) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "user Add successfully",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ));
                    emailAddressController.clear();
                    passwordController.clear();
                    passwordConfirmController.clear();
                    firstNameController.clear();
                    lastNameController.clear();
                    setState(() {
                      
                    });
                  }
                }
                else{
                  print('fail end_user');
                }
              }
              else{
                print("error uid");
              }

            }


          }
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "password don't match",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }


    bool _obscureTextloginpass=true;
    bool _obscureTextpassconfirm=true;
    bool _obscureTextpass=true;

    return Scaffold(
      backgroundColor: appColors.gray,
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 20),
              child: Padding(
                padding:  EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 10,),
                    const Expanded(
                      child: Text(
                        'PSYCHOLOGICAL CONSULTATION',
                        maxLines: 2,
                        style: TextStyle(
                          color: appColors.textP,
                          fontSize: 20,
                          overflow: TextOverflow.fade
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      const TabBar(
                        isScrollable: true,
                        labelColor: appColors.textP,
                        indicatorColor: appColors.green,
                        tabs: [
                          Tab(
                            text: 'Sign In',
                          ),
                          Tab(
                            text: 'Sign Up',
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  44, 0, 44, 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(0, 20, 0, 0),
                                      child: Text_Field(labletext: 'Email Address', isPassword: false, controller: emailAddressLoginController,),
                                    ),


                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(0, 12, 0, 0),
                                      child: Text_Field(labletext: 'Password', isPassword: true, controller: passwordLoginController,),
                                    ),
                                    Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 24, 0, 0),
                                        child: FilledButton(
                                          onPressed: () {
                                            startLogin();
                                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>const bottomNavigationBar()));
                                          },
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding:
                                                const EdgeInsets.all(16.0),
                                          ),
                                          child: const Text(
                                            "log In",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        )),
                                    Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 20, 0, 0),
                                        child: TextButton(
                                          onPressed: () {
                                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>const auth()));
                                          },
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding:
                                                const EdgeInsets.all(16.0),
                                          ),
                                          child: const Text(
                                            "Forgot Password",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  44, 0, 44, 0),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(bottom: 50),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(0, 20, 0, 0),
                                      child: Text_Field(
                                        labletext: 'First Name',
                                        isPassword: false,
                                        controller: firstNameController,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(0, 20, 0, 0),
                                      child: Text_Field(
                                        labletext: 'Last Name',
                                        isPassword: false,
                                        controller: lastNameController,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(0, 20, 0, 0),
                                      child: Text_Field(
                                        labletext: 'Email Address',
                                        isPassword: false,
                                        controller: emailAddressController,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(0, 12, 0, 0),
                                      child: Text_Field(
                                        labletext: 'password',
                                        isPassword: true,
                                        controller: passwordController,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(0, 12, 0, 0),
                                      child: Text_Field(
                                        labletext: 'Confirm Password',
                                        isPassword: true,
                                        controller: passwordConfirmController,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 24, 0, 0),
                                        child: FilledButton(
                                          onPressed: () {
                                            createAccount();
                                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>const auth()));
                                          },
                                          style: FilledButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding:
                                                const EdgeInsets.all(16.0),
                                          ),
                                          child: const Text(
                                            "Create Account",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
