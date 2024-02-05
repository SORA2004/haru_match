import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구목록'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '내 친구 검색하기',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // 검색 로직을 구현하세요.
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // 예시를 위해 10으로 설정했습니다. 실제 데이터의 크기에 맞게 조정하세요.
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    // 친구의 프로필 이미지를 넣으세요.
                    backgroundImage: NetworkImage('친구의 프로필 이미지 URL'),
                  ),
                  title: Text('John Doe'), // 친구의 이름을 넣으세요.
                  subtitle: Text('Last seen 2 hours ago'), // 실제 데이터를 사용하세요.
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chat),
                        onPressed: () {
                          // 채팅 기능을 구현하세요.
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          // 친구 삭제 기능을 구현하세요.
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
