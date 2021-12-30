import 'package:flutter/material.dart';
import 'package:roquiz/views/ViewMenu.dart';

class ViewTopics extends StatelessWidget {
  const ViewTopics({Key? key}) : super(key: key);

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
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ViewMenu()));
            },
          ),
        ),
        body: Column(
          children: [
            Row(
              children: const [
                Text("Domande Totali: "),
              ],
            ),
            Row(
              children: const [
                Text("Domande per Quiz: "),
              ],
            ),
            Row(
              children: const [
                Text("Domande Selezionate: "),
              ],
            ),
            Column(
              children: const [],
            )
          ],
        ));
  }
}
