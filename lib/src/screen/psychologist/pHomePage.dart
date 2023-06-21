// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/auth.dart';
import 'dart:convert';

import '../../component/like_buttion.dart';
import '../../component/videoPlayer.dart';
import '../ResourcesBookDetailPage.dart';
import '../ResourcesDetailPage.dart';
import '../discusionChatPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

getDiscussion() async {
  String apiurl = apiCon.apiGetListData; //api url
  var response = await http.post(Uri.parse(apiurl),
      body: {'table': "discussion", 'order': "created_date"});
  if (response.statusCode == 200) {
    var jsondata = json.decode(response.body);
    return jsondata['message'];
  }
  return null;
}

getResources() async {
  String apiurl = apiCon.apiGetListData; //api url

  var response = await http.post(Uri.parse(apiurl),
      body: {'table': "resource", 'order': "created_at"});
  if (response.statusCode == 200) {
    var jsondata = json.decode(response.body);

    return jsondata['message'];
  }
  return null;
}

class _HomePageState extends State<HomePage> {
  final _titleTextFieldControler = TextEditingController();
  final _contentTextFieldControler = TextEditingController();
  final _nameTextFieldControler = TextEditingController();
  final _descriptionTextFieldControler = TextEditingController();
  List? catagory;
  String? selectedCatagory;

  List<String> type = ['video', 'audio', 'book'];
  String selectedType = "video";

  String? _fileData;
  String? _filePath;
  String? _fileExe;
  String userId = "";
  String userName = "";
  @override
  void initState() {
    getUserInf();
    super.initState();
  }

