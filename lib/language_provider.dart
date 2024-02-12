import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = 'ko'; // 기본 언어를 한국어로 설정

  String get selectedLanguage => _selectedLanguage;

  void setSelectedLanguage(String language) {
    if (_selectedLanguage != language) {
      _selectedLanguage = language;
      notifyListeners(); // 언어가 변경되면 리스너에게 알림
    }
  }
}

// LanguageProvider 클래스 밖에 searchCity 함수를 정의합니다.
Future<List<String>> searchCity(String query, String apiKey, String language) async {
  // API의 URL. 실제 API 주소와 매개변수로 바꿔야 해요.
  var url = Uri.parse('https://api.example.com/cities?search=$query&lang=$language&apiKey=$apiKey');

  // API 요청을 보내고 응답을 받아요.
  var response = await http.get(url);

  // 성공적으로 데이터를 받았는지 확인해요.
  if (response.statusCode == 200) {
    // 데이터를 JSON 형식으로 변환해요.
    List<dynamic> data = json.decode(response.body);

    // 도시 이름 목록을 추출해서 반환해요.
    return data.map((city) => city['name'].toString()).toList();
  } else {
    // 요청이 실패하면 빈 목록을 반환해요.
    throw Exception('Failed to load cities');
  }
}
