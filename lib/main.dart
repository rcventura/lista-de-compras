import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/core/routes/routes.dart';
import 'package:provider/provider.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/home/bloc/home_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );
  runApp(const ListaComprasApp());
}

class ListaComprasApp extends StatelessWidget {
  const ListaComprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [BlocProvider(create: (_) => AuthBloc())],
      child: MaterialApp(
        title: 'Lista de Compras',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        initialRoute: '/',
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
