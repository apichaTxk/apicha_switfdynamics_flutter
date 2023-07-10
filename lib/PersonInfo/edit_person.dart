import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:swiftdynamic_test_flutter/PersonInfo/PersonModel/person_model.dart';
import 'package:swiftdynamic_test_flutter/PersonInfo/Provider/provider_person.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_style.dart';
import 'package:swiftdynamic_test_flutter/ProjectStyle/app_text.dart';

import '../ProjectStyle/app_image.dart';
import '../connect_to_http.dart';
import 'package:http/http.dart' as Http;

import 'package:provider/provider.dart';

import 'Validator/ex_validator.dart';

class EditPerson extends StatefulWidget {
  const EditPerson({Key? key}) : super(key: key);

  @override
  State<EditPerson> createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {

  int pp_id = 0;
  var pp_ic = TextEditingController();
  var pp_name = TextEditingController();
  var pp_sname = TextEditingController();
  var pp_birth = TextEditingController();
  var pp_addr = TextEditingController();
  var pp_road = TextEditingController();
  var pp_subdist = TextEditingController();
  var pp_dist = TextEditingController();
  String pp_prov = "";

  int _currentStep = 0;
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  late List provinceData = [];

  List<String> province_dropdown = [];
  String? selectedProvince;

  @override
  void initState(){
    super.initState();
    loadData();
    useProvider();
  }

  Future<void> loadData() async {
    await getProvinceList();
    for(var prov in provinceData){
      province_dropdown.add(prov[p_name_json]);
    }
  }

  Future<void> useProvider() async {
    final proPerson = Provider.of<ProviderPerson>(context, listen: false);

    pp_id = proPerson.pp_id;
    pp_ic = TextEditingController(text: proPerson.pp_ic);
    pp_name = TextEditingController(text: proPerson.pp_name);
    pp_sname = TextEditingController(text: proPerson.pp_sname);
    pp_birth = TextEditingController(text: proPerson.pp_birth);
    pp_addr = TextEditingController(text: proPerson.pp_addr);
    pp_road = TextEditingController(text: proPerson.pp_road);
    pp_subdist = TextEditingController(text: proPerson.pp_subdist);
    pp_dist = TextEditingController(text: proPerson.pp_dist);
    pp_prov = proPerson.pp_prov;
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
          title: editPersonAppBar,
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
                          print(pp_ic.text);
                          print(pp_name.text);
                          print(pp_sname.text);
                          print(pp_birth.text);
                          print(pp_addr.text);
                          print(pp_road.text);
                          print(pp_subdist.text);
                          print(pp_dist.text);
                          print(pp_prov);

                          UpdatePerson();
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
                        ElevatedButton(
                          onPressed: controls.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: (_currentStep == 1)
                              ? const Text('แก้ไขข้อมูลบุคคล', style: TextStyle(fontFamily: 'prompt',),)
                              : const Text('ต่อไป', style: TextStyle(fontFamily: 'prompt',),),
                        ),
                        if(_currentStep > 0)
                          TextButton(
                            onPressed: controls.onStepCancel,
                            child: const Text('ย้อนกลับ', style: TextStyle(fontFamily: 'prompt',color: Colors.white,),),
                          ),
                      ],
                    );
                  },
                  steps: [
                    Step(
                      state: _currentStep == 0 ? StepState.editing : StepState.indexed,
                      title: personStep1,
                      content: Form(
                        key: _formKeys[0],
                        child: Column(
                          children: <Widget>[
                            person_field("เลขบัตรประชาชน", 0, pp_ic),
                            person_field("ชื่อ", 1, pp_name),
                            person_field("นามสกุล", 2, pp_sname),
                            datetime_field(context, "วันเกิด", pp_birth)
                          ],
                        ),
                      ),
                    ),
                    Step(
                      state: _currentStep == 1 ? StepState.editing : StepState.indexed,
                      title: personStep2,
                      content: Form(
                        key: _formKeys[1],
                        child: Column(
                          children: <Widget>[
                            person_field("บ้านเลขที่, หมู่, ซอย", 3, pp_addr),
                            person_field("ถนน", 4, pp_road),
                            person_field("ตำบล", 5, pp_subdist),
                            person_field("อำเภอ", 6, pp_dist),
                            dropdown_field("จังหวัด :", pp_prov, province_dropdown, "เลือกจังหวัด", 0, 0, 40),
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

  Padding person_field(String labelName, int state_data, TextEditingController textx) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textx,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอกข้อมูล';
          }
          if(state_data == 0){
            if(value.contains(checkICNumerical)){
              return 'กรุณาใส่เฉพาะตัวเลขเท่านั้น';
            }
            if(value.length != 13){
              return 'กรุณากรอกข้อมูลให้ครบ 13 หลัก';
            }
          }
          if(state_data == 1 || state_data == 2){
            if (value.contains(' ')) {
              return 'ห้ามเว้นวรรค';
            }
            if (value.contains(checkNoNumerical)) {
              return 'ห้ามใส่ตัวเลข';
            }
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
            case 0: pp_ic.text = dataSource!;break;
            case 1: pp_name.text = dataSource!;break;
            case 2: pp_sname.text = dataSource!;break;
            case 3: pp_addr.text = dataSource!;break;
            case 4: pp_road.text = dataSource!;break;
            case 5: pp_subdist.text = dataSource!;break;
            case 6: pp_dist.text = dataSource!;break;
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
                value: selectedProvince = selected,
                items: sourceData.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(fontFamily: "Prompt"),),
                )).toList(),
                onChanged: (item) => setState(() {
                  if(state_ui == 0){
                    selectedProvince = item;
                  }

                  switch (state_data){
                    case 0: pp_prov = item!;break;
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

  Future UpdatePerson() async{
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse("https://morvita.cocopatch.com/x_update_person.php");
    Map data = {
      "pp_id": pp_id,
      "pp_ic": pp_ic.text,
      "pp_name": pp_name.text,
      "pp_sname": pp_sname.text,
      "pp_birth": pp_birth.text,
      "pp_addr": pp_addr.text,
      "pp_road": pp_road.text,
      "pp_subdist": pp_subdist.text,
      "pp_dist": pp_dist.text,
      "pp_prov": pp_prov,
    };
    var response = await Http.post(url, body: json.encode(data));
    print(response.body);

    var responseData = jsonDecode(response.body);

    if(responseData['message'] == "ชื่อนี้มีผู้ใช้อยู่แล้ว"){
      Navigator.pop(context);
      final text = "ข้อมูล \"ชื่อร้าน\" ซ้ำ กรุณากรอกใหม่อีกครั้ง";
      final snackBar = SnackBar(content: Text(text, style: TextStyle(fontFamily: "prompt"),),backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pop(context);
      Navigator.of(context).pop(true);
      final text = "แก้ไขข้อมูลบุคคลเสร็จสิ้น";
      final snackBar = SnackBar(content: Text(text, style: TextStyle(fontFamily: "prompt"),),backgroundColor: Colors.green,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
