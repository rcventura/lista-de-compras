import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers/validators.dart';
import '../../../components/SMButtom/SMButtom.dart';
import '../../../components/toastAlert/toastAlert.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      CreateAccountRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pop(context);
              ToastAlert.show(context, 'Conta criada com sucesso!');
            }

            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Image.asset(
                            'assets/images/logo.png',
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Nome completo',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            validator: Validators.required,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              prefixIcon: Icon(Icons.email, color: Colors.grey),
                              border: OutlineInputBorder(),
                            ),
                            validator: Validators.email,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            validator: Validators.password,
                          ),
                          const SizedBox(height: 60),
                          SMButton(
                            text: 'Criar conta',
                            onPressed: _submit,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text('Já tenho uma conta'),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
