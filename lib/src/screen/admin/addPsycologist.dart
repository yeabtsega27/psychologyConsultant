import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:psychological_consultation/src/component/Text_Field.dart';
import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';

class addPsycologist extends StatefulWidget {
  const addPsycologist({Key? key}) : super(key: key);

  @override
  State<addPsycologist> createState() => _addPsycologistState();
}

class _addPsycologistState extends State<addPsycologist> {
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _firstNameTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _phoneTextEditingController = TextEditingController();
  String selectedGender = "";
  String end_user = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.whiteBackgroundColor,
        title: const Text("Add new psychologist",
            style: TextStyle(color: appColors.textP, fontSize: 18)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: appColors.textP,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text_Field(
                labletext: "First Name",
                isPassword: false,
                controller: _firstNameTextEditingController),
            Text_Field(
                labletext: "Last Name",
                isPassword: false,
                controller: _lastNameTextEditingController),
            Text_Field(
                labletext: "Email",
                isPassword: false,
                controller: _emailTextEditingController),
            Row(
              children: [
                Text("Gender"),
                genderDropdown(
                  selectedGender: selectedGender,
                  onChange: (String value) {
                    selectedGender = value;
                  },
                )
              ],
            ),
            Text_Field(
                labletext: "Phone Number",
                isPassword: false,
                controller: _phoneTextEditingController),
            Text_Field(
                labletext: "Password",
                isPassword: true,
                controller: _passwordTextEditingController),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    addPSy();
                  },
                  child: Text("Add"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> addPSy() async {
    if(EmailValidator.validate(_emailTextEditingController.text.trim())&&_passwordTextEditingController.text.length>=6){

      final response = await http.post(Uri.parse(apiCon.apiRegister), body: {
        "email":_emailTextEditingController.text.trim(),
        "password":_passwordTextEditingController.text,
        "end_user":end_user
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          var response =
          await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
            'query':
            "SELECT `user_id`, `email` FROM `user` WHERE `email`='${_emailTextEditingController.text.trim()}'",
            //get password text
          });
          if (response.statusCode == 200) {
            var jsondata = json.decode(response.body);
            if (jsondata['status'].toString().contains("success")) {
              var useId=jsondata['message'][0]['user_id'];
              print("auth dart id"+useId);
              var respons2=await http.post(Uri.parse(apiCon.apiMysqlInsert),body: {
                "query":"INSERT INTO `psychology`(`psychology_id`, `first_name`, `last_name`, `phone`, `gender`) VALUES ('$useId','${_firstNameTextEditingController.text}','${_lastNameTextEditingController.text}','${_phoneTextEditingController.text}','$selectedGender')"
              });
              if(respons2.statusCode==200){
                var jsonData2=json.decode(respons2.body);
                print("user id $useId");
                if(jsonData2['status']=="success"){
                  await ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("user added successfully"),
                        backgroundColor: appColors.green,
                      )
                  );
                  Navigator.pop(context);
                }else if(jsonData2['status']=="error"){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(jsonData2['massage']),
                        backgroundColor: appColors.red,
                      )
                  );
                }
              }
            }
            else{
              print("error uid");
            }

          }



        } else if (jsonData['status'] == 'error') {
          ScaffoldMessenger.of(context)
              .showSnackBar(
              SnackBar(
                  content: Text(jsonData['message'],style: TextStyle(color: appColors.white),),
                backgroundColor: appColors.red,
              )
          );
        }
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
         content: Text("email or password is incorrect",style: TextStyle(color:appColors.white),),
         backgroundColor: appColors.red,
        )
      );
    }
  }
}

class genderDropdown extends StatefulWidget {
  String selectedGender;
  ValueChanged<String> onChange;

  genderDropdown(
      {required this.selectedGender, required this.onChange, Key? key})
      : super(key: key);

  @override
  State<genderDropdown> createState() => _genderDropdownState();
}

class _genderDropdownState extends State<genderDropdown> {
  List<String> gender = ["Male", "Female", ""];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: widget.selectedGender,
        items: gender.map((e) {
          return DropdownMenuItem(
            child: Text(e.toString()),
            value: e.toString(),
          );
        }).toList(),
        onChanged: (v) {
          setState(() {
            widget.onChange.call(v.toString());
            widget.selectedGender = v.toString();
          });
        });
  }
}
