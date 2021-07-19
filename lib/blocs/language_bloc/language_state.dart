import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();
}

class InitialLanguageState extends LanguageState {
  @override
  List<Object> get props => [];
}

class LanguageSettingLoaded extends LanguageState {
  final Locale language;

  LanguageSettingLoaded([this.language]);

  @override
  String toString() {
    if (language==null) {
      return 'Language Setting Loaded default';
    } else {
      return 'Language Setting Loaded ${language.languageCode}';
    }
  }

  @override
  List<Object> get props => [language.countryCode, language.languageCode];
}

class ChangingLanguageSettings extends LanguageSettingLoaded {
  ChangingLanguageSettings([Locale locale]);

  @override
  String toString() => 'language settings loading';

  @override
  List<Object> get props => super.props;
}

class ChangeLanguageError extends LanguageSettingLoaded {
  final String errorMsg;

  ChangeLanguageError(this.errorMsg, [Locale locale]);

  @override
  String toString() => 'Change language error';

  @override
  List<Object> get props => super.props;
}
