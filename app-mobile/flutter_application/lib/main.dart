import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/views/ViewMenu.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROquiz',
      theme: ThemeData.dark(),
      home: ViewMenu(),
    );
  }
}
