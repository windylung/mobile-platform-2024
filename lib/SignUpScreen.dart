import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '회원정보를 입력하세요',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: '이름'),
                onSaved: (value) => _name = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: '이메일'),
                onSaved: (value) => setState(() {
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
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: '비밀번호'),
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
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
                onChanged: (value) => setState(() {
                  _pwCheck = value;
                }),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '비밀번호를 입력하세요';
                  } else if(value != _pw){
                    return '비밀번호가 일치하지 않습니다';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC076), // 버튼 색상 변경
                    textStyle: TextStyle(color: Colors.white)
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // 추가적인 회원가입 처리 로직을 여기에 작성
                    Navigator.pop(context);
                  }
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
