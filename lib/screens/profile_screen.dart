import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haru_match/userData.dart';

class ProfileScreen extends StatefulWidget {
  final UserData? userData;

  ProfileScreen({this.userData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _userData = widget.userData;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Navigator로부터 사용자 ID 받기
    final userId = ModalRoute.of(context)!.settings.arguments as String;

    // Firestore에서 사용자 데이터 검색
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      setState(() {
        // Firestore에서 불러온 데이터로 _userData 업데이트, null 체크 추가
        _userData = data != null ? UserData.fromFirestore(data) : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userData?.name ?? 'No Name'), // 'No Name'은 기본값으로 사용자 이름이 없을 경우를 대비한 것입니다.
      ),
      body: Column(
        children: [
          Text('Name: ${_userData?.name ?? 'No Name'}'),
          Text('Birthdate: ${_userData?.birthDate ?? 'No Birthdate'}'),
          // 나머지 사용자 정보 표시, _userData 사용 시 null 체크 필요
        ],
      ),
    );
  }
}


