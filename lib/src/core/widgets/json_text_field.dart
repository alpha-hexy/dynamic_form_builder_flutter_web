import 'package:flutter/material.dart';

class JsonTextField extends StatelessWidget {
  const JsonTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });
  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: null,
      minLines: 5,
      decoration: InputDecoration(
        hintText: "Enter your Json...",
        hintStyle: TextStyle(color: Colors.black26),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade100),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
