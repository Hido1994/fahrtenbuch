import 'package:flutter/material.dart';

class AutocompleteTextFormField extends StatefulWidget {
  final String? initialValue;
  final String title;
  final List<String> options;
  final ValueSetter<String> onChanged;

  const AutocompleteTextFormField({
    Key? key,
    required this.title,
    required this.options,
    required this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<AutocompleteTextFormField> createState() =>
      _AutocompleteTextFormFieldState();
}

class _AutocompleteTextFormFieldState extends State<AutocompleteTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      initialValue: TextEditingValue(text: widget.initialValue ?? ''),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return widget.options;
        } else {
          List<String> matches = <String>[];
          matches.addAll(widget.options);

          matches.retainWhere((s) {
            return s
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
          return matches;
        }
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
              label: Text(widget.title)),
          // validator: (value) {
          //   if (widget.required && (value == null || value.isEmpty)) {
          //     return '${widget.title} ist ein Pflichtfeld';
          //   }
          //   return null;
          // },
        );
      },
      onSelected: widget.onChanged,
    );
  }
}
