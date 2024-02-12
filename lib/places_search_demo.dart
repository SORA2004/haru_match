import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlacesSearchDemo extends StatefulWidget {
  @override
  _PlacesSearchDemoState createState() => _PlacesSearchDemoState();
}

class _PlacesSearchDemoState extends State<PlacesSearchDemo> {
  String _apiKey = 'AIzaSyBsXiV_yFOOWQeiVuIgbkNFCBJiJzW2wXQ'; // 여기에 실제 API 키를 입력하세요.
  List<String> _placesList = [];

  Future<void> searchPlaces(String query) async {
    final url = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_apiKey&language=ko&components=country:kr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _placesList = result['predictions']
            .map<String>((p) => p['description'])
            .toList();
      });
    } else {
      throw Exception('지역을 찾는데 실패하였습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places Search Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchPlaces,
              decoration: InputDecoration(
                hintText: '지역을 검색하는 중...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _placesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_placesList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
