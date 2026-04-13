import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import '../../../components/SMButtom/SMButtom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _emailController.clear();
    _passwordController.clear();
  }

  // Dispara o evento LoginRequested para o BLoC.
  // O BLoC vai processar e emitir um novo estado (loading → success/error).
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Text(
                    'Bem-vindo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Organize suas compras de forma simples',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                validator: Validators.email,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  
                ),
                validator: Validators.password,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    _clearForm();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text('Esqueci minha senha'),
                ),
              ),
              const SizedBox(height: 30),

              // BlocConsumer combina duas responsabilidades:
              //   listener → reage a estados sem reconstruir a UI (navegar, snackbar)
              //   builder  → reconstrói um widget quando o estado muda
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  // Navega para Home quando o login for bem-sucedido
                  if (state is AuthSuccess) {
                    _clearForm();
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },

                builder: (context, state) {
                  // Mostra o botão com loading quando está carregando

                  final isLoading = state is AuthLoading;
                  return Column(
                    spacing: 5,
                    children: [
                      if (state is AuthError)
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),

                      SMButton(
                        text: 'Entrar',
                        onPressed: _submit,
                        isLoading: isLoading,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    const Text(
                      'Não tem conta?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Text(
                      'Cadastre-se',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
