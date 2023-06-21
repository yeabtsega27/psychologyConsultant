// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:psychological_consultation/src/model/appColors.dart';

class ratingStar extends StatelessWidget {
  final String rate;

  const ratingStar({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    if (rate.split(".")[0].contains("1")) {
      return  Row(
        children: const [
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
        ],
      );
    }else if (rate.split(".")[0].contains("2")) {
      return  Row(
        children: const [
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
        ],
      ) ;
    }else if (rate.split(".")[0].contains("3")) {
      return  Row(
        children: const [
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
        ],
      ) ;
    }else if (rate .contains("4")) {
      return  Row(
        children: const [
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: appColors.white,),
        ],
      );
    } else if (rate.split(".")[0].contains("5")) {
      return  Row(
        children: const [
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
          Icon(Icons.star,color: Colors.yellowAccent,),
        ],
      );
    }else {
      return  Row(
        children: const [
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
          Icon(Icons.star,color: appColors.white,),
        ],
      );
    }
  }
}
