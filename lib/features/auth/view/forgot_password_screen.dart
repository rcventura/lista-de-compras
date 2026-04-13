import 'package:flutter/material.dart';
import 'package:lista_compras/components/SMButtom/SMButtom.dart';
import '../../../components/toastAlert/toastAlert.dart';
import '../../../core/helpers/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void sendResetPasswordRequest() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      ResetPasswordRequested(email: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is SendResetPasswordSuccess) {
              _emailController.clear();
              Navigator.pop(context);
              ToastAlert.show(context, 'Instruções enviadas para seu e-mail!');
            }

            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },

          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),

                    Image.asset(
                      'assets/images/logo.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),

                    const Text(
                      'Informe seu e-mail e enviaremos as instruções para redefinir sua senha.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail', 
                        prefixIcon: Icon(Icons.email, color: Colors.grey), 
                        border: OutlineInputBorder()),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 40),

                    SMButton(
                      text: 'Enviar',
                      onPressed: sendResetPasswordRequest,
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Voltar para login'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
