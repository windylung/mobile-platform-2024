import 'package:ducktogether/shared_button.dart';
import 'package:flutter/material.dart';
import 'package:ducktogether/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class FamilyStart extends StatefulWidget {
  final List<Map<String, dynamic>>? agendas;
  const FamilyStart({super.key, this.agendas});

  @override
  FamilyStartState createState() => FamilyStartState();
}

class FamilyStartState extends State<FamilyStart> {
  List<Map<String, dynamic>>? _agendas = [];
  bool _isLoading = false;
  bool _isTimerActive = true;
  // int _remainingSeconds = 900;
  int _remainingSeconds = 9;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _agendas = widget.agendas;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _isTimerActive = false;
        });
        _timer?.cancel();
      }
    });
  }

  void _removeAgenda(int index) {
    setState(() {
      _agendas!.removeAt(index);
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _deleteSelectedAgendas() async {
    setState(() {
      _agendas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _agendas!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _removeAgenda(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: colorLightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _agendas![index]["text"],
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  OrangeActionButton(text: "대화시작", onPressed: () => _isTimerActive ? null : _deleteSelectedAgendas,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
