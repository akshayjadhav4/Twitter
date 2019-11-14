import 'package:flutter/material.dart';
import 'screens/HomePage.dart';
import 'SignInPage.dart';
import 'SignUpPage.dart';
import 'FirstScreen.dart';
void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),

      //Defined Routes
      routes: <String,WidgetBuilder>{
        "/SignInPage":(BuildContext context)=> SignInPage(),
        "/SignUpPage":(BuildContext context)=> SignUpPage(),
        "/FirstScreen":(BuildContext context)=>FirstScreen(),
      },
    );
  }
}