import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_compras/components/BottomSheet/personButtomSheet.dart';
import 'package:lista_compras/core/routes/routes.dart';
import 'package:lista_compras/features/shopping/bloc/detail_shoppinglist_bloc.dart';
import 'package:lista_compras/features/shopping/bloc/detail_shoppinglist_event.dart';
import 'package:lista_compras/features/shopping/bloc/detail_shoppinglist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_cubit.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_state.dart';

class DetailShoppingListScreen extends StatefulWidget {
  final String shoppingListId;

  const DetailShoppingListScreen({
    super.key,
    required this.shoppingListId,
  });

  @override
  State<DetailShoppingListScreen> createState() =>
      _DetailShoppingListScreenState();
}

class _DetailShoppingListScreenState extends State<DetailShoppingListScreen> {
  Future<void> _navigateToCategories() async {
    await Navigator.pushNamed(context, Routes.categories);

    if (mounted) {
      context.read<DetailShoppinglistBloc>().add(
        DetailFetchShoppingListItemsRequested(widget.shoppingListId),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailShoppinglistBloc, DetailShoppinglistState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is DetailSShoppingListItemError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      child: BlocBuilder<DetailShoppinglistBloc, DetailShoppinglistState>(
        builder: (context, state) {
          final currentShoppingListState = context
              .watch<CurrentShoppingListCubit>()
              .state;
          final currentShoppingList =
              currentShoppingListState is CurrentShoppingListLoaded
              ? currentShoppingListState.currentShoppingList
              : null;

          final isLoading = state is DetailSShoppingListItemLoading;
          final shoppingList = state is DetailSShoppingListItemFetchSuccess
              ? state
              : null;

          final shoppingListName = currentShoppingList?.name ?? '';
          final shoppingListCreatedAt =
              currentShoppingList?.createdAt ??
              DateTime.now().toIso8601String();
          final shoppingListItems = shoppingList?.items ?? [];
          final shoppingListLocate = currentShoppingList?.local ?? '';

          // Lógica para construir a UI com base no estado atual
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalhes da Lista'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.black54),
                  onPressed: () => ShowPersonBottomSheet.show(context),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: FloatingActionButton(
                onPressed: () => _navigateToCategories(),
                child: const Icon(Icons.add),
              ),
            ),
            body: SafeArea(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(
                                          alpha: 0.5,
                                        ),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 1),
                                        // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            shoppingListName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          Text(
                                            DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                shoppingListCreatedAt,
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      shoppingListLocate.isNotEmpty
                                          ? Text(
                                              shoppingListLocate,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: shoppingListItems.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Nenhum item adicionado à lista.',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: double.infinity,
                                          height: 10,
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: shoppingListItems.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(
                                                  shoppingListItems[index].name,
                                                ),
                                                //   subtitle: Text(
                                                //     'Descrição do item ${index + 1}',
                                                //   ),
                                                trailing: Icon(
                                                  Icons
                                                      .keyboard_arrow_right_outlined,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              Divider(color: Colors.grey, thickness: 1),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  8,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 20,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        shoppingListItems.isNotEmpty
                                            ? 'R\$ ${shoppingListItems.fold(0.0, (sum, item) => sum + ((item.quantity * (item.price ?? 0.0)))).toStringAsFixed(2)}'
                                            : 'R\$ 0.00',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
