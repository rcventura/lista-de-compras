import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/auth/view/login_screen.dart';
import 'package:lista_compras/features/categories/bloc/categories_bloc.dart';
import 'package:lista_compras/features/categories/view/categories_screen.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_event.dart';
import 'package:lista_compras/features/categories_items/view/categories_items_screen.dart';
import 'package:lista_compras/features/home/view/home_screen.dart';
import 'package:lista_compras/features/shopping/bloc/create_shoppinglist_bloc.dart';
import 'package:lista_compras/features/shopping/bloc/detail_shoppinglist_bloc.dart';
import 'package:lista_compras/features/shopping/bloc/detail_shoppinglist_event.dart';
import 'package:lista_compras/features/shopping/view/create_shopping_list_screen.dart';
import 'package:lista_compras/features/shopping/view/detail_shopping_list_screen.dart';

class ShoppingListDetailArgs {
  final String shoppingListId;

  const ShoppingListDetailArgs({required this.shoppingListId});
}

class CategoriesItemsArgs {
  final String categoryId;

  const CategoriesItemsArgs({required this.categoryId});
}

class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String addShoppingList = '/add-shopping-list';
  static const String shoppingListDetail = '/shopping-list-details';
  static const String categories = '/categories';
  static const String categoriesItems = '/categories/{id}';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case addShoppingList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => CreateShoppinglistBloc(),
            child: const CreateShoppingListScreen(),
          ),
        );
      case shoppingListDetail:
        final arguments = settings.arguments;

        if (arguments is! ShoppingListDetailArgs) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text(
                  'Argumentos invalidos para a rota ${settings.name}.',
                ),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => DetailShoppinglistBloc()
              ..add(
                DetailFetchShoppingListItemsRequested(arguments.shoppingListId),
              ),
            child: DetailShoppingListScreen(
              shoppingListId: arguments.shoppingListId,
            ),
          ),
        );

      case categories:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => CategoriesBloc(),
            child: const CategoriesScreen(),
          ),
        );

      case categoriesItems:
        final arguments = settings.arguments;

        if (arguments is! CategoriesItemsArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(
              body: Center(
                child: Text(
                  'Argumentos invalidos para a rota ${settings.name}.',
                ),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => CategoriesItemsBloc()
                  ..add(
                    CategoriesItemsFetchRequest(
                      categoryId: arguments.categoryId,
                    ),
                  ),
              ),
              BlocProvider(create: (_) => AddItemsInListBloc()),
            ],
            child: CategoriesItemsScreen(categoryId: arguments.categoryId),
          ),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota desconhecida: ${settings.name}')),
          ),
        );
    }
  }
}
