import '../models/user.dart';

class Post {
  final User user;
  final String content;
  final String time;
  final int likes;
  final int comments;

  Post({
    required this.user,
    required this.content,
    required this.time,
    required this.likes,
    required this.comments,
  });
}