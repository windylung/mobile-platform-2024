import 'package:flutter/material.dart';
import 'package:mobile_platform_2024/color.dart';
class SelectAgendaPage extends StatefulWidget{
  const SelectAgendaPage({super.key});

  @override
  SelectAgendaPageState createState() => SelectAgendaPageState();
}

class SelectAgendaPageState extends State<SelectAgendaPage> {
  List<Map<String, dynamic>> histories = [
    {"id": 1, "agenda": "채소를 먹기 싫어요"},
    {"id": 2, "agenda": "agenda2"},
    {"id": 3, "agenda": "agenda3"}
  ];

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("안건 선택"),

      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ListView.builder(

                itemCount: histories.length,
                itemBuilder: (context, index) {
                  return InkWell(

                      child: Column(
                        children: [
                          Text("${histories[index]["id"]}"),
                          Text("${histories[index]["agenda"]}"),
                        ],
                      )
                  );
                }))
          ],
        ),
      ),
    );
  }
}