import 'dart:convert';

import 'package:dynamic_form_builder/src/features/dynamic_form/presentation/provider/json_provider.dart';
import 'package:dynamic_form_builder/src/features/dynamic_form/presentation/provider/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';

class DynamicFormView extends StatefulWidget {
  const DynamicFormView({super.key});

  @override
  State<DynamicFormView> createState() => _DynamicFormViewState();
}

class _DynamicFormViewState extends State<DynamicFormView> {
  TextEditingController jsonController = TextEditingController();

  final sampleJson = """[
        { "field_name": "f1", "widget": "dropdown", "valid_values": ["A", "B"] },
        { "field_name": "f2", "widget": "checkbox", "label" : "lda","visible": "f1=='B'" },
        {"field_name": "f3", "widget": "radio", "valid_values": ["A", "B"],"visible": "f1=='A'" },
        {"field_name": "f4", "widget": "slider", "min": 0, "max": 100,"visible": "f1=='B'"  },
        {"field_name": "f5", "widget": "switch","visible": "f1=='A'" },
        { "field_name": "f6", "widget": "textfield", "visible": "f1=='A'" },
        { "field_name": "f7", "widget": "textfield", "visible": "f1=='A'" },
        { "field_name": "f8", "widget": "textfield", "visible": "f1=='A'" },
        { "field_name": "f9", "widget": "textfield", "visible": "f1=='B'" },
        { "field_name": "f10", "widget": "textfield", "visible": "f1=='B'" }
        ]""";

  @override
  void dispose() {
    jsonController.dispose();
    super.dispose();
  }

  bool formatCondition(String value, String condition) {
    if (condition.isEmpty) return true;

    final getUpdateCondition = condition.split("==").last.toLowerCase();

    return "'${value.toLowerCase()}'" == getUpdateCondition;
  }

  void pretifyJson(String value) {
    final dynamic jsonObject = jsonDecode(value);
    final formattedJson = JsonEncoder.withIndent('  ').convert(jsonObject);

    final currentPosition = jsonController.selection.baseOffset;

    jsonController.text = formattedJson;
    jsonController.selection = TextSelection.collapsed(offset: currentPosition);
  }

  void showSnackBar() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Json copied to clipboard!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Form"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(maxWidth: 1000),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: kElevationToShadow[2],
            color: Colors.white,
          ),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Click here to copy sample json"),

                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: sampleJson));
                      showSnackBar();
                    },
                    icon: Icon(Icons.copy, size: 16),
                  ),
                ],
              ),

              Consumer(
                builder: (context, ref, child) {
                  return Column(
                    children: [
                      JsonTextField(
                        controller: jsonController,
                        onChanged: (value) {
                          if (value.isEmpty) return;
                          ref.read(jsonProvider.notifier).formatJson(value);
                          ref
                              .read(userDataProvider.notifier)
                              .formatInputJson(value);

                          pretifyJson(value);
                        },
                      ),
                      if (ref.watch(jsonProvider).error.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ref.watch(jsonProvider).error,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, child) {
                  if (ref.watch(jsonProvider).error.isNotEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: ref.watch(userDataProvider).jsonData.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final field = ref.watch(userDataProvider).jsonData[index];

                      final visible = formatCondition(
                        ref.watch(userDataProvider).dropDownValue,
                        field['visible'] ?? "",
                      );

                      if (field['widget'] == 'dropdown') {
                        return DropdownButtonFormField(
                          items:
                              (field['valid_values'] as List<dynamic>)
                                  .map(
                                    (value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  )
                                  .toList(),
                          decoration: InputDecoration(
                            hintText: "Select a value",
                            hintStyle: TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade100,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            ref
                                .read(userDataProvider.notifier)
                                .updateDropdown(value!);
                          },
                        );
                      } else if ((field['widget'] == 'textfield') && visible) {
                        return TextField(
                          decoration: InputDecoration(
                            labelText: field['field_name'],

                            hintStyle: TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade100,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      } else if (field['widget'] == 'checkbox' && visible) {
                        return CheckboxListTile(
                          title:
                              field['label'] == null
                                  ? null
                                  : Text(field['label']),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: ref.watch(userDataProvider).checkboxValue,
                          onChanged: (value) {
                            ref
                                .read(userDataProvider.notifier)
                                .updateCheckbox(value!);
                          },
                        );
                      } else if (field['widget'] == 'radio' && visible) {
                        return Column(
                          children:
                              (field['valid_values'] as List<dynamic>).map((
                                value,
                              ) {
                                return RadioListTile<String>(
                                  title: Text(value),
                                  value: value,
                                  groupValue:
                                      ref.watch(userDataProvider).radioValue,
                                  onChanged: (radio) {
                                    ref
                                        .read(userDataProvider.notifier)
                                        .updateRadio(radio!);
                                  },
                                );
                              }).toList(),
                        );
                      } else if (field['widget'] == 'slider' && visible) {
                        return Slider(
                          value: ref.watch(userDataProvider).sliderValue,
                          min: field['min'],
                          max: field['max'],
                          onChanged: (double value) {
                            ref
                                .read(userDataProvider.notifier)
                                .updateSlider(value);
                          },
                        );
                      } else if (field['widget'] == 'switch' && visible) {
                        return Row(
                          children: [
                            Switch(
                              value: ref.watch(userDataProvider).switchValue,
                              onChanged: (value) {
                                ref
                                    .read(userDataProvider.notifier)
                                    .updateSwitch(value);
                              },
                            ),
                            const SizedBox(width: 15),
                            Text(
                              ref.watch(userDataProvider).switchValue
                                  ? "Enabled"
                                  : "Disabled",
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
