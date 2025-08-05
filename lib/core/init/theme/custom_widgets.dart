import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const CustomButton({super.key, required this.text, required this.onPressed, this.isPrimary = true});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: isPrimary
          ? null
          : ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({super.key, required this.label, required this.controller, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}
