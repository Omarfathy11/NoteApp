import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hinttext;
  final TextEditingController? myController;
  final String? Function(String?)? validator;
  const CustomTextFormField(
      {super.key,
      required this.hinttext,
      required this.myController,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: myController,
      decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: hinttext,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
    );
  }
}