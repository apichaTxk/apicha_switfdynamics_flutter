import 'package:flutter/material.dart';
import 'package:swiftdynamic_test_flutter/PersonInfo/Provider/provider_person.dart';
import 'package:swiftdynamic_test_flutter/PersonTabbar/person_tabbar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProviderPerson(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PersonTabbar(),
      debugShowCheckedModeBanner: false,
    );
  }
}