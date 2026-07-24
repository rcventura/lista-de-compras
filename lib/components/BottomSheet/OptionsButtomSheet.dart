// ignore_for_file: file_names

import 'package:flutter/material.dart';

class OptionsButtomSheet extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const OptionsButtomSheet({super.key, this.onShare, this.onDelete});

  static void show(
    BuildContext context, {
    VoidCallback? onShare,
    VoidCallback? onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) => OptionsButtomSheet(onShare: onShare, onDelete: onDelete),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.28,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.share, size: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onShare?.call();
                    },
                    child: const Text(
                      'Compartilhar',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDelete?.call();
                    },
                    child: const Text(
                      'Excluir',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
