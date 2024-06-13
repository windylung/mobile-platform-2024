import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ducktogether/color.dart'; // Assuming you have this file for color definitions

class FamilyTogetherPage extends StatefulWidget {
  const FamilyTogetherPage({super.key});

  @override
  State<FamilyTogetherPage> createState() => _FamilyTogetherPageState();
}

class _FamilyTogetherPageState extends State<FamilyTogetherPage> {
  bool _isHovered1 = false;
  bool _isHovered2 = false;

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                onEnter: (_) => setState(() => _isHovered1 = true),
                onExit: (_) => setState(() => _isHovered1 = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isHovered1 ? 220 : 200,
                  height: _isHovered1 ? 90 : 80,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/family_together/agenda'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "대화주제 작성",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              MouseRegion(
                onEnter: (_) => setState(() => _isHovered2 = true),
                onExit: (_) => setState(() => _isHovered2 = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isHovered2 ? 220 : 200,
                  height: _isHovered2 ? 90 : 80,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/family_together/select_agenda'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "가족대화 시작하기",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
