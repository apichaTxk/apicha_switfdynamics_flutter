import 'package:flutter/material.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_color.dart';
import 'app_text.dart';

// App Bar
var firstAppBar = Text(
  firstAppBarText,
  style: TextStyle(
    fontFamily: "Prompt",
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
);

var addPersonAppBar = Text(
  addPersonAppBarText,
  style: TextStyle(
    fontFamily: "Prompt",
    color: Colors.white,
  ),
);

var editPersonAppBar = Text(
  editPersonAppBarText,
  style: TextStyle(
    fontFamily: "Prompt",
    color: primanyBlue,
  ),
);

// Button
var addPersonButton = Text(
  addPersonButtonText,
  style: TextStyle(
      fontFamily: 'Prompt',
      fontSize: 15,
      fontWeight: FontWeight.w600
  ),
);

// Add Person
var addPersonStep1 = Text('ข้อมูลส่วนตัว',style: TextStyle(fontFamily: 'prompt'),);
var addPersonStep2 = Text('ที่อยู่ตามบัตรประชาชน',style: TextStyle(fontFamily: 'prompt'),);