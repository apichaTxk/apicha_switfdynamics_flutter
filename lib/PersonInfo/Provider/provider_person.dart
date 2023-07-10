import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ProviderPerson with ChangeNotifier{
  int pp_id = 0;
  String pp_ic = "";
  String pp_name = "";
  String pp_sname = "";
  String pp_birth = "";
  String pp_addr = "";
  String pp_road = "";
  String pp_subdist = "";
  String pp_dist = "";
  String pp_prov = "";

  void setData(
      int new_pp_id,
      String new_pp_ic,
      String new_pp_name,
      String new_pp_sname,
      String new_pp_birth,
      String new_pp_addr,
      String new_pp_road,
      String new_pp_subdist,
      String new_pp_dist,
      String new_pp_prov,){

    pp_id = new_pp_id;
    pp_ic = new_pp_ic;
    pp_name = new_pp_name;
    pp_sname = new_pp_sname;
    pp_birth = new_pp_birth;
    pp_addr = new_pp_addr;
    pp_road = new_pp_road;
    pp_subdist = new_pp_subdist;
    pp_dist = new_pp_dist;
    pp_prov = new_pp_prov;

    notifyListeners();
  }
}