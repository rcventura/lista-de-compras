import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/auth/view/login_screen.dart';
import 'package:lista_compras/features/home/view/home_screen.dart';
import 'package:lista_compras/features/shopping/bloc/shoppinglist_bloc.dart';
import 'package:lista_compras/features/shopping/bloc/shoppinglist_event.dart';
import 'package:lista_compras/features/shopping/bloc/shoppinglist_item_bloc.dart';
import 'package:lista_compras/features/shopping/bloc/shoppinglist_item_event.dart';
import 'package:lista_compras/features/shopping/view/add_shopping_list_screen.dart';
import 'package:lista_compras/features/shopping/view/detail_shopping_list_screen.dart';


class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String addShoppingList = '/add-shopping-list';
  static const String shoppingListDetail = '/shopping-list-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ShoppinglistBloc()..add(FetchShoppingListsRequested()),
            child: const HomeScreen(),
          ),
        );
        case addShoppingList: 
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ShoppinglistBloc(),
              child: const AddNameShoppingListScreen(),
            ),
          );
          case shoppingListDetail:
          final id = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => ShoppinglistBloc()),
                  BlocProvider(create: (_) => ShoppinglistItemBloc()..add(FetchShoppingListItemsRequested(id))),
                ],
                child: ShoppingListDetailScreen(shoppingListId: id),
              ),
            );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota desconhecida: ${settings.name}')),
          ),
        );
    }
  }
}