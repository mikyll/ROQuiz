import 'package:flutter/material.dart';
import 'package:roquiz/views/ViewMenu.dart';

class ViewTopics extends StatelessWidget {
  // final List<String> selectedTopics;
  final List<String> selectedTopics = [
    "Programmazione Matematica",
    "Programmazione Lineare",
    "Algoritmo del Simplesso",
    "Dualità",
    "Programmazione Lineare Intera",
    "Complessità"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo[900],
        appBar: AppBar(
          title: const Text("Argomenti"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ViewMenu()));
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Domande Totali: 85"),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Domande per Quiz: 16"),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Domande Selezionate (Pool Quiz): 85"),
              ],
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Checkbox(value: true, onChanged: null),
                    Text("Programmazione Matematica"),
                    const Icon(Icons.arrow_forward_ios)
                  ],
                )
              ],
            )
          ],
        ));
  }

  /*Column buildTopics(List<String> topics) {
    final res = Column();
    for (String t in topics) {
      final r = Row(
        children: [
          const Checkbox(value: true, onChanged: null),
          Text(t),
          const Icon(Icons.arrow_forward)
        ],
      );
      res.children.add(r);
    }

    return res;
  }*/
}
