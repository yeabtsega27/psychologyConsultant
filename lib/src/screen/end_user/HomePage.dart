// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/auth.dart';
import 'dart:convert';

import '../../component/videoPlayer.dart';
import '../ResourcesBookDetailPage.dart';
import '../ResourcesDetailPage.dart';
import '../discusionChatPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  getDiscussion() async {
    String apiurl = apiCon.apiGetListData; //api url
    var response = await http.post(Uri.parse(apiurl),
        body: {'table': "discussion", 'order': "like_count"});
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      return jsondata['message'];
    }
    return null;
  }

  getResources() async {
    String apiurl = apiCon.apiGetListData; //api url

    var response = await http.post(Uri.parse(apiurl),
        body: {'table': "resource", 'order': "resource_id"});
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      return jsondata['message'];
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: appColors.whiteBackgroundColor,
      ),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: appColors.textP

                        )
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                    child: Text(
                      'Discussions ',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        color: appColors.textP,

                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: (){
                                      PersistentNavBarNavigator.pushNewScreen(context, screen: discusionChatPage(discussionData[index]['discussion_id'],discussionData[index]['title']),withNavBar: false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(10, 0, 10, 0),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          width: 305,height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                            border: Border.all(
                                              color: appColors.black,
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(5, 5, 5, 5),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  children: [
                                                    const Text(
                                                      'Title:',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                          appColors.textP,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        discussionData[index]
                                                        ['title'],
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                          appColors.textP,
                                                          fontSize: 18,
                                                          fontWeight:FontWeight.bold,
                                                          overflow: TextOverflow.fade,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  children: [
                                                    const Text(
                                                      'Category:',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                        appColors.textP,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        discussionData[index]
                                                        ['catagory'],
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                          appColors.textP,
                                                          fontSize: 16,
                                                          overflow: TextOverflow.fade,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Date:',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Poppins',
                                                            color:
                                                            appColors.textP,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        Text(
                                                          discussionData[
                                                          index][
                                                          'created_date'],
                                                          style: const TextStyle(
                                                            fontFamily:
                                                            'Poppins',
                                                            color: appColors.textP,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.thumb_up,
                                                          color:appColors.blue,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          discussionData[
                                                          index]
                                                          ['like_count'],
                                                          style: const TextStyle(
                                                            fontFamily:
                                                            'Poppins',
                                                            color: Color(
                                                                0xFFFFFCFC),
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
                              );
                            } else {
                              return const Text("no data found");
                            }
                          },
                          future: getDiscussion(),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: appColors.textP
                        )
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                    child: Text(
                      'Resources',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: appColors.textP,
                        fontSize: 18
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
                                var resourceData = snapshot.data;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (resourceData[index]['type']
                                        .toString()
                                        .contains("video")) {
                                      return // Generated code for this Container Widget...
                                          InkWell(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(context,
                                                  screen: ResourcesDetailPage(
                                                      resourceData[index]),
                                                  withNavBar: false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Material(
                                            color: Colors.transparent,
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Container(
                                              width: 303.1,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFFFFCFC),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                        15, 15, 15, 15),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 100,
                                                          child: videoPlayer(
                                                            Url: resourceData[
                                                                    index][
                                                                'resource_url'],
                                                          )),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {},
                                                          child: Text(
                                                            resourceData[index]
                                                                ['name'],
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: Color(
                                                                  0xFFFFFCFC),
                                                              fontSize: 18,
                                                            ),
                                                          ),
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
                                    }
                                    if (resourceData[index]['type']
                                        .toString()
                                        .contains("audio")) {
                                      return InkWell(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(context,
                                                  screen: ResourcesDetailPage(
                                                      resourceData[index]),
                                                  withNavBar: false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Material(
                                            color: Colors.transparent,
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Container(
                                              width: 303.1,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFFFFCFC),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                        15, 15, 15, 15),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 100,
                                                          //todo audio
                                                          child: videoPlayer(
                                                            Url: resourceData[
                                                                    index][
                                                                'resource_url'],
                                                          )),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {},
                                                          child: Text(
                                                            resourceData[index]
                                                                ['name'],
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: Color(
                                                                  0xFFFFFCFC),
                                                              fontSize: 18,
                                                            ),
                                                          ),
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
                                    }
                                    if (resourceData[index]['type']
                                        .toString()
                                        .contains("pdf")) {
                                      return InkWell(
                                        onTap: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(context,
                                                  screen:
                                                      ResourcesBookDetailPage(
                                                          resourceData[index]),
                                                  withNavBar: false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: Material(
                                            color: Colors.transparent,
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Container(
                                              width: 303.1,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFFFFCFC),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                        15, 15, 15, 15),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 100,
                                                          child: videoPlayer(
                                                            Url: resourceData[
                                                                    index][
                                                                'resource_url'],
                                                          )),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {},
                                                          child: Text(
                                                            resourceData[index]
                                                                ['name'],
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: Color(
                                                                  0xFFFFFCFC),
                                                              fontSize: 18,
                                                            ),
                                                          ),
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
                                    }
                                    return const Text("data unknown");
                                  },
                                  itemCount: 6,
                                );
                              } else {
                                return InkWell(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: const auth());
                                  },
                                  child: const Text("no data found"),
                                );
                              }
                            },
                            future: getResources(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
