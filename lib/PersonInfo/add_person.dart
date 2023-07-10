import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:swiftdynamic_test_flutter/PersonInfo/PersonModel/person_model.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_style.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_text.dart';

import '../ProjectStyle/app_image.dart';
import '../connect_to_http.dart';
import 'package:http/http.dart' as Http;

class AddPerson extends StatefulWidget {
  const AddPerson({Key? key}) : super(key: key);

  @override
  State<AddPerson> createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  int _currentStep = 0;
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  late List provinceData = [];

  List<String> province_dropdown = [];
  String? selectedProvince;

  TextEditingController person_birth = TextEditingController();

  PersonModel person_add = PersonModel(
      pp_date: "",
      pp_time: "",
      pp_ic: "",
      pp_name: "",
      pp_sname: "",
      pp_birth: "",
      pp_addr: "",
      pp_road: "",
      pp_subdist: "",
      pp_dist: "",
      pp_prov: ""
  );

  @override
  void initState(){
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await getProvinceList();
    for(var prov in provinceData){
      province_dropdown.add(prov[p_name]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: addPersonAppBar,
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
          child: SafeArea(
            child: GlassmorphicFlexContainer(
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Container(
                child: Stepper(
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if(_formKeys[_currentStep].currentState!.validate()){
                      setState(() {
                        _formKeys[_currentStep].currentState!.save();
                        if (_currentStep < 1) {
                          _currentStep++;
                        } else {
                          final DateFormat formatter = DateFormat('d-M-yyyy');
                          final String today_date = formatter.format(DateTime.now());
                          person_add.pp_date = set_new_date(today_date);

                          final DateTime now = DateTime.now();
                          final String today_time = DateFormat('HH:mm').format(now);
                          person_add.pp_time = today_time;

                          person_add.pp_birth = person_birth.text;

                          print(person_add.pp_date);
                          print(person_add.pp_time);
                          print(person_add.pp_ic);
                          print(person_add.pp_name);
                          print(person_add.pp_sname);
                          print(person_add.pp_birth);
                          print(person_add.pp_addr);
                          print(person_add.pp_road);
                          print(person_add.pp_subdist);
                          print(person_add.pp_dist);
                          print(person_add.pp_prov);

                          addProson();
                        }
                      });
                    }
                  },
                  onStepCancel: () {
                    setState(() {
                      if (_currentStep > 0) {
                        _currentStep--;
                      } else {
                        _currentStep = 0;
                      }
                    });
                  },
                  controlsBuilder: (BuildContext context, ControlsDetails controls) {
                    return Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: controls.onStepContinue,
                          child: (_currentStep == 1) ? const Text('เพิ่มข้อมูลบุคคล') : const Text('ต่อไป'),
                        ),

                        if(_currentStep > 0)
                          TextButton(
                            onPressed: controls.onStepCancel,
                            child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey),),
                          ),
                      ],
                    );
                  },
                  steps: [
                    Step(
                      state: _currentStep == 0 ? StepState.editing : StepState.indexed,
                      title: addPersonStep1,
                      content: Form(
                        key: _formKeys[0],
                        child: Column(
                          children: <Widget>[
                            person_field("เลขบัตรประชาชน", 0),
                            person_field("ชื่อ", 1),
                            person_field("นามสกุล", 2),
                            datetime_field(context, "วันเกิด", person_birth)
                          ],
                        ),
                      ),
                    ),
                    Step(
                      state: _currentStep == 1 ? StepState.editing : StepState.indexed,
                      title: addPersonStep2,
                      content: Form(
                        key: _formKeys[1],
                        child: Column(
                          children: <Widget>[
                            person_field("บ้านเลขที่, หมู่, ซอย", 3),
                            person_field("ถนน", 4),
                            person_field("ตำบล", 5),
                            person_field("อำเภอ", 6),
                            dropdown_field("จังหวัด :", selectedProvince, province_dropdown, "เลือกจังหวัด", 0, 0, 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //============================================================================

  Padding person_field(String labelName, int state_data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: labelName,
          labelStyle: TextStyle(
            fontFamily: "Prompt",
            color: Colors.black54,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: Colors.white54,
        ),
        style: TextStyle(
          fontFamily: "Prompt",
        ),
        keyboardType: (state_data == 0)? TextInputType.number : TextInputType.text,
        maxLength: (state_data == 0)? 13 : 50,
        onSaved: (dataSource){
          switch (state_data){
            case 0: person_add.pp_ic = dataSource!;break;
            case 1: person_add.pp_name = dataSource!;break;
            case 2: person_add.pp_sname = dataSource!;break;
            case 3: person_add.pp_addr = dataSource!;break;
            case 4: person_add.pp_road = dataSource!;break;
            case 5: person_add.pp_subdist = dataSource!;break;
            case 6: person_add.pp_dist = dataSource!;break;
          }
        },
      ),
    );
  }

  Padding datetime_field(BuildContext context, String lText, TextEditingController date_se) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }
          return null;
        },
        controller: date_se,
        readOnly: true,
        onTap: () async{
          DateTime? pickeddate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );

          if(pickeddate != null){
            setState(() {
              date_se.text = set_new_date(DateFormat('d-M-yyyy').format(pickeddate));
            });
          }
        },

        decoration: InputDecoration(
          labelText: lText,
          labelStyle: TextStyle(
            fontFamily: "Prompt",
            color: Colors.black54,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: Colors.white54,
          suffixIcon: Icon(Icons.calendar_month, color: Colors.black54,),
        ),
        style: TextStyle(
          fontFamily: "Prompt",
        ),
      ),
    );
  }

