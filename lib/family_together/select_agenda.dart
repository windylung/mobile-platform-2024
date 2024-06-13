import 'package:ducktogether/family_together/family_start.dart';
import 'package:ducktogether/shared_button.dart';
import 'package:flutter/material.dart';
import 'package:ducktogether/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SelectAgendaPage extends StatefulWidget {
  const SelectAgendaPage({super.key});

  @override
  SelectAgendaPageState createState() => SelectAgendaPageState();
}

class SelectAgendaPageState extends State<SelectAgendaPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> agendas = [];
  List<bool> _selectedAgenda = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAgendas();
  }

  Future<void> _loadAgendas() async {
    User? user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String familyId = await _getFamilyId(user.uid);
    QuerySnapshot querySnapshot = await _firestore
        .collection('families')
        .doc(familyId)
        .collection('agenda')
        .orderBy('timestamp', descending: true)
        .get();

    List<Map<String, dynamic>> loadedAgendas = [];
    for (var doc in querySnapshot.docs) {
      loadedAgendas.add({'id': doc.id, 'text': doc['text']});
    }

    setState(() {
      agendas = loadedAgendas;
      _selectedAgenda = List<bool>.filled(agendas.length, false);
      _isLoading = false;
    });
  }

  Future<void> _deleteSelectedAgendas() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    String familyId = await _getFamilyId(user.uid);
    for (int i = 0; i < agendas.length; i++) {
      if (_selectedAgenda[i]) {
        await _firestore
            .collection('families')
            .doc(familyId)
            .collection('agenda')
            .doc(agendas[i]['id'])
            .delete();
      }
    }

    _loadAgendas(); // Refresh agendas after deletion
  }

  Future<String> _getFamilyId(String userId) async {
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
    return userSnapshot['familyId'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: _selectedAgenda[index] ? colorDeepBlue : colorLightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        agendas[index]['text'],
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OrangeActionButton(text: "대화 시작", onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => FamilyStart(agendas: agendas,),
                ),
                );
              })

            )],
        ),
      ),
    );
  }
}
