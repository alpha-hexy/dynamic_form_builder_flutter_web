import 'package:flutter/foundation.dart';

@immutable
class UserDataState {
  final List<Map<String, dynamic>> jsonData;
  final String error;
  final String dropDownValue;
  final bool checkboxValue;
  final String radioValue;
  final double sliderValue;
  final bool switchValue;

  const UserDataState({
    this.jsonData = const [],
    this.error = "",
    this.dropDownValue = " ",
    this.checkboxValue = false,
    this.radioValue = "",
    this.sliderValue = 0,
    this.switchValue = false,
  });

  UserDataState copyWith({
    List<Map<String, dynamic>>? jsonData,
    String? error,
    String? dropDownValue,
    bool? checkboxValue,
    String? radioValue,
    double? sliderValue,
    bool? switchValue,
  }) => UserDataState(
    jsonData: jsonData ?? this.jsonData,
    error: error ?? this.error,
    dropDownValue: dropDownValue ?? this.dropDownValue,
    checkboxValue: checkboxValue ?? this.checkboxValue,
    radioValue: radioValue ?? this.radioValue,
    sliderValue: sliderValue ?? this.sliderValue,
    switchValue: switchValue ?? this.switchValue,
  );
}
