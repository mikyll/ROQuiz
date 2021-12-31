import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/views/ViewMenu.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class ROquizApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ROquizAppState();
  }
}

class _ROquizAppState extends State<ROquizApp> {
  QuestionRepository qRepo;
  List<bool> selectedTopics;

  _ROquizAppState() {
    final file = File("assets/domande.txt");
    Stream<String> lines =
        file.openRead().transform(utf8.decoder).transform(LineSplitter());
      try {
        await for (String l in lines) {
          
        }
      }
      catch (e) {
        print("Error: $e");
      }
  }
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
/*
Widget titleSection = Container(
  padding: const EdgeInsets.all(32),
  child: Column(
    children: [],
  ),
);

Widget titleSection = Container(
  padding: const EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
        /*1*/
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: const Text(
                'Oeschinen Lake Campground',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Kandersteg, Switzerland',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
      /*3*/
      Icon(
        Icons.star,
        color: Colors.red[500],
      ),
      const Text('41'),
    ],
  ),
);
*/