import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String profileImage;
  String bio;
  String photoUrl; // 추가된 필드
  String lastMessage; // 추가된 필드
  String uid;

  User({
    this.id = '',
    this.name = '',
    this.profileImage = '',
    this.bio = '',
    this.photoUrl = '', // 초기화
    this.lastMessage = '', // 초기화
    this.uid = '',
  });

  static User fromFirestore(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'],
      photoUrl: doc['photoUrl'],
      // … (필요한 다른 속성들)
    );
  }
}