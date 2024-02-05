import 'package:flutter/material.dart';
import 'package:haru_match/models/post.dart';
// 다른 필요한 import들...

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HaruMatch'),
      ),
      body: Center(
        // TODO: 게시물을 불러오고 표시하는 로직을 여기에 구현하세요.
        child: Text('게시물 목록이 여기에 표시됩니다.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 게시물을 올리는 화면으로 이동하는 로직을 여기에 구현하세요.
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
