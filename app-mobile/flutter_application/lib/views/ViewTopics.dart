import 'package:flutter/material.dart';
import 'package:roquiz/model/QuestionRepository.dart';
import 'package:roquiz/model/Settings.dart';

class ViewTopics extends StatefulWidget {
  ViewTopics(
      {Key? key,
      required this.qRepo,
      required this.settings,
      required this.updateQuizPool,
      required this.selectedTopics})
      : super(key: key);

  final QuestionRepository qRepo;
  final Settings settings;
  final Function(int) updateQuizPool;
  List<bool> selectedTopics;

  @override
  State<StatefulWidget> createState() => ViewTopicsState();
}

class ViewTopicsState extends State<ViewTopics> {
  List<bool> enabledTopics = [];
  int currentQuizPool = 0;

  void _selectTopic(int index) {
    setState(() {
      widget.selectedTopics[index] = !widget.selectedTopics[index];
      _updatePool();
      _updateEnabledTopics();
    });
  }

  void _updateEnabledTopics() {
    setState(() {
      for (int i = 0; i < enabledTopics.length; i++) {
        // se il numero del pool meno queste è minore del numero di domande nel quiz
        enabledTopics[i] = currentQuizPool - widget.qRepo.qNumPerTopic[i] >=
            widget.settings.questionNumber;
      }
    });
  }

  int _getPoolSize() {
    int res = 0;
    for (int i = 0; i < widget.selectedTopics.length; i++) {
      res += widget.selectedTopics[i] ? widget.qRepo.qNumPerTopic[i] : 0;
    }
    return res;
  }

  void _updatePool() {
    setState(() {
      int res = 0;
      for (int i = 0; i < enabledTopics.length; i++) {
        res += widget.selectedTopics[i] ? widget.qRepo.qNumPerTopic[i] : 0;
      }
      currentQuizPool = res;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentQuizPool = _getPoolSize();
      for (int i = 0; i < widget.selectedTopics.length; i++) {
        enabledTopics.add(widget.selectedTopics[i]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.updateQuizPool(currentQuizPool);
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.indigo[900],
          appBar: AppBar(
            title: const Text("Argomenti"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                widget.updateQuizPool(currentQuizPool);
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              ...List.generate(
                widget.qRepo.getTopics().length,
                (index) => InkWell(
                  enableFeedback: true,
                  onTap: () {
                    if (enabledTopics[index] || !widget.selectedTopics[index]) {
                      _selectTopic(index);
                    }
                  },
                  child: Column(children: [
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            checkColor: Colors.black,
                            value: widget.selectedTopics[index],
                            onChanged: (_) => enabledTopics[index] ||
                                    !widget.selectedTopics[index]
                                ? _selectTopic(index)
                                : null),
                        Expanded(
                          child: Text(
                              "${widget.qRepo.topics[index]} (${widget.qRepo.qNumPerTopic[index]})",
                              style: const TextStyle(fontSize: 20)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            /*
                            // coming in v1.5
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewQuestions()));*/
                          },
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(children: [
                  Expanded(
                    child: Container(
                        color: Colors.indigo[700],
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Domande Totali: "),
                        )),
                  ),
                  Container(
                      color: Colors.indigo[700],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.qRepo.questions.length}"),
                      )),
                ]),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(children: [
                  Expanded(
                    child: Container(
                        color: Colors.indigo[700],
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Dimensione Pool Corrente: "),
                        )),
                  ),
                  Container(
                      color: Colors.indigo[700],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("$currentQuizPool",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      )),
                ]),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(children: [
                  Expanded(
                    child: Container(
                        color: Colors.indigo[700],
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Domande per Quiz: "),
                        )),
                  ),
                  Container(
                      color: Colors.indigo[700],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.settings.questionNumber}"),
                      )),
                ]),
              ),
            ],
          )),
    );
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
