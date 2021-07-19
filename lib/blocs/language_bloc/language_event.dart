import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();
}

class ChangeLanguage extends LanguageEvent {
  final String langCode;
  final String countryCode;

  ChangeLanguage({this.langCode, this.countryCode});

  @override
  List<Object> get props => [langCode, countryCode];
}

class LoadLanguageCode extends LanguageEvent {
  @override
  List<Object> get props => null;
}
