import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/Question.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/model/Settings.dart';
import 'package:roquiz/views/ViewQuiz.dart';
import 'package:roquiz/views/ViewSettings.dart';
import 'package:roquiz/views/ViewTopics.dart';
import 'package:roquiz/views/ViewInfo.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewMenu extends StatefulWidget {
  ViewMenu({Key? key}) : super(key: key);

  QuestionRepository qRepo = QuestionRepository();
  Settings settings = Settings(16, 18, false, false);
  List<Question> questions = [];

  @override
  State<StatefulWidget> createState() => ViewMenuState();
}

class ViewMenuState extends State<ViewMenu> {
  bool _topicsPresent = false;
  List<bool> selectedTopics = [];

  void _initTopics() {
    setState(() {
      for (int i = 0; i < widget.qRepo.topics.length; i++) {
        selectedTopics.add(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.qRepo.loadFile("assets/Domande.txt").then((value) => {
          _initTopics(),
          setState(() {
            _topicsPresent = widget.qRepo.hasTopics();
          })
        });

    // navigate to ViewQuiz, passing the questions pool (selected topics)
    void _navigateToQuiz() {
      // NB: the timer starts inside the ViewQuiz
    }
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              //WebsafeSvg.asset("icons/icon-test.svg", width: 300, height: 300),
              const Text("ROQuiz",
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold, /*fontStyle: FontStyle.italic*/
                  )),
              Text(
                "v1.3-mobile_beta",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[500],
                ),
              ),
              const Spacer(flex: 2),
              // Buttons
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewQuiz(qRepo: QuestionRepository())));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 400, // fix: fit <->
                  height: 60,
                  decoration: const BoxDecoration(
                      gradient: kPrimaryGradient,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Text(
                    "Avvia",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                enableFeedback: true,
                onTap: _topicsPresent
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewTopics(
                                      qRepo: widget.qRepo,
                                      settings: widget.settings,
                                      selectedTopics: selectedTopics,
                                    )));
                      }
                    : null,
                // remove those to enable splash effects
                splashColor: _topicsPresent ? Colors.transparent : null,
                hoverColor: _topicsPresent ? Colors.transparent : null,
                highlightColor: _topicsPresent ? Colors.transparent : null,
                child: Container(
                  alignment: Alignment.center,
                  width: 400, // fix: fit <->
                  height: 60,
                  decoration: _topicsPresent
                      ? const BoxDecoration(
                          gradient: kPrimaryGradient,
                          borderRadius: BorderRadius.all(Radius.circular(30)))
                      : const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0x8846A0AE), Color(0x8800FFCB)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: const Text(
                    "Argomenti",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.format_list_numbered_rounded,
                      color: Colors.grey,
                    ),
                    Text(
                        "Domande: ${widget.settings.questionNumber} su ${widget.qRepo.questions.length}"),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.timer_rounded,
                      color: Colors.grey,
                    ),
                    Text("Tempo: ${widget.settings.timer} min"),
                  ]),
              const SizedBox(height: 20),
              InkWell(
                  onTap: () {
                    _launchInBrowser("https://github.com/mikyll/ROQuiz");
                  },
                  child: Container(
                    color: Colors.indigo[700],
                    height: 120,
                    alignment: Alignment.center,
                    child: const Text(
                        "Se l'app ti è piaciuta, considera di lasciare una stellina alla repository GitHub!\n\nBasta un click qui: https://github.com/mikyll/ROQuiz",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  )),
              const Spacer(flex: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      InkWell(
                        // remove those to enable splash effects
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewSettings()));
                        */
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 60, // fix: fit <->
                          height: 60,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0x8846A0AE), Color(0x8800FFCB)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: const Icon(
                            Icons.settings,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewInfo()));*/
                        },
                        // remove those to enable splash effects
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          alignment: Alignment.center,
                          width: 60, // fix: fit <->
                          height: 60,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0x8846A0AE), Color(0x8800FFCB)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: const Icon(
                            Icons.info,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
