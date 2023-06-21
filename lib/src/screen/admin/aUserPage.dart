import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
class aUserPage extends StatefulWidget {
  const aUserPage({Key? key}) : super(key: key);

  @override
  State<aUserPage> createState() => _aUserPageState();
}

class _aUserPageState extends State<aUserPage> {
  String search = '';
  String psycOrderBy = "rating";

  List<String> psycOrderByList = [
    "first_name",
    "last_name",
    "rating",
  ];




  @override
  Widget build(BuildContext context) {
    getPsycList() async {
      String apiUrl = apiCon.apiMysqlQuery;

      var response = await http.post(Uri.parse(apiUrl), body: {
        'query': "SELECT * FROM `end_user`,`user` WHERE `first_name` LIKE '%$search%' AND user.user_id=end_user_id"
      });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if(jsondata['status']=="success"){
          return jsondata['message'];
        }
      }
      return null;
    }
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: appColors.whiteBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Container(
                      padding: const EdgeInsets.only(left: 5),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          suffixIcon: IconButton(onPressed: () {},
                            icon: const Icon(Icons.search),),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                bottom:BorderSide(width: 1
                                    ,color: appColors.textP),
                              ),
                          ),
                          padding: const EdgeInsets.all(5),

                          child: const Text("Users", style: TextStyle(
                              color: appColors.textP, fontSize: 16),),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if(snapshot.hasData){
                          print("snapshot data");
                          print(snapshot.data);
                          List userData = snapshot.data;
                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsetsDirectional
                                    .fromSTEB(0, 10, 0, 10),
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(35),
                                  ),
                                  child: InkWell(
                                    onTap: (){

                                    },
                                    child: Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(35),
                                        border: Border.all(
                                          color: appColors.black,
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsetsDirectional
                                            .fromSTEB(15, 5, 5, 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 20),
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: appColors.gray),
                                              child: Center(
                                                child: Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Image.network(
                                                    userData[index]['image'],
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (BuildContext context,
                                                        Object exception,
                                                        StackTrace? stackTrace) {
                                                      return Center(
                                                          child: Text(
                                                            userData[index]['email']
                                                                .substring(0, 1),
                                                            style: TextStyle(
                                                                fontSize: 50,
                                                                color: appColors.white),
                                                          ));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0,right: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Text(userData[index]['first_name']+" "+userData[index]['last_name'],style: const TextStyle(color: appColors.textP,fontSize: 16,fontWeight: FontWeight.bold),),
                                                        Text(userData[index]['email'],style: const TextStyle(color: appColors.textP),),
                                                        Text(userData[index]['phone'],style: const TextStyle(color: appColors.textP),),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [IconButton(onPressed: (){
                                                      deleteEndUser(userData[index]['end_user_id']);
                                                    }, icon: const Icon(Icons.delete_forever,size: 30,color: appColors.red,)),

                                                      Row(
                                                        children: [
                                                          userData[index]['active']=="1"?
                                                          IconButton(onPressed: (){
                                                            print("active ${userData[index]['active']}");
                                                            disableEndUser(userData[index]['end_user_id']);
                                                          }, icon: const Icon(Icons.person_off,size: 30,color: appColors.gray,)):
                                                          IconButton(onPressed: (){
                                                            enableEndUser(userData[index]['end_user_id']);
                                                          }, icon: const Icon(Icons.recycling_sharp,size: 30,color: appColors.green,)),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: userData.length,
                          );

                        }
                        return const Text("No data found");
                      }, future: getPsycList(),),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> deleteEndUser(String discussionData) async {
    print("discussionData id");
    print(discussionData);
    var response = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
      'query': "DELETE FROM `end_user` WHERE `end_user_id`=$discussionData ;"
    });
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      setState(() {
      });
      print(jsondata);
    }
  }
  Future<void> disableEndUser(String discussionData) async {
    print("discussionData id");
    print(discussionData);

    var response = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
      'query': "UPDATE `user` SET `active`='0' WHERE `user_id`=$discussionData ;"
    });
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata);
      setState(() {
      });
      print(jsondata);
    }
  }
  Future<void> enableEndUser(String discussionData) async {
    print("discussionData id");
    print(discussionData);
    var response = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
      'query': "UPDATE `user` SET `active`='1' WHERE `user_id`=$discussionData ;"
    });
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      setState(() {
      });
      print(jsondata);
    }
  }
}
