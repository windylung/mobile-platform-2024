import 'package:flutter/material.dart';
import 'package:ducktogether/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgendaInputPage extends StatefulWidget {
  const AgendaInputPage({super.key});

  @override
  State<AgendaInputPage> createState() => _AgendaInputPageState();
}

class _AgendaInputPageState extends State<AgendaInputPage> {
  final List<String> _agendas = [];
  final _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadAgendas();
  }

  Future<void> _loadAgendas() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    String familyId = await _getFamilyId(user.uid);
    QuerySnapshot querySnapshot = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('agenda')
        .where('uid', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    List<String> loadedAgendas = [];
    for (var doc in querySnapshot.docs) {
      loadedAgendas.add(doc['text']);
    }

    setState(() {
      _agendas.addAll(loadedAgendas.reversed);
    });
  }

  Future<void> _saveAgenda(String text) async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    String familyId = await _getFamilyId(user.uid);
    await _firestore.collection('families').doc(familyId).collection('agenda').add({
      'text': text,
      'uid': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _agendas.add(text);
      _controller.text = '';
    });
  }

  Future<String> _getFamilyId(String userId) async {
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
    return userSnapshot['familyId'];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _agendas.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: colorLightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _agendas[index],
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '안건',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        controller: _controller,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _saveAgenda(_controller.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "확인",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
