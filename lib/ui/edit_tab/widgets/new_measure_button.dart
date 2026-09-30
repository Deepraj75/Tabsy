import 'package:flutter/material.dart';

class NewMeasureButton extends StatelessWidget {
  final VoidCallback add;

  const NewMeasureButton({
    required this.add, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: add,
      icon: const Icon(Icons.add),
      color: Colors.black,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
