import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/model/auth_repository_impl.dart';
import 'features/auth/view/login_screen.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';

void main() {
  runApp(const ListaComprasApp());
}

class ListaComprasApp extends StatelessWidget {
  const ListaComprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(AuthRepositoryImpl()),
      child: MaterialApp(
        title: 'Lista de Compras',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
