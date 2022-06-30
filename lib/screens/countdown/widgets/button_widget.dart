import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color;
  final Color backgroundColor;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    this.backgroundColor = Colors.black,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClicked,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => backgroundColor)),
    );
  }
}
