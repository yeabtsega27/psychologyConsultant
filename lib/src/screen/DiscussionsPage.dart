import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:psychological_consultation/src/component/like_buttion.dart';
import 'dart:convert';

import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/discusionChatPage.dart';

class DiscussionsPage extends StatefulWidget {
  const DiscussionsPage({Key? key}) : super(key: key);

  @override
  State<DiscussionsPage> createState() => _DiscussionsPageState();
}

class _DiscussionsPageState extends State<DiscussionsPage> {
  String search = '';
  String discOrderBy = "like_count";
  List<String> discOrderByList = [
    "catagory",
    "title",
    "created_date",
    "author",
    "like_count"
  ];

  getDisList() async {
    //api url
    var response = await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
      'query':
          "SELECT * FROM `discussion` WHERE title LIKE '%$search%' ORDER BY $discOrderBy DESC;;"
    });
    print("get list search value $search");

    if (response.statusCode == 200) {
      print("${response.body}");
      var jsondata = json.decode(response.body);
      return jsondata['message'];
    }
    return null;
  }

  String userId = "";
  String userName = "";

  getUserInf() async {
    userId =
        await SessionManager().get("user").then((value) => value["user_id"]);
    userName =
        await SessionManager().get("user").then((value) => value["email"]);
    setState(() {});
  }

  rated(String id) async {
    var respons = await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
      "query":
          "SELECT * FROM `like` WHERE `user_id`='$userId' AND `di_id`='$id'"
    });
    if (respons.statusCode == 200) {
      var jsonData = json.decode(respons.body);
      if (jsonData['status'] == "success") {
        print("json data ${jsonData['message']}");
      } else if (jsonData['status'] == "error") {
        print("json error ${jsonData['message']} use id $userId p id $id");
        var respons2 = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
          "query":
              "INSERT INTO `like`(`di_id`,`user_id`) VALUES ('$id','$userId')"
        });
        if (respons2.statusCode == 200) {
          var jsonData2 = json.decode(respons2.body);
          if (jsonData2['status'] == "success") {
            print("success ${jsonData2['message']} $userId' AND `ps_id`='$id'");
            var respons3 =
                await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
              "query":
                  "SELECT COUNT(user_id) as count FROM `like` WHERE `user_id`='$userId' AND `di_id`='$id'"
            });
            if (respons3.statusCode == 200) {
              print("respons3 ${respons3.body}");
            }
            var jsonData = json.decode(respons3.body);
            if (jsonData['status'] == "success") {
              print("json data ${jsonData['message']}");
              var responsf =
                  await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
                "query":
                    "UPDATE `discussion` SET `like_count`='${jsonData['message'][0]['count']}' WHERE `discussion_id`='$id'"
              });
              setState(() {});
            }
          } else if (jsonData2['status'] == "error") {
            print("error ${jsonData2['message']}");
          }
        }
      }
    }
  }

  @override
  void initState() {
    getUserInf();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(color: appColors.textP),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: appColors.textP)),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "Discussion",
                            style:
                                TextStyle(color: appColors.textP, fontSize: 17),
                          ),
                        ),
                        DropdownButton(
                            value: discOrderBy,
                            items: discOrderByList.map((e) {
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList(),
                            onChanged: (n) {
                              setState(() {
                                discOrderBy = n as String;
                              });
                            })
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data.runtimeType.toString() ==
                              "String") {
                            return Text("no discussion found");
                          }
                          List discussionData = snapshot.data;
                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: discusionChatPage(
                                          discussionData[index]
                                              ['discussion_id'],
                                          discussionData[index]['title']),
                                      withNavBar: false);
                                },
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 10),
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      width: 305,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: appColors.black,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(5, 5, 5, 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Text(
                                                  'Title:',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: appColors.textP,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    discussionData[index]
                                                        ['title'],
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: appColors.textP,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Text(
                                                  'Category:',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: appColors.textP,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    discussionData[index]
                                                        ['catagory'],
                                                    style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: appColors.textP,
                                                      fontSize: 16,
                                                      overflow:
                                                          TextOverflow.fade,
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'Date:',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: appColors.textP,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      discussionData[index]
                                                          ['created_date'],
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color: appColors.textP,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                likeButton(
                                                  id: discussionData[index]
                                                  ['discussion_id'],
                                                  userId: userId,
                                                  likeCount:
                                                  discussionData[index]
                                                  ['like_count'],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: discussionData.length,
                          );
                        }
                        return const Text("data");
                      },
                      future: getDisList(),
                    ),
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
