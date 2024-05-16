import 'package:flutter/material.dart';

class FamilyHistoryPage extends StatefulWidget {
  const FamilyHistoryPage({super.key});

  @override
  State<FamilyHistoryPage> createState() => FamilyHistoryPageState();
}

class FamilyHistoryPageState extends State<FamilyHistoryPage> {
  List<Map<String, dynamic>> histories = [
    {"id": 1, "agenda": "채소를 먹기 싫어요"},
    {"id": 2, "agenda": "agenda2"},
    {"id": 3, "agenda": "agenda3"}
  ];
  final _controller = TextEditingController();

  void findHistory(keyword) async {
    print(keyword);
    // 검색 알고리즘
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchBar(
              controller: _controller,
              trailing: [
                IconButton(
                  onPressed: () {
                    findHistory(_controller.text);
                  },
                  icon: const Icon(Icons.search),
                )
              ],
              elevation: MaterialStatePropertyAll(2),
              hintText: "검색어를 입력하세요",
            ),

            Expanded(child: ListView.builder(

                itemCount: histories.length,
                itemBuilder: (context, index) {
                  return Container(
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
