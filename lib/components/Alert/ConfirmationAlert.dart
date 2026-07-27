import 'package:flutter/material.dart';

class ConfirmationAlert extends StatelessWidget {
  final String? titleAlert;
  final String? messageAlert;
  final VoidCallback? onConfirmation;

  const ConfirmationAlert({
    super.key,
    this.titleAlert,
    this.messageAlert,
    this.onConfirmation,
  });

  static void show(
    BuildContext context,
    String? titleAlert,
    String? messageAlert,
    VoidCallback? onConfirmation,
  ) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationAlert(
        titleAlert: titleAlert,
        messageAlert: messageAlert ?? '',
        onConfirmation: onConfirmation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(titleAlert ?? ''),
      content: Text(messageAlert ?? ''),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o alerta
          },
          child: Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            // Coloque sua ação aqui
            Navigator.of(context).pop();
            onConfirmation?.call(); // Fecha o alerta
          },
          child: Text("Sim"),
        ),
      ],
    );
  }
}
