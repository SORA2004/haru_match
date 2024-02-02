import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'welcome_page.dart'; // 경로 확인 필요
import 'generated/l10n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static _MyAppState of(BuildContext context) {
    final _MyAppState? result = context.findAncestorStateOfType<_MyAppState>();
    assert(result != null, 'No _MyAppState found in context');
    return result!;
  }

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
    return MaterialApp(
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: WelcomePage(onLocaleChange: setLocale),
    );
  }
}


