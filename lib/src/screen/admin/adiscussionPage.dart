import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'dart:convert';

import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/discusionChatPage.dart';

class aDiscussionsPage extends StatefulWidget {
  const aDiscussionsPage({Key? key}) : super(key: key);

  @override
  State<aDiscussionsPage> createState() => _DiscussionsPageState();
}

class _DiscussionsPageState extends State<aDiscussionsPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    getDisList() async {
      //api url
      var response = await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
        'query': "SELECT * FROM `discussion` WHERE title LIKE '%$search%' ;"
      });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        return jsondata['message'];
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
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border:
                                  Border(bottom:BorderSide(width: 1, color: appColors.textP)),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "discussion",
                            style: TextStyle(color: appColors.textP, fontSize: 16),
                          ),
                        ),
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
                          if(snapshot.data.runtimeType.toString()=="String"||snapshot.data.length==0){
                            return Text("no data found");
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      deleteDescussion(discussionData[index]['discussion_id']);
                                                    },
                                                    icon: Icon(
                                                        Icons.delete_forever,color: appColors.red,)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Text(
                                                  'Title:',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xFFFFFCFC),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    discussionData[index]
                                                        ['title'],
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      overflow: TextOverflow.fade,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFFFFCFC),
                                                      fontSize: 16,
                                                    ),
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
                                                    color: Color(0xFFFFFCFC),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    discussionData[index]
                                                        ['catagory'],
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      overflow: TextOverflow.fade,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFFFFCFC),
                                                      fontSize: 16,
                                                    ),
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
                                                        color:
                                                            Color(0xFFFFFCFC),
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      discussionData[index]
                                                          ['created_date'],
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFFFFFCFC),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.thumb_up,
                                                      color: appColors.blue,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      discussionData[index]
                                                          ['like_count'],
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFFFFFCFC),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                )
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

  Future<void> deleteDescussion(String discussionData) async {
    print("discussionData id");
    print(discussionData);
    var response = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
      'query': "DELETE FROM `discussion` WHERE `discussion_id`=$discussionData ;"
    });
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      setState(() {
      });
      print(jsondata);
    }
  }
}
