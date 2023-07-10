import 'package:flutter/material.dart';
import 'package:swiftdynamic_test_flutter/PersonInfo/add_person.dart';
import 'package:swiftdynamic_test_flutter/PersonTabbar/PersonAllList/person_all_list.dart';
import 'package:swiftdynamic_test_flutter/PersonTabbar/PersonInProvince/person_in_province.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_color.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_style.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_text.dart';

import '../ProjectStyle/app_image.dart';

class PersonTabbar extends StatefulWidget {
  const PersonTabbar({Key? key}) : super(key: key);

  @override
  State<PersonTabbar> createState() => _PersonTabbarState();
}

class _PersonTabbarState extends State<PersonTabbar> {

  final List<String> tabbarName = [
    tabbarText1,
    tabbarText2,
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: firstAppBar,
          elevation: 5,
          centerTitle: true,
          bottom: TabBar(
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black26),
              tabs: [
                tabbarComponent(Icon(Icons.people), tabbarName[0]),
                tabbarComponent(Icon(Icons.location_city), tabbarName[1]),
              ]),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(45),
              ),
              gradient: LinearGradient(
                  colors: [primanyBlue, primaryGreen],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(45),
            ),
          ),
        ),

        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(wallpaperImg),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            children: [
              PersonAllList(with_prov: "0",),
              PersonInProvince(),
            ],
          ),
        ),

        //================================================================
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: primanyBlue.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 10,
              ),
            ],
          ),
          child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPerson(),
                  ),
                ).then((value) {
                  // if(value == true){
                  //   refreshData();
                  // }
                });
              },
              foregroundColor: Colors.white,
              backgroundColor: primanyBlue,
              splashColor: Colors.white,
              elevation: 0,
              icon: Icon(
                Icons.add,
                size: 25,
              ),
              label: addPersonButton
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Tab tabbarComponent(Icon tabbarIcon, String tabbarName) {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.transparent, width: 1)),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              tabbarIcon,
              SizedBox(width: 5,),
              Text(tabbarName, style: TextStyle(fontSize: 14, fontFamily: 'Prompt'),),
            ],
          ),
        ),
      ),
    );
  }
}
