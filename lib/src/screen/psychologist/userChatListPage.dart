import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'dart:convert';

import 'package:psychological_consultation/src/component/ratingStar.dart';
import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/PsychologistChatPage.dart';
import 'package:psychological_consultation/src/screen/PsychologistVideoCallPage.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
class userChatListPage extends StatefulWidget {
  const userChatListPage({Key? key}) : super(key: key);

  @override
  State<userChatListPage> createState() => _userChatListPageState();
}

class _userChatListPageState extends State<userChatListPage> {
  String search = '';
  String psycOrderBy = "rating";

  List<String> psycOrderByList = [
    "first_name",
    "last_name",
    "rating",
  ];

  String userId="";
  String userName="";
  getUserInf()async {
    userId=await SessionManager().get("user").then((value) => value["user_id"]);
    userName=await SessionManager().get("user").then((value) => value["email"]);
    setState(() {

    });
  }
  @override
  void initState() {
    getUserInf();
    // TODO: implement initState
    super.initState();
  }

  getUserInfo(String id) async {
    //api url

    var response = await http.post(Uri.parse(apiCon.apiMysqlQuery),
        body: {'query': "SELECT * FROM `user` WHERE user_id=$id;"});
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata['status'].toString().contains("success")) {
        if (jsondata['message']['end_user'].toString().contains("1")) {
          var response = await http.post(Uri.parse(apiCon.apiMysqlQuery),
              body: {
                'query': "SELECT * FROM `end_user` WHERE end_user_id=$id;"
              });
          var jsondata = json.decode(response.body);
          if (jsondata['status'].toString().contains("success")) {
            return jsondata['message'];
          }
        } else if (jsondata['message']['end_user'].toString().contains("2")) {
          var response = await http.post(Uri.parse(apiCon.apiMysqlQuery),
              body: {
                'query': "SELECT * FROM `psychology` WHERE psychology_id=$id;"
              });
          var jsondata = json.decode(response.body);
          if (jsondata['status'].toString().contains("success")) {
            return jsondata['message'][0];
          }
        } else {
//Todo admin
        }
      }
    } else {
      throw Exception('Failed to load post');
    }
    return null;
  }

  getUserType(String id) async {
    var response = await http.post(Uri.parse(apiCon.apiMysqlQuery),
        body: {'query': "SELECT * FROM `user` WHERE user_id=$id;"});
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata['status'].toString().contains("success")) {
        return "User";
      } else if (jsondata['message']['end_user'].toString().contains("2")) {
        return "Psychologist";
      } else {
        return "Admin";
      }
    } else {
      throw Exception('Failed to load post');
    }
  }


  Future<void> sendMessage( String id,) async {
    print("send message");
    var sendeUserId =
    await SessionManager().get('user').then((value) => value['user_id']);
    print("sending massage");
    print(id);
    print(sendeUserId);
    var response= await http.post(Uri.parse(apiCon.apiMysqlInsert),body: {
      'query':
      "INSERT INTO `message`( `sender_id`, `reciver_id`, `content` ,`type`) VALUES ($sendeUserId,${id},'call','call')"
    });

    if(response.statusCode==200){
      var jsondata=json.decode(response.body);
      if(jsondata['status'].toString().contains("error")){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            jsondata['message'],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
      if(jsondata['status'].toString().contains("success")){

      }
    }
  }




  @override
  Widget build(BuildContext context) {
    getPsycList() async {
      String apiUrl = apiCon.apiMysqlQuery;

      var userId = await SessionManager()
          .get('user')
          .then((value) => value['user_id']);

      var response = await http.post(Uri.parse(apiUrl), body: {
        'query': "SELECT * FROM `end_user` WHERE `end_user_id` in(SELECT (CASE WHEN message.sender_id='$userId' THEN (message.reciver_id ) ELSE (message.sender_id) END) as id FROM `message` message,`end_user` end_user WHERE (message.reciver_id = '$userId' or message.sender_id='$userId') GROUP BY id)"
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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1
                                    ,color: appColors.textP),
                              )
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
                                      PersistentNavBarNavigator.pushNewScreen(context, screen: PsychologistChatPage(userData[index]['end_user_id'],userData[index]['first_name']+" "+userData[index]['last_name']),withNavBar: false);
                                    },
                                    child: Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(35),
                                        border: Border.all(
                                          color: const Color(0xFFFFFCFC),
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
                                                            userData[index]['first_name']
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
                                                        // Text(userData[index]['email'],style: const TextStyle(color: appColors.textP),),
                                                        Text(userData[index]['phone'],style: const TextStyle(color: appColors.textP),),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Expanded(child:  ZegoSendCallInvitationButton(
                                                        buttonSize: Size(50,50),
                                                        onPressed: (code ,message, List<String> a){
                                                          sendMessage(userData[index]['end_user_id']);
                                                        },
                                                        iconSize: Size(45,45),
                                                        isVideoCall: true,
                                                        resourceID: "zegouikit_call",    // For offline call notification
                                                        invitees: [
                                                          ZegoUIKitUser(
                                                            id: userData[index]['end_user_id'],
                                                            name: userData[index]['first_name'],

                                                          ),
                                                        ],
                                                      )),
                                                      Expanded(
                                                        child: IconButton(onPressed: (){
                                                          PersistentNavBarNavigator.pushNewScreen(context, screen: PsychologistChatPage(userData[index]['end_user_id'],userData[index]['first_name']+" "+userData[index]['last_name']),withNavBar: false);
                                                        }, icon: const Icon(Icons.message,size: 30,color: appColors.gray,)),
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
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("No User Chat Found",style: TextStyle(color: appColors.textP),),
                          ],
                        );
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
}
