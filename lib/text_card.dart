import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TextCard extends StatelessWidget {
  final String text;
  final Key key;
  TextCard({this.text,this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      key: key,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(8.h),
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
