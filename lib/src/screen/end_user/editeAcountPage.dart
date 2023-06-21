import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'package:psychological_consultation/src/screen/end_user/HomePage.dart';
import 'package:psychological_consultation/src/screen/wellCome.dart';

class editeAccountPage extends StatefulWidget {
  const editeAccountPage({Key? key}) : super(key: key);

  @override
  State<editeAccountPage> createState() => _editeAccountPageState();
}

class _editeAccountPageState extends State<editeAccountPage> {
  final _firstNameTextControler = TextEditingController();
  final _lastNameTextControler = TextEditingController();
  final _phoneNameTextControler = TextEditingController();
  final _changeEmailTextControler = TextEditingController();
  final _currentPasswordTextControler = TextEditingController();
  final _newPasswordTextControler = TextEditingController();
  final _confirmPasswordTextControler = TextEditingController();
  int count = 0;

  File? _tempfile;
  String? _fileData;
  String? _fileExe;

  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _tempfile = File(result.files.single.path.toString());
        _fileExe = result.files.single.path.toString().split(".").last;
        _fileData = base64Encode(_tempfile!.readAsBytesSync());
        uploadFile();
        print("file is");
        print(_tempfile);
        print("file ext is");
        print(_fileExe);
        print('file data is');
        print(_fileData);
      });
    } else {
      // User canceled the picker
    }
  }

  uploadFile() async {
    print("uploding");
    var userId =
        await SessionManager().get('user').then((value) => value['user_id']);
    try {
      var response = await http.post(Uri.parse(apiCon.apiEndUserProfile),
          body: {'file': _fileData, 'id': userId, 'ext': _fileExe});
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == "error") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              jsonData['message'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        } else if (jsonData['status'] == "success") {
          setState(() {
            count++;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              jsonData['message'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ));
        } else {
          print('jsonData');
          print(jsonData);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  getUserInfo() async {
    var userId =
        await SessionManager().get('user').then((value) => value['user_id']);
    var respons = await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
      'query':
          "SELECT end_user.*,user.email FROM `end_user` end_user INNER JOIN `user` as user on end_user.end_user_id=user.user_id and end_user.end_user_id=$userId"
    });
    if (respons.statusCode == 200) {
      var jsonData = json.decode(respons.body);
      if (jsonData['status'].toString().contains("error")) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            jsonData['message'],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        return jsonData['message'][0];
      }
    }
    return null;
  }

  saveUserInfo() async {
    var userId =
        await SessionManager().get('user').then((value) => value['user_id']);
    var respons = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
      'query':
          "UPDATE `end_user` SET `first_name`='${_firstNameTextControler.text}',`last_name`='${_lastNameTextControler.text}',`phone`='${_phoneNameTextControler.text}',`gender`='${genderSelectedValue}' WHERE `end_user_id`=$userId"
    });
    if (respons.statusCode == 200) {
      var jsonData = json.decode(respons.body);
      if (jsonData['status'].toString().contains("error")) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            jsonData['message'],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        setState(() {
          count++;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "save change successfully",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ));
      }
    }
  }
  changEmail() async {
    print("email validation");
    print(EmailValidator.validate(_changeEmailTextControler.text, true));
    if(_changeEmailTextControler.text.isNotEmpty){
      if(EmailValidator.validate(_changeEmailTextControler.text, true)){
        var userId =
        await SessionManager().get('user').then((value) => value['user_id']);
        var respons = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
          'query':
          "UPDATE `user` SET `email`='${_changeEmailTextControler.text}' WHERE `user_id`=$userId"
        });
        if (respons.statusCode == 200) {
          var jsonData = json.decode(respons.body);
          if (jsonData['status'].toString().contains("error")) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                jsonData['message'],
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          } else {
            setState(() {
              count++;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "email change successfully",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ));
          }
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "invalid email address",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "email address is empty",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
    Navigator.pop(context);
    _changeEmailTextControler.clear();
  }
  Future<void> changPassword(String email) async {

    if(_currentPasswordTextControler.text.isNotEmpty){
      if(_newPasswordTextControler.text.isNotEmpty&&_newPasswordTextControler.text==_confirmPasswordTextControler.text){
        var response = await http.post(Uri.parse(apiCon.apiChangePassword), body: {
          'email': email,
          //get the username text
          'password': _currentPasswordTextControler.text,
          'newpassword':_newPasswordTextControler.text
          //get password text
        });
        if(response.statusCode==200){
          var jsonData=json.decode(response.body);
          if(jsonData['status'].toString()=="error"){
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(
              content: Text(
                jsonData['message'],
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }else if(jsonData['status']=="success"){
            ScaffoldMessenger.of(context).showSnackBar( SnackBar(
              content: Text(
                jsonData['message'],
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ));
          }else{
            print("response body");
            print(response.body);
          }
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "incorrect new password",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "current password can not be empty",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }

    Navigator.pop(context);
    _newPasswordTextControler.clear();
    _confirmPasswordTextControler.clear();
    _currentPasswordTextControler.clear();
  }

  List<String> gender = ['Male', "Female"];
  late String genderSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.whiteBackgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.gray,
        actions: [TextButton(onPressed: () async {
         await SessionManager().destroy();
         ZegoUIKitPrebuiltCallInvitationService().uninit();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>wellCome()), (route) => false);
        }, child: Text("log out"))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getUserInfo(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              var user = snapshot.data;
              _firstNameTextControler.text = user['first_name'];
              _lastNameTextControler.text = user['last_name'];
              _phoneNameTextControler.text = user['phone'];
              if(user['gender']=="Female"||user['gender']=="Male"){
                genderSelectedValue = user['gender'];
              }else{
                genderSelectedValue="";
              }
              var data = count;
              return ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: appColors.gray),
                            child: Center(
                              child: Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.network(
                                  user['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Center(
                                        child: Text(
                                          user['email']
                                          .substring(0, 1),
                                      style: TextStyle(
                                          fontSize: 100,
                                          color: appColors.white),
                                    ));
                                  },
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                getFile();
                              },
                              child: const Text("change profile"))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        user['email'],
                        style: TextStyle(color: appColors.textP, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {
                            changeEmail();
                          },
                          icon: Icon(
                            Icons.edit,
                            color: appColors.textP,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        "first name",
                        style: TextStyle(color: appColors.textP),
                      )),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 40,
                          decoration: BoxDecoration(
                              color: appColors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _firstNameTextControler,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                        "last name",
                        style: TextStyle(color: appColors.textP),
                      )),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 40,
                          decoration: BoxDecoration(
                              color: appColors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _lastNameTextControler,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Phone",
                            style: TextStyle(color: appColors.textP),
                          )),
                      SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 40,
                          decoration: BoxDecoration(
                              color: appColors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _phoneNameTextControler,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Gender",
                            style: TextStyle(color: appColors.textP),
                          )),
                      Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 40,
                                decoration: BoxDecoration(
                                    color: appColors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: dropdownButton(
                                  onValueChange: (String value) {
                                    genderSelectedValue=value;
                                    print(value);
                                  }, gender:genderSelectedValue,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            chanePassword(user['email']);
                          },
                          child: const Text("change Password"))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () {
                          saveUserInfo();
                        },
                        child: Text(
                          "save",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: FilledButton.styleFrom(
                            backgroundColor: appColors.green),
                      )
                    ],
                  )
                ],
              );
            } else {
              return Center(
                child: Text("No User Found"),
              );
            }
          },
        ),
      ),
    );
  }

  void changeEmail() {
    showModalBottomSheet<void>(
        context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
              height: 170,
              color: appColors.gray,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(
                            "email",
                            style: TextStyle(color: appColors.white),
                          )),
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                          decoration: BoxDecoration(
                              color: appColors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _changeEmailTextControler,
                            decoration:
                            InputDecoration(border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () {
                          changEmail();
                        },
                        child: Text(
                          "save",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: FilledButton.styleFrom(
                            backgroundColor: appColors.green),
                      )
                    ],
                  )
                ],

              ),
            ),
          );
      },

    );
  }

  void chanePassword( String email) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
            height: 290,
            color: appColors.gray,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(
                          "current password",
                          style: TextStyle(color: appColors.white),
                        )),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _currentPasswordTextControler,
                          decoration:
                          InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                        child: Text(
                          "New password",
                          style: TextStyle(color: appColors.white),
                        )),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _newPasswordTextControler,
                          decoration:
                          InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                        child: Text(
                          "confirm password",
                          style: TextStyle(color: appColors.white),
                        )),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _confirmPasswordTextControler,
                          decoration:
                          InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {
                        changPassword(email);
                      },
                      child: Text(
                        "save",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: FilledButton.styleFrom(
                          backgroundColor: appColors.green),
                    )
                  ],
                )
              ],

            ),
          ),
        );
      },

    );
  }



}

class dropdownButton extends StatefulWidget {
  final ValueChanged<String> onValueChange;
  String gender;

  dropdownButton({Key? key, required this.onValueChange,required this.gender}) : super(key: key);

  @override
  State<dropdownButton> createState() => _dropdownButtonState();
}

class _dropdownButtonState extends State<dropdownButton> {
  List<String> gender = ['Male', "Female",""];
  late String SelectedValue;
  @override
  void initState() {
    // TODO: implement initState
    SelectedValue=widget.gender;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return DropdownButton(
      value: SelectedValue,
      items: gender.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e),
        );
      }).toList(),
      onChanged: (String? value) {
        widget.onValueChange(value!);
        setState(() {
          SelectedValue = value!;
        });
      },
    );
  }
}
