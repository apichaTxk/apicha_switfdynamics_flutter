import 'package:flutter/material.dart';
import 'package:swiftdynamic_test_flutter/PersonTabbar/PersonAllList/person_all_list.dart';

import '../../ProjectStyle/app_image.dart';
import '../../ProjectStyle/app_style.dart';

class ProvinceInside extends StatefulWidget {
  final String insert_prov;

  ProvinceInside({required this.insert_prov});

  @override
  State<ProvinceInside> createState() => _ProvinceInsideState();
}

class _ProvinceInsideState extends State<ProvinceInside> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.insert_prov,
          style: TextStyle(
            fontFamily: "Prompt",
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(wallpaperImg),
            fit: BoxFit.cover,
          ),
        ),
        child: PersonAllList(with_prov: widget.insert_prov,),
      ),
    );
  }
}
