import 'dart:convert';

import 'package:dynamic_form_builder/src/features/dynamic_form/presentation/provider/user_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataProvider = StateNotifierProvider<UserDataProvider, UserDataState>(
  (_) => UserDataProvider(),
);

class UserDataProvider extends StateNotifier<UserDataState> {
  UserDataProvider() : super(const UserDataState());

  void formatInputJson(String rawJson) {
    try {
      final decodeJson = jsonDecode(rawJson);

      if (decodeJson is List) {
        for (var item in decodeJson) {
          if (item is! Map ||
              !item.containsKey('field_name') ||
              !item.containsKey('widget')) {
            throw Exception('Invalid structure in JSON array');
          }
        }
        state = state.copyWith(
          jsonData: List<Map<String, dynamic>>.from(decodeJson),
        );
      } else if (decodeJson is Map) {
        if (!decodeJson.containsKey('field_name') ||
            !decodeJson.containsKey('widget')) {
          throw Exception('Invalid structure in JSON object');
        }
        state = state.copyWith(
          jsonData: [Map<String, dynamic>.from(decodeJson)],
        );
      }
    } catch (e) {
      debugPrint("E $e");
      state = state.copyWith(error: e.toString());
    }
  }

  void updateDropdown(String value) {
    state = state.copyWith(dropDownValue: value);
  }

  void updateCheckbox(bool value) {
    state = state.copyWith(checkboxValue: value);
  }

  void updateRadio(String value) {
    state = state.copyWith(radioValue: value);
  }

  void updateSlider(double value) {
    state = state.copyWith(sliderValue: value);
  }

  void updateSwitch(bool value) {
    state = state.copyWith(switchValue: value);
  }
}
