import 'package:flutter/material.dart';
import 'generated/l10n.dart';

class WelcomePage extends StatefulWidget {
  final Function(Locale) onLocaleChange; // 추가된 부분

  WelcomePage({required this.onLocaleChange}); // 생성자에 추가된 부분

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _selectedLanguage = 'ko';

  void _changeLanguage(String languageCode) {
    Locale newLocale;
    switch (languageCode) {
      case 'en':
        newLocale = Locale('en', 'US');
        break;
      case 'ja':
        newLocale = Locale('ja', 'JP');
        break;
      case 'ko':
        newLocale = Locale('ko', 'KR');
        break;
      default:
        newLocale = Locale('ko', 'KR');
    }
    widget.onLocaleChange(newLocale); // 수정된 부분
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        alignment: Alignment.center,
        /* 배경색을 흰색으로 변경 */
        decoration: BoxDecoration(
          color: Colors.white, // 흰색으로 설정
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/HaruMatch.png', width: 150, height: 150),
            SizedBox(height: 16),
            Text(S.of(context).welcome, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 8),
            Text(S.of(context).prompt, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 32),
            DropdownButton<String>(
              value: _selectedLanguage,
              icon: Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
                _changeLanguage(newValue!);
              },
              items: <String>['ko', 'en', 'ja'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.language),
                      SizedBox(width: 8.0),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text(S.of(context).login),
              style: ElevatedButton.styleFrom(primary: Colors.white, onPrimary: Colors.black, minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}

