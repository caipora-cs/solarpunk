import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       alignment: Alignment.center,
       child: Text('Home Screen'),
     ),
    );
  }
}