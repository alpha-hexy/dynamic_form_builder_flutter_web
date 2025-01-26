import 'dart:convert';

import 'package:dynamic_form_builder/src/features/dynamic_form/presentation/provider/json_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jsonProvider = StateNotifierProvider<JsonProvider, JsonState>(
  (_) => JsonProvider(),
);

class JsonProvider extends StateNotifier<JsonState> {
  JsonProvider() : super(const JsonState());

  void formatJson(String rawJson) {
    try {
      final jsonObject = jsonDecode(rawJson);
      if (jsonObject is List) {
        // If it's a List, iterate over each item (JSON object)
        for (var jsonObject in jsonObject) {
          _handleError(jsonObject);
        }
      } else if (jsonObject is Map) {
        // If it's a single Map, just validate that object
        _handleError(jsonObject);
      } else {
        throw Exception(
          "Input must be a JSON Object or a List of JSON Objects.",
        );
      }

      state = state.copyWith(error: "");
    } catch (e) {
      debugPrint("ERROR : $e");

      // Create a formatted error message with position details
      state = state.copyWith(error: "JSON parsing error: $e");
    }
  }

  void _handleError(Map<dynamic, dynamic> jsonObject) {
    if (!jsonObject.containsKey('field_name') ||
        !jsonObject.containsKey('widget')) {
      throw Exception("Missing required json Object field_name or widget");
    }

    String widget = jsonObject['widget'];

    switch (widget) {
      case 'dropdown':
        if (!jsonObject.containsKey('valid_values') ||
            jsonObject['valid_values'] is! List) {
          throw Exception("Dropdown widget requires 'valid_values' as a List");
        }
        break;

      case 'checkbox':
        if (!jsonObject.containsKey('label') ||
            jsonObject['label'] is! String) {
          throw Exception("Checkbox widget requires 'label' as a String");
        }
        break;

      case 'radio':
        if (!jsonObject.containsKey('valid_values') ||
            jsonObject['valid_values'] is! List) {
          throw Exception("Radio widget requires 'valid_values' as a List");
        }
        break;

      case 'slider':
        if (!jsonObject.containsKey('min') || !jsonObject.containsKey('max')) {
          throw Exception("Slider widget requires 'min' and 'max' values");
        }
        break;

      case 'switch':
        break;

      case 'textfield':
        break;

      default:
        throw Exception("Unsupported widget type: $widget");
    }
  }
}
