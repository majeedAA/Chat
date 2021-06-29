import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Applocaliztion {
  final Locale locale;

  Applocaliztion({this.locale});

  static Applocaliztion of(BuildContext context) {
    return Localizations.of<Applocaliztion>(context, Applocaliztion);
  }

  static const LocalizationsDelegate<Applocaliztion> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizationString;

  Future load() async {
    String jsonString =
        await rootBundle.loadString('lan/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizationString =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizationString[key];
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<Applocaliztion> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<Applocaliztion> load(Locale locale) async {
    Applocaliztion localization = new Applocaliztion(locale: locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Applocaliztion> old) {
    return false;
  }
}
