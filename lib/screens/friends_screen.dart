import 'package:flutter/material.dart';
import 'package:haru_match/screens/chat_screen.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> friends = ['John Doe', 'Jane Smith', 'Mike Johnson']; // 예시 친구 목록

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
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    // 친구의 프로필 이미지를 넣으세요. 예제에서는 임시 이미지 URL을 사용합니다.
                    backgroundImage: NetworkImage('https://example.com/profile_image.png'),
                  ),
                  title: Text(friends[index]), // 친구의 이름
                  subtitle: Text('Last seen 2 hours ago'), // 실제 데이터를 사용하세요.
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chat),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatScreen(friendName: friends[index])), // ChatScreen 생성자에 친구 이름을 인자로 전달
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            friends.removeAt(index); // 친구 목록에서 해당 친구를 제거
                          });
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

