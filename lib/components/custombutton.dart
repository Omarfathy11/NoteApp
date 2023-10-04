import 'package:flutter/material.dart';



class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const CustomButton({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.orange,
      onPressed: onPressed ,
      child:  Text(title),
    );
  }
}

class CustomButtonUpload extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final bool isselected;
  const CustomButtonUpload({super.key, this.onPressed, required this.title, required this.isselected});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 35,
      minWidth: 200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: isselected ? Colors.green : Colors.orange,
      onPressed: onPressed ,
      child:  Text(title),
    );
  }
}
