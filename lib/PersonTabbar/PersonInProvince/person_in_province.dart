import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_text.dart';

import '../../ProjectStyle/app_image.dart';
import '../../connect_to_http.dart';
import 'package:http/http.dart' as Http;

class PersonInProvince extends StatefulWidget {
  const PersonInProvince({Key? key}) : super(key: key);

  @override
  State<PersonInProvince> createState() => _PersonInProvinceState();
}

class _PersonInProvinceState extends State<PersonInProvince> {

  late List provinceData = [];
  List<dynamic> filterList = [];

  late Future<void> _loadDataFuture;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadDataFuture = loadData();
  }

  Future<void> loadData() async {
    await getProvinceList();
  }

  Future<void> refreshData() async {
    setState(() {
      _loadDataFuture = loadData();
    });
  }

  void searchList(String query){
    final List<dynamic> matches = [];

    if(query.isNotEmpty){
      for(final data in provinceData){
        if(data[p_name].toString().toLowerCase().contains(query.toLowerCase())
        ){
          matches.add(data);
        }
      }

      setState(() {
        filterList = matches;
      });
    } else {
      setState(() {
        filterList = List.from(provinceData);
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
                labelText: searchProvinceFieldText,
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

                        final provd = filterList[index];

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
                                  height: 70, // Change this to the desired height
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
                                  child: Center(
                                    child: Text(
                                      provd[p_name],
                                      style: TextStyle(
                                        fontFamily: "Prompt",
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
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

  Future getProvinceList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/x_get_province.php");
    var response = await Http.get(url);
    print(response.body);
    setState(() {
      provinceData = json.decode(response.body);
      filterList = List.from(provinceData);
    });
    print(provinceData);
  }
}
