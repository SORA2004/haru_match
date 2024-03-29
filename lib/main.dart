import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haru_match/firebase_options.dart';
import 'package:haru_match/screens/main_screen.dart';
import 'package:haru_match/screens/profile_screen.dart';
import 'welcome_page.dart';
import 'generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'language_provider.dart'; // LanguageProvider import
import 'places_search_demo.dart'; // 새로 생성한 파일을 import 합니다.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: MyApp(), // 여기서 MyApp은 앱의 진입점 위젯입니다.
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('ko', 'KR');

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: MaterialApp(
        locale: _locale,
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User? user = snapshot.data;
              if (user == null) {
                return WelcomePage(onLocaleChange: setLocale);
              }
              return MainScreen(); // 로그인 되어 있다면 MainScreen으로 이동
            }
            // 연결 상태가 아직 활성화되지 않았을 경우 로딩 인디케이터를 표시
            return CircularProgressIndicator();
          },
        ),
        routes: {
          '/profileScreen': (context) => ProfileScreen(), // ProfileScreen 라우트 추가
          // 다른 라우트들을 여기에 추가할 수 있습니다.
        },
        onGenerateRoute: (settings) {
          // '/profileScreen' 라우트에 대한 동적 처리를 필요로 하는 경우 여기에 로직을 추가하세요.
        },
      ),
    );
  }
}

// Google 로그인 관련 코드

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User?> signInWithGoogle(BuildContext context) async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
        .authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult = await _auth.signInWithCredential(
        credential);
    final User? user = authResult.user;

    if (user != null) {
      // MainScreen으로 이동
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
      return user;
    }
    return null;
  }
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Signed Out");
}
