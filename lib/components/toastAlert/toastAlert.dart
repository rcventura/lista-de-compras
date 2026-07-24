import 'package:flutter/material.dart';

class ToastAlert {
  static void show(BuildContext context, Widget message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
       backgroundColor: Colors.transparent,
  elevation: 0.0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$message',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}