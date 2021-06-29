import 'package:ezhlha/app_localization.dart';
import 'package:ezhlha/home_page.dart';
import 'package:ezhlha/login_pages/wapper.dart';
import 'package:ezhlha/module/user.dart';
import 'package:ezhlha/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setLocal(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocal(locale);
  }

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocal(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        locale: _locale,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ar', 'EG'),
        ],
        localizationsDelegates: [
          Applocaliztion.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (deviceLocal, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocal.languageCode) {
              return deviceLocal;
            }
          }
          return supportedLocales.first;
        },
        home: Wrapper(),
      ),
    );
  }
}
