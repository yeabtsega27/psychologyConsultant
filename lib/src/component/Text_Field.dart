// // ignore_for_file: file_names
//
// import 'package:flutter/material.dart';
// import 'package:psychological_consultation/src/model/appColors.dart';
//
//
//
// // ignore: camel_case_types, must_be_immutable
// class Text_Field extends StatefulWidget {
//   // ignore: non_constant_identifier_names
//   Text_Field({super.key, Key? Key,required this.labletext,required this.isPassword ,required this.controller});
//   String labletext;
//   bool isPassword;
//   bool _obscureText=false;
//   final TextEditingController controller;
//   @override
//   // ignore: no_logic_in_create_state
//   State<Text_Field> createState() => _Text_FieldState(controller: controller);
// }
//
// // ignore: camel_case_types
// class _Text_FieldState extends State<Text_Field> {
//   _Text_FieldState({required this.controller});
//
//   late TextEditingController controller;
//   @override
//   Widget build(BuildContext context) {
//     if(widget.isPassword){
//       return Container(
//         padding: const EdgeInsets.only(left: 10),
//         decoration: BoxDecoration(
//           color: appColors.white,
//           borderRadius: BorderRadius.circular(14)
//         ),
//         child: TextFormField(
//           onChanged: (va){
//             print("widd ${widget.controller.text}");
//           },
//           validator: (value) {
//             if (value == null || value.isEmpty || value.length<6) {
//               return 'Please enter correct password ';
//             }
//             return null;
//           },
//           controller: controller,
//           obscureText: !widget._obscureText,
//           decoration: InputDecoration(
//               hintText: widget.labletext,
//               border: InputBorder.none,
//               fillColor: Colors.white,
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   widget._obscureText ? Icons.visibility:Icons.visibility_off,
//                 ),
//                 onPressed: (){
//                   setState(() {
//                     widget._obscureText=!widget._obscureText;
//                   });
//                 },
//               )
//           ),
//         ),
//
//       );
//     }
//     return Container(
//       padding: const EdgeInsets.only(left: 10),
//
//       decoration: BoxDecoration(
//         color: appColors.white,
//         borderRadius: BorderRadius.circular(14)
//       ),
//       child: TextFormField(
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter some text';
//           }
//           return null;
//         },
//         controller: controller,
//         obscureText: widget._obscureText,
//         decoration: InputDecoration(
//           hintText: widget.labletext,
//           border: InputBorder.none,
//         ),
//       ),
//
//     );
//   }
// }


// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class Text_Field extends StatefulWidget {
  // ignore: non_constant_identifier_names
  Text_Field({super.key, Key? Key,required this.labletext,required this.isPassword ,required this.controller});
  String labletext;
  bool isPassword;
  bool _obscureText=false;
  TextEditingController controller;
  @override
  // ignore: no_logic_in_create_state
  State<Text_Field> createState() => _Text_FieldState(controller: controller);
}

// ignore: camel_case_types
class _Text_FieldState extends State<Text_Field> {
  _Text_FieldState({required this.controller});

  late TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    if(widget.isPassword){
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),

        child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty || value.length<6) {
              return 'Please enter correct password ';
            }
            return null;
          },
          controller: controller,
          obscureText: !widget._obscureText,
          decoration: InputDecoration(
              labelText: widget.labletext,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  widget._obscureText ? Icons.visibility:Icons.visibility_off,
                ),
                onPressed: (){
                  setState(() {
                    widget._obscureText=!widget._obscureText;
                  });
                },
              )
          ),
        ),

      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),

      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: controller,
        obscureText: widget._obscureText,
        decoration: InputDecoration(
          labelText: widget.labletext,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

