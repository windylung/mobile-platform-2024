import 'package:flutter/material.dart';
import 'PurposeEdit.dart';

class Purpose {
  String content;

  Purpose({required this.content});
}


class ppListScreen extends StatefulWidget{
  const ppListScreen({super.key});

  @override
  ppListScreenState createState() => ppListScreenState();
}

class ppListScreenState extends State<ppListScreen> {
  List<Purpose> pps = []; // 메모 저장하는 리스트

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
            title: Text(pps[index].content),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updatedPurpose = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            ppEditScreen(pp: pps[index],)));

                    if (updatedPurpose != null) {
                      setState(() {
                        pps[index] = updatedPurpose;
                      });
                    }
                    // 메모 수정 로직
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deletePurpose(index)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ppEditScreen()),
          );

          print(result.toString());
          if (result != null) {
            setState(() {
              pps.add(result);
;            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

}