import 'package:flutter/material.dart';
import 'package:mobile_platform_2024/color.dart';

class SelectAgendaPage extends StatefulWidget {
  const SelectAgendaPage({super.key});

  @override
  SelectAgendaPageState createState() => SelectAgendaPageState();
}

class SelectAgendaPageState extends State<SelectAgendaPage> {
  List<Map<String, dynamic>> agendas = [
    {"id": 1, "agenda": "채소를 먹기 싫어요"},
    {"id": 2, "agenda": "agenda2"},
    {"id": 3, "agenda": "agenda3"}
  ];

  List<bool> _selectedAgenda = [];

  @override
  void initState() {
    super.initState();
    _selectedAgenda = List<bool>.filled(agendas.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("안건 선택"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: agendas.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedAgenda[index] = !_selectedAgenda[index];
                            });
                          },
                          child: Container(
                            color: _selectedAgenda[index]
                                ? colorDeepBlue
                                : colorLightBlue,
                            child: Column(
                              children: [
                                Text("${agendas[index]["id"]}"),
                                Text("${agendas[index]["agenda"]}"),
                              ],
                            ),
                          ));
                    })),
            ElevatedButton(
              onPressed: () {
                print(_selectedAgenda);
              },
              child: const Text("대화시작"),
            )
          ],
        ),
      ),
    );
  }
}

// RangeError (index) Invalid value : Valid Value range is Empty : 0