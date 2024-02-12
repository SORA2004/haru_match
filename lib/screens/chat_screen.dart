import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String friendName; // 채팅 상대 이름을 전달받기 위한 생성자 매개변수

  ChatScreen({Key? key, required this.friendName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = []; // 채팅 메시지를 저장하는 리스트

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text;
    if (text.isNotEmpty) {
      setState(() {
        messages.add(text); // 메시지 리스트에 추가
        _messageController.clear(); // 입력 필드 초기화
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friendName), // 채팅 상대 이름을 앱바 제목으로 표시
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]), // 메시지 표시
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '메시지 입력...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage, // 메시지 전송 버튼
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
