import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controler;
  final String hintText;
  const BlogEditor(
      {super.key, required this.controler, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controler,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: null,
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is empty";
        }
        return null;
      },
    );
  }
}
