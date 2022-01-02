import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/views/ViewQuiz.dart';
import 'package:roquiz/views/ViewTopics.dart';
import 'package:websafe_svg/websafe_svg.dart';

class ViewMenu extends StatelessWidget {
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
              const Spacer(flex: 1),
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
              const Spacer(),
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
                onTap: () {
                  /*Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewTopics()));*/
                },
                // remove those to enable splash effects
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  width: 400, // fix: fit <->
                  height: 60,
                  decoration: const BoxDecoration(
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
                  children: const [
                    Icon(
                      Icons.format_list_numbered_rounded,
                      color: Colors.grey,
                    ),
                    Text("Domande: 16 su 85"),
                    SizedBox(width: 20),
                    Icon(
                      Icons.timer_rounded,
                      color: Colors.grey,
                    ),
                    Text("Tempo: 18 min"),
                  ]),
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
                        onTap: () {},
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
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: 60, // fix: fit <->
                          height: 60,
                          decoration: const BoxDecoration(
                              gradient: kPrimaryGradient,
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
