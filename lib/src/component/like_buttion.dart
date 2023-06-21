import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psychological_consultation/src/conn/apicon.dart';
import 'package:psychological_consultation/src/model/appColors.dart';
import 'package:http/http.dart' as http;

class likeButton extends StatefulWidget {
  final String userId;
  final String id;
  final String likeCount;

  const likeButton(
      {required this.id,
      required this.userId,
      required this.likeCount,
      Key? key})
      : super(key: key);

  @override
  State<likeButton> createState() => _likeButtonState();
}

class _likeButtonState extends State<likeButton> {
  int likeCount = 0;
  bool isLiked = false;

  liked() async {
    var respons = await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
      "query":
          "SELECT * FROM `like` WHERE `user_id`='${widget.userId}' AND `di_id`='${widget.id}'"
    });
    if (respons.statusCode == 200) {
      var jsonData = json.decode(respons.body);
      if (jsonData['status'] == "success") {
        print("json data ${jsonData['message']}");
        return true;
      } else if (jsonData['status'] == "error") {
        print(
            "json error ${jsonData['message']} use id ${widget.userId} p id ${widget.id}");
        return false;
      }
    }
  }

  @override
  void initState() {
    liked();
    likeCount = int.parse(widget.likeCount);
    super.initState();
  }

  doLike() async {
    var respons2 = await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
      "query":
          "INSERT INTO `like`(`di_id`,`user_id`) VALUES ('${widget.id}','${widget.userId}')"
    });
    if (respons2.statusCode == 200) {
      var jsonData2 = json.decode(respons2.body);
      if (jsonData2['status'] == "success") {
        print(
            "success ${jsonData2['message']} ${widget.userId}' AND `ps_id`='${widget.id}'");
        var respons3 = await http.post(Uri.parse(apiCon.apiMysqlQuery), body: {
          "query":
              "SELECT COUNT(user_id) as count FROM `like` WHERE `user_id`='${widget.userId}' AND `di_id`='${widget.id}'"
        });
        if (respons3.statusCode == 200) {
          print("respons3 ${respons3.body}");
        }
        var jsonData = json.decode(respons3.body);
        if (jsonData['status'] == "success") {
          print("json data ${jsonData['message']}");
          likeCount = int.parse(jsonData['message'][0]['count']);
          var responsf =
              await http.post(Uri.parse(apiCon.apiMysqlInsert), body: {
            "query":
                "UPDATE `discussion` SET `like_count`='${jsonData['message'][0]['count']}' WHERE `discussion_id`='${widget.id}'"
          });
          setState(() {});
        }
      } else if (jsonData2['status'] == "error") {
        print("error ${jsonData2['message']}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.thumb_up_alt_rounded,
                color: appColors.gray,
              ),
            ),
            Text(
              likeCount.toString(),
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFFFFFCFC),
                fontSize: 16,
              ),
            ),
          ]);
        }
        if (snapshot.hasData) {
          print("snapshot.data ${snapshot.data.runtimeType.toString()}");
          if (snapshot.data.toString() == "true") {
            return Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.thumb_up_alt_rounded,
                    color: appColors.blue,
                  ),
                ),
                Text(
                  likeCount.toString(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFFFFCFC),
                    fontSize: 16,
                  ),
                ),
              ],
            );
          } else if (snapshot.data.toString() == "false") {
            print("liked false");

            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    doLike();
                  },
                  icon: const Icon(
                    Icons.thumb_up_alt_rounded,
                    color: appColors.gray,
                  ),
                ),
                Text(
                  likeCount.toString(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFFFFFCFC),
                    fontSize: 16,
                  ),
                ),
              ],
            );
          }
        }
        return Row(children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.thumb_up_alt_rounded,
              color: appColors.gray,
            ),
          ),
          Text(
            likeCount.toString(),
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFFFFFCFC),
              fontSize: 16,
            ),
          ),
        ]);
      },
      future: liked(),
    );
  }
}
