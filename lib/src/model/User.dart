// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter_session_manager/flutter_session_manager.dart';
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

import 'package:psychological_consultation/src/screen/end_user/HomePage.dart';
import 'package:psychological_consultation/src/screen/wellCome.dart';


class User {
  final String user_id;
  final String email;
  final String end_user ;

  User( {required this.end_user, required this.user_id, required this.email});

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["user_id"] = user_id;
    user["email"] = email;
    user["end_user"] = end_user;
    return user;
  }
  static User fromJson(json)=>User(
      user_id: json['user_id'],
      email: json['email'],
    end_user: json['end_user']
  );
  static void saveUserInfo(BuildContext context,TextEditingController _firstNameTextControler,TextEditingController _lastNameTextControler,TextEditingController _phoneNameTextControler,String genderSelectedValue) async {
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


  static void changEmail(BuildContext context,TextEditingController _changeEmailTextControler) async {
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
  static  void changeEmaill( BuildContext context,TextEditingController _changeEmailTextControler) {
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
                        User.changEmail(context,_changeEmailTextControler);
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


  static  Future<void> changPasswordd(String email,BuildContext context,TextEditingController _currentPasswordTextControler,TextEditingController _newPasswordTextControler,TextEditingController _confirmPasswordTextControler) async {

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


  void chanePassword( String email,BuildContext context,TextEditingController _currentPasswordTextControler,TextEditingController _newPasswordTextControler,TextEditingController _confirmPasswordTextControler) {
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
                        User.changPasswordd(email,context,_currentPasswordTextControler,_newPasswordTextControler,_confirmPasswordTextControler);
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

