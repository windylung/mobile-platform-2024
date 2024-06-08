import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_platform_2024/color.dart';
import 'package:mobile_platform_2024/shared_button.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: SignUpScreen(),
  ));
}

// SignUpScreen 클래스 정의
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _pw;
  String? _pwCheck;

  Future<String> signUp(String username, String email, String password) async {
    final url = Uri.parse('http://54.180.42.87/api/signup');  // 실제 서버 주소 사용
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      'name': username,
      'email': email,
      'password': password,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      // 회원가입 성공
      print('User signed up successfully: ${response.body}');
      return '회원가입되었습니다!';
    } else {
      // 회원가입 실패
      print('Failed to sign up: ${response.statusCode}');
      return '에러가 발생하였습니다!';
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();  // 팝업 닫기
                if (message == '회원가입되었습니다!') {
                  Navigator.of(context).pop();  // 메인 화면으로 이동
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '회원정보를\n입력하세요',
                    style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "이름",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: '이름',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGrey),
                            ),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGrey),
                            ),
                          ),
                          onChanged: (value) => setState(() {
                            _name = value;
                          }),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '이름을 입력하세요';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "이메일",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: _email,
                          decoration: const InputDecoration(
                            hintText: '이메일',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGrey),
                            ),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGrey),
                            ),
                          ),
                          onChanged: (value) => setState(() {
                            _email = value;
                          }),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '이메일을 입력하세요';
                            } else if (!value.contains('@')) {
                              return '잘못된 이메일 형태입니다';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "비밀번호",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: '비밀번호',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGrey),
                            ),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGrey),
                            ),
                          ),
                          onChanged: (value) => setState(() {
                            _pw = value;
                          }),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '비밀번호를 입력하세요';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "비밀번호 확인",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: '비밀번호 확인',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGrey),
                            ),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorGrey),
                            ),
                          ),
                          onChanged: (value) => setState(() {
                            _pwCheck = value;
                          }),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '비밀번호를 입력하세요';
                            } else if (value != _pw) {
                              return '비밀번호가 일치하지 않습니다';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: OrangeActionButton(
                  text: "회원가입",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String message = await signUp(_name!, _email!, _pw!);
                      _showDialog(message);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
