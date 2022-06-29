import 'package:flutter/material.dart';

class CustomTextFormSign extends StatelessWidget {
  final String? hintText;
  final String? lableText;
  final String? Function(String?) validator;
  final TextEditingController? controller;
  CustomTextFormSign(
      {Key? key,
      required this.hintText,
      required this.lableText,
      required this.controller,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          labelText: lableText,
          hintText: hintText,
        ),
      ),
    );
  }
}
