import 'package:flutter/material.dart';
import 'package:haru_match/models/post.dart';
import 'package:haru_match/screens/post_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HaruMatch'),
      ),
      body: Center(
        // 게시물을 불러오고 표시하는 로직을 여기에 구현하세요.
        child: Text('게시물 목록이 여기에 표시됩니다.'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 60.0, // 컨테이너 높이
        width: 200.0, // 컨테이너 너비
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0), // 반경이 30인 직사각형
          color: Colors.blue, // 버튼의 배경색
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // 게시글 페이지로 이동하는 로직
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostScreen()),
            );
          },
          label: Text('내 게시물 올리기'), // 버튼의 텍스트
          icon: Icon(Icons.add), // 버튼의 아이콘
          backgroundColor: Colors.transparent, // Container의 배경색을 보이도록 함
          elevation: 0, // 버튼의 그림자 제거
        ),
      ),
    );
  }
}