  Padding dropdown_field(String headText, String? selected, List<String> sourceData, String labelText, int state_ui, int state_data, double size_width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headText,
            style: TextStyle(
              fontFamily: "Prompt",
              fontSize: 18,
            ),
          ),
          SizedBox(width: size_width,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white54,
              ),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: selected,
                items: sourceData.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(fontFamily: "Prompt"),),
                )).toList(),
                onChanged: (item) => setState(() {
                  if(state_ui == 0){
                    selectedProvince = item;
                  }

                  switch (state_data){
                    case 0: person_add.pp_prov = item!;break;
                  }
                }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกข้อมูล';
                  }
                  return null;
                },
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    labelText,
                    style: TextStyle(color: Colors.black54, fontFamily: "Prompt"),
                  ),
                ),
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String set_new_date(String oldDate){
    String date = oldDate;
    List<String> dateParts = date.split('-');

    switch (dateParts[1]){
      case "1": dateParts[1] = "มกราคม";break;
      case "2": dateParts[1] = "กุมภาพันธ์";break;
      case "3": dateParts[1] = "มีนาคม";break;
      case "4": dateParts[1] = "เมษายน";break;
      case "5": dateParts[1] = "พฤษภาคม";break;
      case "6": dateParts[1] = "มิถุนายน";break;
      case "7": dateParts[1] = "กรกฎาคม";break;
      case "8": dateParts[1] = "สิงหาคม";break;
      case "9": dateParts[1] = "กันยายน";break;
      case "10": dateParts[1] = "ตุลาคม";break;
      case "11": dateParts[1] = "พฤศจิกายน";break;
      case "12": dateParts[1] = "ธันวาคม";break;
    }

    int new_year = int.parse(dateParts[2])+543;

    String finish_date = "${dateParts[0]} ${dateParts[1]} ${new_year}";

    return finish_date;
  }

  Future getProvinceList() async{
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/x_get_province.php");
    var response = await Http.get(url);
    print(response.body);
    provinceData = json.decode(response.body);
    print(provinceData);
  }

  Future addProson() async{
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/x_insert_person.php");
    Map data = {
      "pp_date": person_add.pp_date,
      "pp_time": person_add.pp_time,
      "pp_ic": person_add.pp_ic,
      "pp_name": person_add.pp_name,
      "pp_sname": person_add.pp_sname,
      "pp_birth": person_add.pp_birth,
      "pp_addr": person_add.pp_addr,
      "pp_road": person_add.pp_road,
      "pp_subdist": person_add.pp_subdist,
      "pp_dist": person_add.pp_dist,
      "pp_prov": person_add.pp_prov,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);

    var responseData = jsonDecode(response.body);

    if(responseData['message'] == "ชื่อนี้มีผู้ใช้อยู่แล้ว"){
      Navigator.pop(context);
      String text = "ข้อมูล \"เลขบัตรประชาชน\" ซ้ำ กรุณากรอกใหม่อีกครั้ง";
      final snackBar = SnackBar(content: Text(text, style: TextStyle(fontFamily: "prompt"),),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pop(context);
      //Navigator.of(context).pop(true);
      Navigator.pop(context);
      final text = "อัพโหลดข้อมูลร้านค้าเสร็จสิ้น";
      final snackBar = SnackBar(content: Text(text, style: TextStyle(fontFamily: "prompt"),),backgroundColor: Colors.green,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
