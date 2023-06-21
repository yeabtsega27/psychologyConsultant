import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'dart:convert';

import 'package:psychological_consultation/src/component/ratingStar.dart';
import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/PsychologistChatPage.dart';
import 'package:psychological_consultation/src/screen/PsychologistVideoCallPage.dart';
import 'package:psychological_consultation/src/screen/admin/addPsycologist.dart';

class aPsychologistPage extends StatefulWidget {
  const aPsychologistPage({Key? key}) : super(key: key);

  @override
  State<aPsychologistPage> createState() => _aPsychologistPageState();
}

class _aPsychologistPageState extends State<aPsychologistPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
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
                          decoration: BoxDecoration(
                            border: const Border(
                              bottom:
                                  BorderSide(width: 1, color: appColors.textP),
                            ),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "Psychologist",
                            style:
                                TextStyle(color: appColors.textP, fontSize: 16),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              PersistentNavBarNavigator.pushNewScreen(context, screen: addPsycologist(),withNavBar: false);
                            },
                            icon: const Icon(
                              Icons.add,
                              color: appColors.textP,
                            ))
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
                          if(snapshot.data.runtimeType.toString()=="String"){
                            return Column(
                              children: [
                                Text(snapshot.data)
                              ],
                            );
                          }else{
                            List psychologyData = snapshot.data;
                            return ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 10),
                                  child: Material(
                                    color: Colors.transparent,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        // PersistentNavBarNavigator.pushNewScreen(context, screen: PsychologistChatPage(psychologyData[index]['psychology_id'],psychologyData[index]['first_name']+" "+psychologyData[index]['last_name']),withNavBar: false);
                                      },
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(35),
                                          border: Border.all(
                                            color: appColors.black,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
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
                                              Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 8.0, right: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                              ratingStar(
                                                                  rate:
                                                                  psychologyData[
                                                                  index]
                                                                  ['rating']),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.end,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  deletePsychologist(
                                                                      psychologyData[
                                                                      index][
                                                                      'psychology_id']);
                                                                },
                                                                icon: const Icon(
                                                                  Icons
                                                                      .delete_forever,
                                                                  size: 30,
                                                                  color:
                                                                  appColors.red,
                                                                )),
                                                            Row(
                                                              children: [
                                                                psychologyData[index][
                                                                'active'] ==
                                                                    "1"
                                                                    ? IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      disablePsychologist(
                                                                          psychologyData[index]
                                                                          [
                                                                          'psychology_id']);
                                                                    },
                                                                    icon:
                                                                    const Icon(
                                                                      Icons
                                                                          .person_off,
                                                                      size: 30,
                                                                      color:
                                                                      appColors
                                                                          .gray,
                                                                    ))
                                                                    : IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      enablePsychologist(
                                                                          psychologyData[index]
                                                                          [
                                                                          'psychology_id']);
                                                                    },
                                                                    icon:
                                                                    const Icon(
                                                                      Icons
                                                                          .recycling_sharp,
                                                                      size: 30,
                                                                      color: appColors
                                                                          .green,
                                                                    )),
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
                              itemCount: psychologyData.length,
                            );
                          }

                        }
                        return const Text("data");
                      },
                      future: getPsycList(),
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

  Future<void> deletePsychologist(String discussionData) async {
    print("discussionData id");
    print(discussionData);
    var response = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
      'query':
          "DELETE FROM `user` WHERE `user_id`=$discussionData ;"
    });
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      setState(() {});
      print(jsondata);
    }
  }

  Future<void> disablePsychologist(String discussionData) async {
    print("discussionData id");
    print(discussionData);
    var response = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
      'query':
          "UPDATE `user` SET `active`='0' WHERE `user_id`=$discussionData ;"
    });
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      setState(() {});
      print(jsondata);
    }
  }

  Future<void> enablePsychologist(String discussionData) async {
    print("discussionData id");
    print(discussionData);
    var response = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
      'query':
          "UPDATE `user` SET `active`='1' WHERE `user_id`=$discussionData ;"
    });
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      setState(() {});
      print(jsondata);
    }
  }



}