  getUserInf() async {
    userId =
    await SessionManager().get("user").then((value) => value["user_id"]);
    userName =
    await SessionManager().get("user").then((value) => value["email"]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: appColors.whiteBackgroundColor,
      ),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height/2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border(
                          bottom: BorderSide(
                            color: appColors.textP,
                            width: 2,
                          ),
                        )
                      ),
                      child: const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                        child: Text(
                          'Discussions ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: appColors.textP,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          print("add discussion");
                          addDiscussion();
                        },
                        icon: Icon(
                          Icons.add,
                          color: appColors.textP,
                          size: 30,
                        ))
                  ],
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
                                itemCount: snapshot.data.length>10?10:snapshot.data.length,
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 10, 0),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          width: 305,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: const Color(0xFFFFFCFC),
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Title:',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFFFFFCFC),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        discussionData[index]
                                                            ['title'],
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 5,
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              Color(0xFFFFFCFC),
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Category:',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            Color(0xFFFFFCFC),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        discussionData[index]
                                                            ['catagory'],
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              Color(0xFFFFFCFC),
                                                          fontSize: 16,
                                                        ),
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
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Text(
                                                            'Date: ',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              color: Color(
                                                                  0xFFFFFCFC),
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              discussionData[
                                                                          index]
                                                                      [
                                                                      'created_date']
                                                                  .toString()
                                                                  .split(
                                                                      " ")[0],
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              maxLines: 2,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0xFFFFFCFC),
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        likeButton(
                                                          id: discussionData[index]
                                                          ['discussion_id'],
                                                          userId: userId,
                                                          likeCount:
                                                          discussionData[index]
                                                          ['like_count'],
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          discussionData[index]
                                                              ['like_count'],
                                                          style:
                                                              const TextStyle(
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
            height: MediaQuery.of(context).size.height/2,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border(
                          bottom: BorderSide(
                            color: appColors.textP,
                            width: 2,
                          ),
                        )
                      ),
                      child: const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                        child: Text(
                          'Resources',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: appColors.textP,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          print("add resource");
                          addResource();
                        },
                        icon: Icon(
                          Icons.add,
                          color: appColors.textP,
                          size: 30,
                        ))
                  ],
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
                                print("resourceData");
                                print(resourceData);
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length>10?10:snapshot.data.length,
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
                                                      appColors.black,
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
                                        .contains("book")) {
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
                                );
                              } else {
                                return InkWell(
                                  onTap: () {
                                    print("click");
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

  Future<void> addResource() async {
    await getCatagory();
    if (!(catagory == null)) {
      selectedCatagory = catagory![0]['title'];
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              height: 450,
              color: appColors.gray,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Expanded(
                              child: Text(
                                "name",
                                style: TextStyle(color: appColors.textP),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 45,
                              decoration: BoxDecoration(
                                  color: appColors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _nameTextFieldControler,
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
                                "description",
                                style: TextStyle(color: appColors.textP),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              // height: 50,
                              decoration: BoxDecoration(
                                  color: appColors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                maxLines: 10,
                                minLines: 3,
                                keyboardType: TextInputType.emailAddress,
                                controller: _descriptionTextFieldControler,
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
                      Container(
                        // height: 50,
                        // width: MediaQuery.of(context).size.width-10,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: dropdownButton(
                          catSelect: selectedCatagory!,
                          onValueChange: (String value) {
                            selectedCatagory = value;
                          },
                          catagoryList: catagory!.map((e) {
                            return e['title'];
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      getFileWidget(
                        typeChange: (String value) {
                          selectedType = value;
                        },
                        onFileData: (String value) {
                          _fileData = value;
                        },
                        onFileExt: (String value) {
                          _fileExe = value;
                        },
                        filePath: (String value) {
                          _filePath = value;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            onPressed: () {
                              uploadFile();
                            },
                            child: Text(
                              "add",
                              style: TextStyle(fontSize: 20),
                            ),
                            style: FilledButton.styleFrom(
                                backgroundColor: appColors.green),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "error loading try agan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  uploadFile() async {
    if (_fileData != null) {
      if (_nameTextFieldControler.text.isNotEmpty &&
          _descriptionTextFieldControler.text.isNotEmpty) {
        var userId = await SessionManager()
            .get('user')
            .then((value) => value['user_id']);

        var userName;
        var getusername = await http.post(Uri.parse(apiCon.apiMysqlQuery),
            body: {
              'query':
                  "SELECT `first_name` FROM `psychology` WHERE `psychology_id`=$userId"
            });
        userName = json.decode(getusername.body)['message'][0]['first_name'];

        try {
          var response =
          await http.post(Uri.parse(apiCon.apiResourceUpload),
              body: {
                "file": _fileData,
                'sql':
                    "INSERT INTO `resource`(`category`, `name`,`type`, `uploader`, `description`,`resource_url`) VALUES ('$selectedCatagory','${_nameTextFieldControler.text}','$selectedType','$userName','${_descriptionTextFieldControler.text}'",
                'ext': _fileExe
              });

          if (response.statusCode == 200) {
            print("response body");
            print(response.body);
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
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  jsonData['message'],
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ));
            } else {
              print('jsonData');
              print(response.body);
            }
          }
        } catch (e) {
          print(e);
        }
        _nameTextFieldControler.clear();
        _descriptionTextFieldControler.clear();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "fill all input ",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "select file",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> addDiscussion() async {
    await getCatagory();
    if (!(catagory == null)) {
      selectedCatagory = catagory![0]['title'];
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              height: 350,
              color: appColors.gray,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Expanded(
                              child: Text(
                                "Title",
                                style: TextStyle(color: appColors.textP),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: appColors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _titleTextFieldControler,
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
                                "Content",
                                style: TextStyle(color: appColors.textP),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              // height: 50,
                              decoration: BoxDecoration(
                                  color: appColors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                maxLines: 10,
                                minLines: 3,
                                keyboardType: TextInputType.emailAddress,
                                controller: _contentTextFieldControler,
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
                      Container(
                        // height: 50,
                        // width: MediaQuery.of(context).size.width-10,
                        decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: dropdownButton(
                          catSelect: selectedCatagory!,
                          onValueChange: (String value) {
                            selectedCatagory = value;
                          },
                          catagoryList: catagory!.map((e) {
                            return e['title'];
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            onPressed: () {
                              adddis();
                            },
                            child: Text(
                              "add",
                              style: TextStyle(fontSize: 20),
                            ),
                            style: FilledButton.styleFrom(
                                backgroundColor: appColors.green),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "error loading try agan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  getCatagory() async {
    var respons = await http.post(Uri.parse(apiCon.apiMysqlQuery),
        body: {'query': "SELECT * FROM `category` WHERE 1"});
    print(respons.body);
    if (respons.statusCode == 200) {
      var jsonData = json.decode(respons.body);
      if (jsonData['status'].toString().contains("error")) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "no catagory found",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        catagory = jsonData['message'];
      }
    }
  }

  Future<void> adddis() async {
    print("object slected catagory");
    print(selectedCatagory);
    if (selectedCatagory!.isNotEmpty &&
        _titleTextFieldControler.text.isNotEmpty &&
        _contentTextFieldControler.text.isNotEmpty) {
      var userId =
          await SessionManager().get('user').then((value) => value['user_id']);
      print("");
      var userName;
      var getusername = await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
        'query':
            "SELECT `first_name` FROM `psychology` WHERE `psychology_id`=$userId"
      });
      userName = json.decode(getusername.body)['message'][0]['first_name'];

      var respons = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
        'query':
            "INSERT INTO `discussion`( `catagory`, `title`, `content`,`author`, `like_count`) VALUES ('$selectedCatagory','${_titleTextFieldControler.text}','${_contentTextFieldControler.text}','$userName','0')"
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
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "discussion add successfully",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "failed to add empty input",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
    _titleTextFieldControler.clear();
    _contentTextFieldControler.clear();
    Navigator.pop(context);
  }
}

class dropdownButton extends StatefulWidget {
  final ValueChanged<String> onValueChange;
  String catSelect;
  List catagoryList;

  dropdownButton(
      {Key? key,
      required this.onValueChange,
      required this.catSelect,
      required this.catagoryList})
      : super(key: key);

  @override
  State<dropdownButton> createState() => _dropdownButtonState();
}

class _dropdownButtonState extends State<dropdownButton> {
  late List catagory;
  late String SelectedValue;

  @override
  void initState() {
    // TODO: implement initState
    SelectedValue = widget.catSelect;
    catagory = widget.catagoryList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: SelectedValue,
      isExpanded: true,
      items: catagory.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e),
        );
      }).toList(),
      onChanged: (Object? value) {
        widget.onValueChange(value!.toString());
        setState(() {
          print("selected value");
          print(value);
          SelectedValue = value!.toString();
        });
      },
    );
  }
}

class getFileWidget extends StatefulWidget {
  final ValueChanged<String> onFileExt;
  final ValueChanged<String> onFileData;
  final ValueChanged<String> typeChange;
  final ValueChanged<String> filePath;

  const getFileWidget(
      {Key? key,
      required this.typeChange,
      required this.onFileData,
      required this.onFileExt,
      required this.filePath})
      : super(key: key);

  @override
  State<getFileWidget> createState() => _getFileWidgetState();
}

class _getFileWidgetState extends State<getFileWidget> {
  File? _tempfile;
  String? _fileData;
  String? _fileExe;
  String? _fileName;

  List<String> type = ['video', 'audio', 'book'];
  String selectedType = "video";

  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: selectedType == "video"
          ? FileType.video
          : selectedType == "audio"
              ? FileType.audio
              : FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _tempfile = File(result.files.single.path.toString());
        _fileData = base64Encode(_tempfile!.readAsBytesSync());
        _fileName = result.files.single.path.toString().split("/").last;
        _fileExe = result.files.single.path.toString().split(".").last;
        widget.onFileExt(_fileExe!);
        widget.onFileData(_fileData!);
        widget.filePath(result.files.single.path.toString());
        print("file is");
        print(_tempfile);

        print("file name is");
        print(_fileName);
        print("file ext is");
        print(_fileExe);
        print('file data is');
        print(_fileData);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          // height: 50,
          decoration: BoxDecoration(
              color: appColors.white,
              borderRadius: BorderRadius.circular(10)),
          child: dropdownButton(
            catSelect: selectedType,
            onValueChange: (String value) {
              selectedType = value;
              widget.typeChange(selectedType);
            },
            catagoryList: type.map((e) {
              print(e);
              return e;
            }).toList(),
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  getFile();
                },
                icon: Icon(Icons.file_copy)),
            _tempfile != null
                ? Expanded(
                    child: Text(
                    _fileName!,
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                  ))
                : const Text("select file"),
          ],
        )
      ],
    );
  }
}
