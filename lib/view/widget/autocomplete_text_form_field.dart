import 'package:flutter/material.dart';

class AutocompleteTextFormField extends StatefulWidget {
  final String title;
  final List<String> options;
  final ValueSetter<String> onChanged;
  final bool required;

  const AutocompleteTextFormField({
    Key? key,
    required this.title,
    required this.options,
    required this.onChanged,
    this.required = false,
  }) : super(key: key);

  @override
  State<AutocompleteTextFormField> createState() =>
      _AutocompleteTextFormFieldState();
}

class _AutocompleteTextFormFieldState extends State<AutocompleteTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete(
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
              label: Text('${widget.title}${widget.required ? ' *' : ''}')),
          validator: (value) {
            if (widget.required && (value == null || value.isEmpty)) {
              return '${widget.title} ist ein Pflichtfeld';
            }
            return null;
          },
        );
      },
      onSelected: (String selection) {
        //noop
      },
    );
  }
}
