import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/components/BottomSheet/Person/PersonButtomSheet.dart';
import 'package:lista_compras/core/routes/routes.dart';
import 'package:lista_compras/features/shopping/bloc/shoppinglist_bloc.dart';
import 'package:lista_compras/features/shopping/bloc/shoppinglist_event.dart';
import 'package:lista_compras/features/shopping/bloc/shoppinglist_state.dart';
import 'package:lista_compras/features/shopping/view/add_shopping_list_screen.dart';
import 'package:lista_compras/features/auth/bloc/auth_bloc.dart';
import 'package:lista_compras/features/auth/bloc/auth_state.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _navigateToAddList() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ShoppinglistBloc(),
          child: const AddNameShoppingListScreen(),
        ),
      ),
    );

    if (mounted) {
      context.read<ShoppinglistBloc>().add(FetchShoppingListsRequested());
    }
  }

  Future<void> _navigateToListDetails(String shoppingListId) async {
    // Lógica para navegar para os detalhes da lista
    await Navigator.pushNamed(context, Routes.shoppingListDetail, arguments: shoppingListId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushReplacementNamed('/');
        }
      },
      child: BlocBuilder<ShoppinglistBloc, ShoppingListState>(
        builder: (context, state) {
          final listas = state is ShoppingListFetchSuccess
              ? state.shoppingLists
              : [];
          final isLoading = state is ShoppingListLoading;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Lista de Compras'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.black54,
                ),
                onPressed: _navigateToAddList,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.black54),
                    onPressed: () => ShowUserModal.show(context),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : Column(
                      children: [
                        if (listas.isNotEmpty)
                          Container(
                            width: double.infinity,
                            height: 30,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(color: Colors.grey[300]),
                            child: const Text(
                              'Minhas Listas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        Expanded(
                          child: listas.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Nenhuma lista criada ainda.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Toque no + para criar sua primeira lista.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : RefreshIndicator.adaptive(
                                  onRefresh: () async {
                                    context.read<ShoppinglistBloc>().add(
                                      FetchShoppingListsRequested(),
                                    );
                                  },
                                  child: ListView.builder(
                                    itemCount: listas.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          listas[index].name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(listas[index].createdAt),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        trailing: const Icon(
                                          Icons.chevron_right,
                                        ),
                                        onTap: () {
                                          _navigateToListDetails(listas[index].id);
                                        },
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
