import 'package:flutter/material.dart';
import 'my_answer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "answer screen",
      home: ppListScreen(),
    );
  }
}

class Purpose {
  String content;

  Purpose({required this.content});
}

class ppListScreen extends StatefulWidget {
  const ppListScreen({super.key});

  @override
  ppListScreenState createState() => ppListScreenState();
}

class ppListScreenState extends State<ppListScreen> {
  List<Purpose> pps = []; // 답변 저장하는 리스트

  void addPurpose(Purpose purpose) {
    setState(() {
      pps.add(purpose);
    });
  }

  void deletePurpose(int index) {
    setState(() {
      pps.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("답변 리스트"),
      ),
      body: ListView.builder(
        itemCount: pps.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              pps[index].content,
              maxLines: 1, // 줄 수 제한
              overflow: TextOverflow.ellipsis, // 내용이 길면 생략 부호(...) 표시
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(pps[index].content),
                      ),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('수정'),
                        onTap: () async {
                          Navigator.of(context).pop(); // 먼저 바텀 시트를 닫습니다
                          final updatedPurpose = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ppEditScreen(pp: pps[index]),
                            ),
                          );

                          if (updatedPurpose != null) {
                            setState(() {
                              pps[index] = updatedPurpose;
                            });
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('삭제'),
                        onTap: () {
                          setState(() {
                            pps.removeAt(index);
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.close),
                        title: const Text('닫기'),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updatedPurpose = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ppEditScreen(pp: pps[index]),
                      ),
                    );

                    if (updatedPurpose != null) {
                      setState(() {
                        pps[index] = updatedPurpose;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deletePurpose(index),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ppEditScreen()),
          );

          if (result != null) {
            setState(() {
              pps.add(result);
              print(pps);
            });
          }
        },
        backgroundColor: const Color(0xFFFFC076),
        child: const Icon(Icons.add),
      ),
    );
  }
}