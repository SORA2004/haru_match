import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haru_match/models/user.dart';
import 'package:haru_match/screens/profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:haru_match/userData.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<bool> _selections = List.generate(3, (_) => false);
  final _formKey = GlobalKey<FormBuilderState>();
  final _cityController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  String _name = '';
  String _birthDate = '';
  String _hobby = '';
  String _bio = '';
  String? _gender;
  List<String> _hobbies = []; // 취미를 저장할 리스트
  List<String> _cities = []; // 검색 결과를 저장할 리스트

  Future<List<String>> searchCity(String query) async {
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=AIzaSyBsXiV_yFOOWQeiVuIgbkNFCBJiJzW2wXQ'; // 실제 API 키로 교체하세요.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<String> cities = List<String>.from(
          data['predictions'].map((e) => e['description'].toString()));
      return cities;
    } else {
      return [];
    }
  }

  Future<String> uploadImageToStorage(File imageFile, String userId) async {
    try {
      // Firebase Storage에 이미지 파일을 업로드하기 위한 참조를 생성합니다.
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref('uploads/<span class="math-inline">userId/</span>{DateTime.now().toIso8601String()}');

      // 파일 업로드를 실행하고, 완료될 때까지 기다립니다.
      firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask;

      // 업로드된 이미지의 URL을 반환합니다.
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return '';
    }
  }

  // 취미 추가 함수
  void _addHobby(String hobby) {
    // 새로운 취미가 비어있지 않고, 이미 리스트에 없으며, 5개를 초과하지 않을 때 추가
    if (hobby.isNotEmpty && !_hobbies.contains(hobby) && _hobbies.length < 5) {
      setState(() {
        _hobbies.add(hobby);
      });
    }
  }

  // initState에서 컨트롤러 초기화 및 dispose에서 리소스 해제
  @override
  void initState() {
    super.initState();
    // 필요한 초기화 작업
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // _saveProfile 함수에서 TextEditingController 값을 사용
  void _saveProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var userData = UserData(
        name: _nameController.text,
        birthDate: _birthDateController.text,
        bio: _bioController.text,
        hobbies: _hobbies,
        gender: _gender,
      );

      try {
        DocumentReference userDocRef = await FirebaseFirestore.instance.collection('users').add(userData.toMap());
        String imageUrl = '';

        if (_image != null) {
          imageUrl = await uploadImageToStorage(_image!, userDocRef.id);
          await userDocRef.update({'photoUrl': imageUrl});
        }

        Navigator.pushReplacementNamed(context, '/profileScreen', arguments: userDocRef.id);
      } catch (e) {
        print("Error saving user profile: $e");
      }
    }
  }


  void _deleteHobby(String hobby) {
    setState(() {
      _hobbies.remove(hobby);
    });
  }

  // 취미 태그를 만드는 함수
  Widget _buildHobbyChip(String hobby) {
    return Chip(
      label: Text(hobby),
      onDeleted: () {
        _deleteHobby(hobby); // 태그를 클릭하면 삭제
      },
      deleteIconColor: Colors.red,
      shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
    );
  }

  // 이미지를 선택하는 함수
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<User> getUserFromFirestore(String userId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    return User.fromFirestore(doc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '프로필 설정', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage, // 사용자가 아바타를 탭하면 _pickImage 함수를 호출
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : null,
                // _image가 있으면 그것을 프로필 사진으로 표시
                child: _image == null
                    ? Icon(
                    Icons.camera_alt, size: 50, color: Colors.black)
                    : null, // _image가 없을 때만 아이콘 표시
              ),
            ),
            SizedBox(height: 8), // 아이콘과 텍스트 사이의 간격 추가
            Center(
              child: Text(
                '프로필 사진을 올려주세요',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 24), // 프로필 사진과 이름 입력 필드 사이의 간격 추가
            Text(
              '이름',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '본인의 이름을 입력해주세요.',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(70),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
                suffixIcon: Icon(Icons.person), // 텍스트 필드 끝에 아이콘 추가
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요.';
                }
                return null;
              },
              onSaved: (value) {
                _name = value ?? ''; // 입력된 값을 _name 변수에 저장
              },
            ),
            SizedBox(height: 16),
            Text(
              '생년월일',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _birthDateController,
              keyboardType: TextInputType.number,
              // 숫자 키패드 활성화
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
                LengthLimitingTextInputFormatter(8), // 입력 길이를 8자리로 제한
              ],
              decoration: InputDecoration(
                labelText: '생년월일(YYYYMMDD)',
                hintText: 'YYYYMMDD 형식으로 입력해주세요.',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(70),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '생년월일을 입력해주세요.';
                } else if (value.length != 8) {
                  return '생년월일은 8자리여야 합니다.';
                }
                // 여기에 추가적인 날짜 형식 검증 로직을 넣을 수 있습니다.
                return null;
              },
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _birthDate = value;
                }
              },
            ),
            SizedBox(height: 16),
            Text(
              '성별',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(
                          color: _gender == '남성' ? Colors.black : Colors
                              .transparent,
                        ),
                      ),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    child: Text('남성'),
                    onPressed: () {
                      setState(() {
                        _gender = _gender == '남성' ? null : '남성';
                      });
                    },
                  ),
                  SizedBox(width: 20), // 버튼 사이 간격
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(
                          color: _gender == '여성' ? Colors.black : Colors
                              .transparent,
                        ),
                      ),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    child: Text('여성'),
                    onPressed: () {
                      setState(() {
                        _gender = _gender == '여성' ? null : '여성';
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              '취미',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '취미는 최대 5개까지 입력이 가능합니다',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.grey
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: '취미',
                hintText: '취미를 입력해주세요.',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(70),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
              ),
              onFieldSubmitted: (value) {
                _addHobby(value); // 사용자가 입력한 취미를 추가
              },
            ),
            // 취미 태그 표시
            Wrap(
              spacing: 8.0, // 태그 사이의 간격
              children: _hobbies.map((hobby) => _buildHobbyChip(hobby))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text(
              '언어',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Center( // Center 위젯으로 Wrap을 감싸서 중앙 정렬
              child: Wrap(
                alignment: WrapAlignment.center, // Wrap 내부의 정렬을 중앙으로 설정
                spacing: 8.0, // 버튼 사이의 간격
                children: <Widget>[
                  for (var i = 0; i < _selections.length; i++)
                    _buildLanguageButton(i),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              '지역',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            TypeAheadFormField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: '본인이 사는 지역을 검색해주세요',
                  border: OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await searchCity(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(title: Text(suggestion));
              },
              onSuggestionSelected: (suggestion) {
                _cityController.text = suggestion;
              },
            ),
            Text(
              '간단한 자기소개',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: '자기소개',
                hintText: '다른 사람에게 자기소개를 해주세요.',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(70),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
              ),
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _bio = value;
                }
              },
            ),
            // 언어 선택 및 기타 필드 추가 예정
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // UserData 인스턴스 생성
                  var userData = UserData(
                    name: _name,
                    birthDate: _birthDate,
                    bio: _bio,
                    hobbies: _hobbies,
                    gender: _gender,
                  );

                  // Firestore에 사용자 데이터 저장
                  var userDocRef = await FirebaseFirestore.instance
                      .collection('users').add(userData.toMap());

                  // imageUrl 초기화
                  String imageUrl = '';

                  // 이미지가 선택되었는지 확인하고, 선택된 경우에만 업로드 로직 수행
                  if (_image != null) {
                    try {
                      imageUrl = await uploadImageToStorage(_image!, userDocRef.id);
                      await userDocRef.update({'photoUrl': imageUrl});
                    } catch (e) {
                      // 이미지 업로드 실패 처리
                      print("Image upload failed: $e");
                    }
                  }
                  // 프로필 화면으로 이동
                  Navigator.pushReplacementNamed(context, '/profileScreen', arguments: userDocRef.id);
                },
                child: Text('프로필 저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 언어 선택 버튼을 생성하는 _buildLanguageButton 메소드의 반환 타입과 매개변수 타입이 명확한지 확인
  Widget _buildLanguageButton(int index) {
    var language = ['한국어', 'English', '日本語'][index];
    var isSelected = _selections[index];

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        side: BorderSide(
          color: isSelected ? Colors.black : Colors.transparent,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: () {
        setState(() {
          _selections[index] = !isSelected;
        });
      },
      child: Text(
        language,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}