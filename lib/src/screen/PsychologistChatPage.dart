// ignore_for_file: must_be_immutable, file_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';

class PsychologistChatPage extends StatefulWidget {
  String title;
  String id;

  PsychologistChatPage(this.id, this.title, {super.key});

  @override
  State<PsychologistChatPage> createState() => _PsychologistChatPageState();
}

class _PsychologistChatPageState extends State<PsychologistChatPage> {
  StreamController _messageController = StreamController();
  final textMessageController=TextEditingController();
  double postion = 0.0;
  final _controller = ScrollController();

  var sendeUserId;

  void _onScrollEvent() {
    final extentAfter = _controller.position.extentBefore;
    if (extentAfter > 250) {
      setState(() {
        postion = extentAfter;
      });
    } else {
      setState(() {
        postion = 0.0;
      });
    }
  }

  getMessage() async {
    //api url

    sendeUserId =
        await SessionManager().get('user').then((value) => value['user_id']);
    var response = await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
      'query':
          "SELECT * FROM `message` WHERE (`sender_id` = ${widget.id} or `reciver_id` = ${widget.id}) AND(`sender_id` = $sendeUserId or `reciver_id` = $sendeUserId) ORDER BY `message`.`created_date` DESC"
    });
    if (response.statusCode == 200) {
      print("object");
      print(response.body);
      var jsondata = json.decode(response.body);

      if (jsondata['status'].toString().contains("success")) {
        return jsondata['message'];
      }
    } else {
      throw Exception('Failed to load post');
    }
    return null;
  }

  loadMessage() async {
    getMessage().then((value) async {
      _messageController.add(value);
      return value;
    });
  }
  _handleRefresh(){
    getMessage().then((value) async {
      _messageController.add(value);
      return null;
    });
  }
  Future<void> sendMessage() async {
    print("send message");
    sendeUserId =
    await SessionManager().get('user').then((value) => value['user_id']);
    print("sending massage");
    print(widget.id);
    print(sendeUserId);
    var response= await http.post(Uri.parse(apiCon.apiMysqlInsert),body: {
      'query':
      "INSERT INTO `message`( `sender_id`, `reciver_id`, `content` ) VALUES ($sendeUserId,${widget.id},'${textMessageController.text}')"
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
        _handleRefresh();
        setState(() {
          textMessageController.clear();
        });
      }
    }
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

  @override
  void initState() {
    _controller.addListener(_onScrollEvent);
    _messageController = StreamController();
    loadMessage();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollEvent);
    _messageController.close();
    super.dispose();
  }

  double getOffSet() {
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.whiteBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: appColors.gray,
      ),
      floatingActionButton: postion != 0.0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 55.0),
              child: FloatingActionButton(
                backgroundColor: appColors.textP,
                onPressed: () {
                  _controller.animateTo(0.0,
                      duration: const Duration(seconds: 2),
                      curve: Curves.fastLinearToSlowEaseIn);
                },
                child: const Icon(Icons.arrow_downward),
              ),
            )
          : const SizedBox(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  List messageData = snapshot.data;
                  return ListView.builder(
                    itemCount: messageData.length,
                    controller: _controller,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      var message = messageData[index];
                      if (message['sender_id']
                          .toString()
                          .contains(sendeUserId)) {
                        var created_date =
                            message['created_date'].toString().split(" ")[1];
                        if(message['type']=="call"){
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, right: 10),
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: EdgeInsets.only(left: 80),
                                decoration: BoxDecoration(
                                    color: appColors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      "out going call",
                                      style: TextStyle(
                                          fontSize: 16, color: appColors.blue),
                                      maxLines: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          created_date,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: appColors.green),
                                          maxLines: 1,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(
                               bottom: 10, right: 10),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: EdgeInsets.only(left: 80),
                              decoration: BoxDecoration(
                                  color: appColors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    message['content'],
                                    style: const TextStyle(
                                        fontSize: 16, color: appColors.black),
                                    maxLines: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        created_date,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: appColors.gray),
                                        maxLines: 1,
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        );
                      }
                      else {
                        var created_date =
                            message['created_date'].toString().split(" ")[1];
                        if(message['type']=="call"){
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 10,left: 0, bottom: 10),
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: EdgeInsets.only(right: 80),
                                decoration: BoxDecoration(
                                    color: appColors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      "out going call",
                                      style: TextStyle(
                                          fontSize: 16, color: appColors.blue),
                                      maxLines: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          created_date,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: appColors.green),
                                          maxLines: 1,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 10, right: 90),
                          child: Container(
                              padding: const EdgeInsets.all(8),

                              margin: EdgeInsets.only(right: 80),
                              decoration: BoxDecoration(
                                  color: appColors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    message['content'],
                                    style: const TextStyle(
                                        fontSize: 16, color: appColors.black),
                                    maxLines: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        created_date,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: appColors.gray),
                                        maxLines: 1,
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: Text("no message found"),
                  );
                }
              },
              stream: _messageController.stream,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            color: appColors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textMessageController,
                    onChanged: (value){
                      setState(() {
                        textMessageController;
                      });
                    },
                    maxLines: 10,
                    minLines: 1,
                    decoration: const InputDecoration(
                      hintText: "Message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                textMessageController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: const Icon(
                          Icons.send,
                          size: 36,
                          color: appColors.textP,
                        ))
                    : const SizedBox(
                        width: 20,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
