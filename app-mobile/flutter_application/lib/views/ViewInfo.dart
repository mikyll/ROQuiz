import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/Settings.dart';
import 'package:url_launcher/url_launcher.dart';

const DEFAULT_SIZE = 50.0;

class ViewInfo extends StatefulWidget {
  const ViewInfo({Key? key, required this.settings}) : super(key: key);

  final Settings settings;

  @override
  State<StatefulWidget> createState() => ViewInfoState();
}

class ViewInfoState extends State<ViewInfo> with TickerProviderStateMixin {
  dynamic _time;
  double _size = DEFAULT_SIZE;
  double _maxSize = 0.0;
  bool _isPressedStar = false;

  void _increaseSize(int v) {
    setState(() {
      if (_size < _maxSize) {
        _size +=
            v * pow((DateTime.now().millisecondsSinceEpoch - _time) / 250, 2);
      } else {
        _size = DEFAULT_SIZE;
        _isPressedStar = false;
        _launchInBrowser("https://github.com/mikyll/ROQuiz");
      }
    });
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Info"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Text(
                  "ROQuiz v${widget.settings.VERSION_NUMBER}${widget.settings.VERSION_SUFFIX}",
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Expanded(
                  child: Text("Applicazione sviluppata da:",
                      style: TextStyle(fontSize: 18)),
                ),
                InkWell(
                  onTap: () {
                    _launchInBrowser("https://github.com/mikyll");
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("mikyll",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline)),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Expanded(
                    child: Text("Repository GitHub:",
                        style: TextStyle(fontSize: 18))),
                InkWell(
                  onTap: () {
                    _launchInBrowser("https://github.com/mikyll/ROQuiz");
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("mikyll/ROQuiz",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline)),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Expanded(
                  child: Text("Problemi con l'app?",
                      style: TextStyle(fontSize: 18)),
                ),
                InkWell(
                  onTap: () {
                    _launchInBrowser("https://github.com/mikyll/ROQuiz/issues");
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Apri una issue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline)),
                  ),
                ),
                const Text("su GitHub!", style: TextStyle(fontSize: 18)),
              ]),
              const SizedBox(height: 50),
              Container(
                color: Colors.indigo[700],
                height: 60,
                alignment: Alignment.center,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Ti sfido a tenere premuta la stellina",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      )),
                ),
              ),
              const Spacer(flex: 3)
            ],
          ),
        ),
      ),
      // CAGATE
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          _launchInBrowser("https://github.com/mikyll/ROQuiz");
        },
        onLongPressStart: (_) async {
          _isPressedStar = true;
          _time = DateTime.now().millisecondsSinceEpoch;
          _maxSize = MediaQuery.of(context).size.width - 50.0;
          do {
            _increaseSize(1);
            await Future.delayed(const Duration(milliseconds: 40));
          } while (_isPressedStar);
        },
        onLongPressEnd: (_) => {
          setState(() => {_isPressedStar = false})
        },
        child: InkWell(
          child: Container(
            alignment: Alignment.center,
            width: _size,
            height: _size,
            decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                borderRadius: BorderRadius.all(Radius.circular(_size))),
            child: Icon(
              Icons.star,
              size: _size,
              color: Colors.yellow,
            ),
          ),
        ),
      ),
    );
  }
}
