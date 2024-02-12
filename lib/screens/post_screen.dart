import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _mediaFiles = [];
  String _location = '위치를 가져오는 중...';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = '위치 서비스를 활성화해주세요.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = '위치 권한을 허용해주세요.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location = '위치 권한을 설정에서 허용해주세요.';
      });
      return;
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition();
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String country = place.country ?? "국가 정보 없음";
      String locality = place.locality ?? "도시 정보 없음";
      String administrativeArea = place.administrativeArea ?? "";
      String subLocality = place.subLocality ?? "";

      setState(() {
        _location =
        '$country, ${locality.isNotEmpty ? locality : administrativeArea +
            (subLocality.isNotEmpty ? ", $subLocality" : "")}';
      });
    } catch (e) {
      setState(() {
        _location = '위치 정보를 가져오는데 실패했습니다.';
      });
    }
  }

  Future<void> _pickMedia({bool isVideo = false}) async {
    List<XFile>? pickedFiles;
    if (isVideo) {
      final XFile? pickedFile = await _picker.pickVideo(
          source: ImageSource.gallery);
      if (pickedFile != null) {
        pickedFiles = [pickedFile];
      }
    } else {
      pickedFiles = await _picker.pickMultiImage(); // 이미지 여러 개 선택
    }

    // Null 체크를 하고, null이 아닌 경우에만 파일을 리스트에 추가합니다.
    // null인 경우 빈 리스트를 추가합니다.
    setState(() {
      _mediaFiles.addAll(pickedFiles ?? []);
    });
  }

  void _removeMedia(int index) {
    setState(() {
      _mediaFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 작성'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // 게시글 업로드 로직을 추가합니다.
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('사용자 이름', style: TextStyle(fontWeight: FontWeight
                            .bold, fontSize: 16)),
                        Text(_location, style: TextStyle(color: Colors.grey,
                            fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _textController,
                minLines: 5,
                maxLines: 15,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: '많은 이성들에게 본인을 소개해보세요!',
                  border: InputBorder.none, // 선 제거
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                ),
              ),
            ),
            SizedBox(height: 20), // 기존 여백 유지
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _mediaFiles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 표시되는 항목 수를 줄여 사진의 크기를 늘립니다.
                crossAxisSpacing: 2, // 사진 간의 가로 간격을 최소화합니다.
                mainAxisSpacing: 2, // 사진 간의 세로 간격을 최소화합니다.
                childAspectRatio: 1 / 1, // 사진의 크기를 조정하기 위해 비율을 조정합니다. 높이와 너비를 같게 하여 정사각형 형태를 유지할 수 있습니다.
              ),
              itemBuilder: (context, index) {
                bool isVideo = _mediaFiles[index].path.endsWith('.mp4');
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: isVideo
                          ? Icon(Icons.videocam, size: 50.0)
                          : Image.file(File(_mediaFiles[index].path), fit: BoxFit.cover),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _removeMedia(index),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20), // 여기서 구분선과 아이콘들 사이의 여백 추가
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0).copyWith(
                  top: 20), // 아이콘들을 더 아래로 내림
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () => _pickMedia(),
                  ),
                  IconButton(
                    icon: Icon(Icons.video_call),
                    onPressed: () => _pickMedia(isVideo: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}