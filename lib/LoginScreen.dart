import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp 클래스 정의
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: const LoginScreen(),
    );
  }
}

// Login 클래스 정의
class Login {
  final String name;
  final String email;
  final String pw;

  Login({required this.name, required this.email, required this.pw});
}

// LoginScreen 클래스 정의
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

// LoginScreenState 클래스 정의
class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _pw;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login App'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '이메일과 비밀번호를 입력하세요',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24.0),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: '이메일'),
                onSaved: (value) => _email = value,
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
                initialValue: _pw,
                decoration: const InputDecoration(labelText: '비밀번호'),
                onSaved: (value) => _pw = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '비밀번호를 입력하세요';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC076), // 버튼 색상 변경
                  textStyle: TextStyle(color: Colors.white)
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newProfile = Login(name: '',email: _email!, pw: _pw!);
                    Navigator.pop(context, newProfile);
                  }
                },
                child: const Text('로그인'),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
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
                onSaved: (value) => _email = value,
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
                onSaved: (value) => _pw = value,
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
                onSaved: (value) => _pwCheck = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '비밀번호를 입력하세요';
                  } else if(value != _pw){
                    print ('pw: ${_pw}');
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
