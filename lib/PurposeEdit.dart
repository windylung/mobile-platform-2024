import 'package:flutter/material.dart';

import '../PurposeList.dart';

class ppEditScreen extends StatefulWidget {
  final Purpose? pp;

  const ppEditScreen({super.key, this.pp});

  @override
  ppEditScreenState createState() => ppEditScreenState();
}

class ppEditScreenState extends State<ppEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _content;

  @override // 가장 먼저 호출
  void initState() {
    super.initState();
    if (widget.pp != null) {

      _content = widget.pp!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pp == null ? "새 답변 작성" : "답변 수정"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: _content,
              decoration: const InputDecoration(labelText: "내용"),
              onSaved: (value) => _content = value,
              validator: (value) {
                if (value!.isEmpty) {
                  return "내용을 입력하세요";
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newPurpose = Purpose(content: _content!);

                    Navigator.pop(context, newPurpose);
                  }
                },
                child: const Text("저장"))
          ],
        ),
      ),
    );
  }
}
