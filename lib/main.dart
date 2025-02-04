import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qrapp/pages/home.dart';

void main() async {
  await Hive.initFlutter();

  //open the box
  var box = await Hive.openBox('qrBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          fontFamily: 'Satoshi'),
      title: 'QR App',
      home: Home(),
    );
  }
}
