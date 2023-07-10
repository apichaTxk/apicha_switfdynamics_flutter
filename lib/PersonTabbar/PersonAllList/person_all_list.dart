import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';
import 'package:swiftdynamic_test_flutter/PersonInfo/edit_person.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_text.dart';

import '../../PersonInfo/Provider/provider_person.dart';
import '../../ProjectStyle/app_image.dart';
import '../../connect_to_http.dart';
import 'package:http/http.dart' as Http;

class PersonAllList extends StatefulWidget {
  final String with_prov;

  PersonAllList({required this.with_prov});

  @override
  State<PersonAllList> createState() => _PersonAllListState();
}

class _PersonAllListState extends State<PersonAllList> {

  late List personData = [];
  List<dynamic> filterList = [];

  late Future<void> _loadDataFuture;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadDataFuture = loadData();
  }

  Future<void> loadData() async {
    await getPersonList(widget.with_prov);
  }

  Future<void> refreshData() async {
    setState(() {
      _loadDataFuture = loadData();
    });
  }

  void searchList(String query){
    final List<dynamic> matches = [];

    if(query.isNotEmpty){
      for(final data in personData){
        if(data[pp_ic_json].toString().toLowerCase().contains(query.toLowerCase())
            || data[pp_name_json].toString().toLowerCase().contains(query.toLowerCase())
            || data[pp_sname_json].toString().toLowerCase().contains(query.toLowerCase())
            || data[pp_prov_json].toString().toLowerCase().contains(query.toLowerCase())
        ){
          matches.add(data);
        }
      }

      setState(() {
        filterList = matches;
      });
    } else {
      setState(() {
        filterList = List.from(personData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child:  TextFormField(
              enabled: true,
              scrollPadding: EdgeInsets.all(10),
              controller: searchController,
              onChanged: searchList,
              decoration: InputDecoration(
                labelText: searchPersonFieldText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black54,),
                filled: true,
                fillColor: Colors.white54,
                labelStyle: TextStyle(
                  color: Colors.black54, // Set the label color to red when focused
                ),
              ),
              style: TextStyle(
                fontFamily: 'prompt',
              ),
            ),
          ),
          Expanded(
            child: filterList.isNotEmpty
                ? FutureBuilder(
              future: _loadDataFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                } else if(snapshot.hasError){
                  return Text('Error: ${snapshot.error}');
                }else{
                  return RefreshIndicator(
                    onRefresh: refreshData,
                    child: ListView.builder(
                      itemCount: filterList.length,
                      itemBuilder: (BuildContext buildContext, int index){

                        final pd = filterList[index];

                        String fullName = pd[pp_name_json]+" "+pd[pp_sname_json];

                        return Column(
                          children: [
                            InkWell(
                              onTap: (){
                                // Navigation push
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GlassmorphicContainer(
                                  width: 370,
                                  height: 135, // Change this to the desired height
                                  borderRadius: 20,
                                  blur: 20,
                                  alignment: Alignment.bottomCenter,
                                  border: 2,
                                  linearGradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFffffff).withOpacity(0.1),
                                        Color(0xFFFFFFFF).withOpacity(0.05),
                                      ],
                                      stops: [
                                        0.1,
                                        1,
                                      ]),
                                  borderGradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFffffff).withOpacity(0.5),
                                      Color((0xFFFFFFFF)).withOpacity(0.5),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 120,
                                              margin: EdgeInsets.only(right: 16),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                color: Colors.white,
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: Image.asset(
                                                  profileImg,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              fullName.length > 25 ? fullName.substring(0, 25) + "..." : fullName,
                                              style: TextStyle(
                                                  fontFamily: 'prompt',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 8,),
                                            Text(
                                              pd[pp_ic_json],
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                              pd[pp_birth_json],
                                              style: TextStyle(
                                                fontFamily: 'prompt',
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.more_horiz, color: Colors.white,),
                                              onPressed: (){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return BackdropFilter(
                                                      child: manageDialog(context, pd[pp_id_json], filterList, index),
                                                      filter: ImageFilter.blur(
                                                        sigmaX: 6,
                                                        sigmaY: 6,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                              ),
                            ),
                            if(index == filterList.length-1)
                              SizedBox(height: 70,),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
            )
                : Center(child: Text('ไม่มีข้อมูล', style: TextStyle(fontFamily: 'prompt', color: Colors.white),),),),
        ],
      ),
    );
  }

  AlertDialog manageDialog(BuildContext context, int pp_id, List<dynamic> currentPerson, int currentIndex) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "จัดการข้อมูลบุคคล",
        style: TextStyle(
          fontFamily: 'prompt',
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final proPerson = Provider.of<ProviderPerson>(context, listen: false);
                  final pd = currentPerson[currentIndex];

                  proPerson.pp_id = pd[pp_id_json];
                  proPerson.pp_ic = pd[pp_ic_json];
                  proPerson.pp_name = pd[pp_name_json];
                  proPerson.pp_sname = pd[pp_sname_json];
                  proPerson.pp_birth = pd[pp_birth_json];
                  proPerson.pp_addr = pd[pp_addr_json];
                  proPerson.pp_road = pd[pp_road_json];
                  proPerson.pp_subdist = pd[pp_subdist_json];
                  proPerson.pp_dist = pd[pp_dist_json];
                  proPerson.pp_prov = pd[pp_prov_json];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPerson(),
                    ),
                  ).then((value) {
                    if(value == true){
                      Navigator.pop(context);
                      refreshData();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // กำหนดขอบที่โค้งมน
                  ),
                  fixedSize: Size(200, 50), // กำหนดขนาดของปุ่ม
                  backgroundColor: Colors.blueAccent, // กำหนดสีส้ม
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 5,),
                    Text(
                      editPersonButtonText,
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BackdropFilter(
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'ต้องการลบข้อมูลบุคคลนี้หรือไม่',
                            style: TextStyle(
                              fontFamily: 'prompt',
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'ยกเลิก',
                                style: TextStyle(
                                    fontFamily: 'prompt',
                                    color: Colors.blue
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text(
                                'ลบข้อมูลบุคคล',
                                style: TextStyle(
                                    fontFamily: 'prompt',
                                    color: Colors.red
                                ),
                              ),
                              onPressed: () {
                                deletePerson(pp_id);
                              },
                            ),
                          ],
                        ),
                        filter: ImageFilter.blur(
                          sigmaX: 6,
                          sigmaY: 6,
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // กำหนดขอบที่โค้งมน
                  ),
                  fixedSize: Size(200, 50), // กำหนดขนาดของปุ่ม
                  backgroundColor: Colors.red, // กำหนดสีส้ม
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 5,),
                    Text(
                      'ลบข้อมูล',
                      style: TextStyle(
                        fontFamily: 'prompt',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'เสร็จสิ้น',
            style: TextStyle(
                fontFamily: 'prompt',
                color: Colors.blue
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Future getPersonList(String pp_prov) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/x_get_person.php?pp_prov=$pp_prov");
    var response = await Http.get(url);
    print(response.body);
    setState(() {
      personData = json.decode(response.body);
      filterList = List.from(personData);
    });
    print(personData);
  }

  Future deletePerson(int pp_id) async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/x_delete_person.php",);
    Map data = {
      "pp_id": pp_id,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);
    Navigator.pop(context);
    Navigator.pop(context);
    refreshData();
  }
}