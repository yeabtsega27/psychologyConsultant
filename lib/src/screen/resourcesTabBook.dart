// ignore_for_file: camel_case_types, must_be_immutable, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'dart:convert';

import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:psychological_consultation/src/screen/ResourcesBookDetailPage.dart';


class resourcesTabBook extends StatefulWidget {
  String search;
  resourcesTabBook ({super.key, required this.search ,}) ;

  @override
  State<resourcesTabBook> createState() => _resourcesTabBookState();
}

class _resourcesTabBookState extends State<resourcesTabBook> {
  @override
  Widget build(BuildContext context) {
    getResourcesList() async {
      String apiUrl =apiCon.apiGetListData;
      var response = await http.post(Uri.parse(apiUrl), body: {
        'query': "SELECT * FROM `resource` WHERE `type`='pdf' AND `name` like '%${widget.search}%'"
      });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        return jsondata['message'];
      }
      return null;
    }

    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data.runtimeType.toString() ==
              "String") {
            return const Text("no resource found");
          }
          List discussionData = snapshot.data;
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreen(context, screen: ResourcesBookDetailPage(discussionData[index]),withNavBar: false);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    height: 130,
                    decoration:  BoxDecoration(

                        border: Border.all(color: appColors.textP,width: 1)
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Icon(Icons.book,size: 70,),
                        ),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: const Color(0xF44A4B48),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text( discussionData[index]['name'],style: const TextStyle(color: Colors.white,fontSize: 14),),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(softWrap: false,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,"by: "+discussionData[index]['uploader'],style: const TextStyle(color: Colors.white,fontSize: 14)),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text( discussionData[index]['description'],style: const TextStyle(color: Colors.white,fontSize: 12),
                                              maxLines: 5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ))
                      ],
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
      future: getResourcesList(),
    );
  }
}
