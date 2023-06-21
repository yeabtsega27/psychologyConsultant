// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:psychological_consultation/src/model/appColors.dart';

import 'package:psychological_consultation/src/screen/resourcesTabAudio.dart';
import 'package:psychological_consultation/src/screen/resourcesTabBook.dart';
import 'package:psychological_consultation/src/screen/resourcesTabVideo.dart';
class aResourcesPage extends StatefulWidget {
  const aResourcesPage({Key? key}) : super(key: key);

  @override
  State<aResourcesPage> createState() => _aResourcesPageState();
}

class _aResourcesPageState extends State<aResourcesPage> {

  String search = '';
  String rType='video';

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
                                bottom: BorderSide(width: 1,color: appColors.textP)
                              ),
                          ),
                          padding: const EdgeInsets.all(5),

                          child: const Text("Resources", style: TextStyle(
                              color: appColors.textP, fontSize: 16),),
                        ),
                      ],
                    ),
                  ),
                  // Generated code for this TabBar Widget...
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      initialIndex: 0,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment(0, 0),
                            child: TabBar(
                              labelColor: appColors.textP,
                              indicatorColor: appColors.green,
                              tabs: [
                                Tab(
                                  text: 'video',
                                  icon: Icon(
                                    Icons.video_collection,
                                  ),
                                ),
                                Tab(
                                  text: 'Audio',
                                  icon: Icon(
                                    Icons.audio_file,
                                  ),
                                ),
                                Tab(
                                  text: 'Book',
                                  icon: Icon(
                                    Icons.menu_book,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                resourcesTabVideo(search: search,),
                                resourcesTabAudio(search: search),
                                resourcesTabBook(search: search)
                              ],
                            ),
                          ),
                        ],
                      ),
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
