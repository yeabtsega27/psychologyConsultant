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
import 'package:rating_dialog/rating_dialog.dart';
class PsychologistPage extends StatefulWidget {
  const PsychologistPage({Key? key}) : super(key: key);

  @override
  State<PsychologistPage> createState() => _PsychologistPageState();
}

class _PsychologistPageState extends State<PsychologistPage> {


  // show the dialog

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

  getPsycList() async {
    String apiUrl = apiCon.apiMysqlQuery;
    var response = await http.post(Uri.parse(apiUrl), body: {
      'query':
      "SELECT * FROM `psychology`,`user` WHERE `first_name` LIKE '%$search%' AND user.user_id=psychology.psychology_id"
    });

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      return jsondata['message'];
    }
    return null;
  }

  @override
  void initState() {
    getUserInf();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("user id $userId");
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
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: appColors.textP
                                )
                            ),
                          ),
                          padding: const EdgeInsets.all(5),

                          child: const Text("Psychologist", style: TextStyle(
                              color: appColors.textP, fontSize: 17),),
                        ),
                        DropdownButton(
                            value: psycOrderBy,
                            items: psycOrderByList.map((e) {
                              return DropdownMenuItem(
                                  value: e, child: Text(e));
                            }).toList(), onChanged: (n) {
                          setState(() {
                            psycOrderBy = n as String;
                          });
                        })
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
                          if(snapshot.data.runtimeType.toString()=="String"){
                            return const Text("No user exist");
                          }
                          List psychologyData = snapshot.data;
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
                                      PersistentNavBarNavigator.pushNewScreen(context, screen: PsychologistChatPage(psychologyData[index]['psychology_id'],psychologyData[index]['first_name']+" "+psychologyData[index]['last_name']),withNavBar: false);
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
                                                    psychologyData[index]['image'],
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (BuildContext context,
                                                        Object exception,
                                                        StackTrace? stackTrace) {
                                                      return Center(
                                                          child: Text(
                                                            psychologyData[index]['email']
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
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        Text(
                                                          psychologyData[index][
                                                          'first_name'] +
                                                              " " +
                                                              psychologyData[
                                                              index]
                                                              ['last_name'],
                                                          style: const TextStyle(
                                                              color: appColors
                                                                  .textP,fontSize: 16,fontWeight: FontWeight.bold),
                                                        ),
                                                        Text(
                                                          psychologyData[index][
                                                          'email'] ,
                                                          style: const TextStyle(
                                                              color: appColors
                                                                  .textP),
                                                        ),
                                                        InkWell(
                                                          onTap:(){
                                                            rated(psychologyData[index]["psychology_id"]);
                                                          },
                                                          child: ratingStar(
                                                              rate:
                                                              psychologyData[
                                                              index]
                                                              ['rating']),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: ZegoSendCallInvitationButton(
                                                          buttonSize: Size(50,50),
                                                          onPressed: (code ,message, List<String> a){
                                                            sendMessage(psychologyData[index]['psychology_id']);
                                                          },
                                                          iconSize: Size(45,45),
                                                          isVideoCall: true,
                                                          resourceID: "zegouikit_call",    // For offline call notification
                                                          invitees: [
                                                            ZegoUIKitUser(
                                                              id: psychologyData[index]['psychology_id'],
                                                              name: psychologyData[index]['first_name'],

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: IconButton(onPressed: (){
                                                          PersistentNavBarNavigator.pushNewScreen(context, screen: PsychologistChatPage(psychologyData[index]['psychology_id'],psychologyData[index]['first_name']+" "+psychologyData[index]['last_name']),withNavBar: false);
                                                        }, icon: const Icon(Icons.message,size: 30,color: appColors.white,)),
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
                            itemCount: psychologyData.length,
                          );

                        }
                        return const Text("data");
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

  rated(String id)async{
    var respons=await http.post(Uri.parse(apiCon.apiMysqlQuery),body: {
      "query":"SELECT * FROM `rating` WHERE `user_id`='$userId' AND `ps_id`='$id'"

    });
    if(respons.statusCode==200){
      var jsonData=json.decode(respons.body);
      if(jsonData['status']=="success"){
        print("json data ${jsonData['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("you have already rated the psychologist",style: TextStyle(color:appColors.white),),
            backgroundColor: appColors.red,
          )
        );
      }
      else if(jsonData['status']=="error"){
        print("json error ${jsonData['message']} use id $userId p id $id");
        final _dialog = RatingDialog(
          initialRating: 1.0,
          // your app's name?
          title: Text(
            'Rating Dialog',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          // encourage your user to leave a high rating?
          message: Text(
            'Tap a star to set your rating. Add more description here if you want.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ),
          // your app's logo?
          image: const FlutterLogo(size: 100),
          submitButtonText: 'Submit',
          commentHint: 'Additional comment',
          onCancelled: () => print('cancelled'),
          onSubmitted: (response) async {
            print('rating: ${response.rating}, comment: ${response.comment}');

            var respons2=await http.post(Uri.parse(apiCon.apiMysqlInsert),body:{
              "query":"INSERT INTO `rating`( `rate`, `user_id`, `ps_id`) VALUES ('${response.rating }','$userId','$id')"
            });
            if(respons2.statusCode==200){
              var jsonData2=json.decode(respons2.body);
              if(jsonData2['status']=="success"){
                print("success ${jsonData2['message']} $userId' AND `ps_id`='$id'");
                var respons3=await http.post(Uri.parse(apiCon.apiMysqlQuery),body: {
                  "query":"SELECT AVG(rate) as avg FROM `rating` WHERE `user_id`='$userId' AND `ps_id`='$id'"

                });
                if(respons3.statusCode==200){
                  print("respons3 ${respons3.body}");
                }
                  var jsonData=json.decode(respons3.body);
                  if(jsonData['status']=="success"){
                    print("json data ${jsonData['message']}");
                    var responsf=await http.post(Uri.parse(apiCon.apiMysqlInsert),body: {
                      "query":"UPDATE `psychology` SET `rating`='${jsonData['message'][0]['avg']}' WHERE `psychology_id`='$id'"
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("you have successfully rated the psychologist",style: TextStyle(color:appColors.white),),
                          backgroundColor: appColors.green,
                        )
                    );
                    setState(() {

                    });
                  }
              }else if(jsonData2['status']=="error"){
                print("error ${jsonData2['message']}");
              }
            }

            // TODO: add your own logic
            if (response.rating < 3.0) {
              // send their comments to your email or anywhere you wish
              // ask the user to contact you instead of leaving a bad review
            } else {

            }
          },
        );
        showDialog(
          context: context,
          barrierDismissible: true, // set to false if you want to force a rating
          builder: (context) => _dialog,
        );
      }
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
}
