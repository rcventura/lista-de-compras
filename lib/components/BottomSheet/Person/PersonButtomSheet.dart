import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../features/auth/bloc/auth_event.dart';
import '../../../features/auth/bloc/auth_state.dart';

class ShowUserModal extends StatelessWidget {
  const ShowUserModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const ShowUserModal(),
    );
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    final user = state is AuthSuccess ? state.user : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/logo.png'), width: 200, height: 200),

              Text(
                user?.name ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 16),
                  const SizedBox(width: 6),
                  Text(user?.email ?? ''),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[300]),
              Container(
                width: double.infinity,
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () => _logout(context),
                  child: const Text(
                    'Sair da conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
