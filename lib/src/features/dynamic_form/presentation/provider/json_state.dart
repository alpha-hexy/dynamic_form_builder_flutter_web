import 'package:flutter/foundation.dart';

@immutable
class JsonState {
  final String error;

  const JsonState({this.error = ""});

  JsonState copyWith({String? error}) => JsonState(error: error ?? this.error);
}
