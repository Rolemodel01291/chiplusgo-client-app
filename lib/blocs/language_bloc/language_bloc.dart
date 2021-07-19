import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:infishare_client/repo/utils/setting_consts.dart';
import './bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  @override
  LanguageState get initialState => InitialLanguageState();

  @override
  Stream<LanguageState> mapEventToState(
    LanguageEvent event,
  ) async* {
    if (event is ChangeLanguage) {
      yield* _mapChangeLanguageToState(event);
    } else if (event is LoadLanguageCode) {
      yield* _mapLoadLanguageCodeToState(event);
    }
  }

  Stream<LanguageState> _mapChangeLanguageToState(ChangeLanguage event) async* {
    //yield ChangingLanguageSettings((state as LanguageSettingLoaded).language);
    final currentState = state as LanguageSettingLoaded;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      final langBool = await preferences.setString(
          SettingConstants.Langeuage, event.langCode);
      final countryBool = await preferences.setString(
          SettingConstants.Country, event.countryCode);
      if (langBool && countryBool) {
        yield LanguageSettingLoaded(Locale(event.langCode, event.countryCode));
      } else {
        yield ChangeLanguageError(
          'Can not change language',
          currentState.language,
        );
      }
    } catch (e) {
      print(e);
      yield ChangeLanguageError(
        'Can not change language',
        currentState.language,
      );
    }
  }

  Stream<LanguageState> _mapLoadLanguageCodeToState(
      LoadLanguageCode event) async* {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final lang = preferences.getString(SettingConstants.Langeuage) ?? 'en';
      final country = preferences.getString(SettingConstants.Country) ?? 'US';
      yield LanguageSettingLoaded(
        Locale(lang, country),
      );
    } catch (e) {
      yield LanguageSettingLoaded(
        Locale('en', 'US'),
      );
    }
  }
}
