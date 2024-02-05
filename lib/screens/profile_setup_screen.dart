import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _birthDate = '';
  String _gender = '남자'; // 기본값 설정
  String _hobby = '';
  String _language = '한국어'; // 기본값 설정
  String _location = '';
  String _bio = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              // Placeholder for profile image
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '이름'),
              validator: (value) {
                if (value!.isEmpty) {
                  return '이름을 입력해주세요.';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '생년월일'),
              onSaved: (value) {
                _birthDate = value!;
              },
            ),
            // 성별 선택을 위한 Switch 또는 Radio 버튼 구현
            // 취미, 언어, 사는 지역, 개인소개에 대한 TextFormField 추가
            // ...
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // 폼 저장 로직
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // 서버에 프로필 정보 저장 로직
                    // 저장 후 프로필 편집 페이지로의 이동을 막는 로직
                  }
                },
                child: Text('프로필 저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
