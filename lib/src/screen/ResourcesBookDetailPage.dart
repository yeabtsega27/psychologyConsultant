// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:psychological_consultation/src/model/appColors.dart';


class ResourcesBookDetailPage extends StatefulWidget {
  final data;

  const ResourcesBookDetailPage(this.data, {Key? key}) : super(key: key);

  @override
  State<ResourcesBookDetailPage> createState() => _ResourcesBookDetailPageState();
}

class _ResourcesBookDetailPageState extends State<ResourcesBookDetailPage> {
  var isdownloading=false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      downloadFile();
    });
    super.initState();
  }
  Future<void> downloadFile() async {
    if(await SessionManager().containsKey(widget.data['resource_url'])){
      isdownloading=true;
    }else{
      isdownloading=false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.whiteBackgroundColor,
      appBar: AppBar(
        leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.arrow_back,color: appColors.textP,),),
        title: Text(widget.data['name'],style: TextStyle(color: appColors.textP),),
        backgroundColor: appColors.gray,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 250,
            child: Icon(Icons.book,size: 100,)
          ),
          TextButton(
              onPressed: isdownloading
                  ? null
                  : () async {
                await SessionManager().set(widget.data['resource_url'], "downloading");
                FileDownloader.downloadFile(
                    url: widget.data['resource_url'],
                    onDownloadCompleted: (path) {
                      SessionManager().remove(widget.data['resource_url']);
                      isdownloading=false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "download finish $path",
                          style: TextStyle(color: appColors.white),
                        ),
                        backgroundColor: appColors.green,
                      ));
                    },
                    onDownloadError: (error) async {
                      await SessionManager().remove(widget.data['resource_url']);
                      isdownloading=false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "download finish $error",
                          style: TextStyle(color: appColors.white),
                        ),
                        backgroundColor: appColors.red,
                      ));
                    });
              },
              child: const Text("download")),
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: appColors.gray,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Resources description",
                      style: TextStyle(fontSize: 16,color: appColors.primeryColor),
                      overflow: TextOverflow.fade,
                    ),
                    Text(widget.data['description'],
                      maxLines: 10,
                      overflow: TextOverflow.fade,
                    )
                  ],
                ),
              ),
            )
          ])
        ],
      ),
    );
  }
}
// Resources description

// Depression, also known as major depressive disorder, is a mental health condition characterized by prolonged feelings of sadness, emptiness and hopelessness. It can have an effect on someone's daily life and functioning. Additionally, it may cause physical symptoms such as changes in sleeping patterns, fatigue, or loss of appetite..
