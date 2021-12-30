import 'package:flutter/material.dart';
import 'package:roquiz/constants.dart';
import 'package:roquiz/views/ViewTopics.dart';
import 'package:websafe_svg/websafe_svg.dart';

/*class ViewMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(children: [
              
            ],)
          ],
        ),
      ),
    );
  }
}*/

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
              WebsafeSvg.asset("assets/icons/test-svgrepo-com.svg"),
              /*CircleAvatar(
                radius: 100,
                backgroundColor: Colors.blue[900],
                child: const Icon(
                  Icons.quiz,
                  size: 100,
                  color: Colors.black,
                ),
              ),*/
              const Text("ROquiz",
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold, /*fontStyle: FontStyle.italic*/
                  )),
              Text(
                "v1.2",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.grey[500],
                ),
              ),
              const Spacer(),
              // Buttons
              InkWell(
                onTap: () {},
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
                onTap: () {},
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewTopics()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 400, // fix: fit <->
                    height: 60,
                    decoration: const BoxDecoration(
                        gradient: kPrimaryGradient,
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
              ),
              const SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Domande: "),
                    Text("16 su 85"),
                    SizedBox(width: 20),
                    Text("Tempo: "),
                    Text("18 min"),
                  ]),
              const Spacer(flex: 1),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
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
                      const SizedBox(height: 20),
                    ],
                  ),
                  const SizedBox(width: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
