import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/components/SMButtom/SMButtom.dart';
import 'package:lista_compras/components/toastAlert/toastAlert.dart';
import 'package:lista_compras/core/helpers/enum.dart';
import 'package:lista_compras/core/routes/routes.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_event.dart';
import 'package:lista_compras/features/categories_items/bloc/add_items_in_list_state.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_event.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_state.dart';
import 'package:lista_compras/features/categories_items/domain/entity/categories_item_entity.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_cubit.dart';
import 'package:lista_compras/features/shopping/cubit/current_shopping_list_state.dart';

class CategoriesItemsScreen extends StatefulWidget {
  final String categoryId;
  const CategoriesItemsScreen({super.key, required this.categoryId});

  @override
  State<CategoriesItemsScreen> createState() => _CategoriesItemsScreenState();
}

class _CategoriesItemsScreenState extends State<CategoriesItemsScreen> {
  List<CategoriesItemEntity> itemsSelected = [];
  List<CategoriesItemEntity> searchItemList = [];

  final _searchController = TextEditingController();
  var _clearButtonVisible = false;
  var _isAddingItems = false;
  var _pendingItemsToAdd = 0;

  @override
  void initState() {
    super.initState();
    context.read<CategoriesItemsBloc>().add(
      CategoriesItemsFetchRequest(categoryId: widget.categoryId),
    );
  }

  void _clearTextField() {
    _searchController.clear();
    setState(() {
      _clearButtonVisible = false;
    });
  }

  void _searchItem(List<CategoriesItemEntity> categoriesItemsLists) {
    final searchText = _searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      searchItemList = categoriesItemsLists;
    } else {
      searchItemList = categoriesItemsLists.where((item) {
        return item.name.toLowerCase().contains(searchText);
      }).toList();
    }
  }

  Widget showClearButtom() {
    if (_clearButtonVisible) {
      return IconButton(
        onPressed: _clearTextField,
        icon: Icon(Icons.close, size: 20, color: Colors.grey[600]),
      );
    }
    return const SizedBox.shrink();
  }

  void _toggleSelectedItem(CategoriesItemEntity itemId) {
    setState(() {
      if (itemsSelected.contains(itemId)) {
        itemsSelected.remove(itemId);
      } else {
        itemsSelected.add(itemId);
      }
    });
  }

  Future<void> _addSelectedItems({
    required String listId,
    required String productId,
    required String name,
    required int quantity,
    required String unit,
    required bool checked,
    required int position,
    required double price,
  }) async {
    if (itemsSelected.isEmpty) return;

    final categoriesState = context.read<CategoriesItemsBloc>().state;
    if (categoriesState is! CategoriesItemsLoadingSuccess) return;

    final selectedItems = categoriesState.categoriesItemsList
        .where((item) => itemsSelected.contains(item))
        .toList();

    setState(() {
      _isAddingItems = true;
      _pendingItemsToAdd = selectedItems.length;
    });

    for (final categoryItem in selectedItems) {
      context.read<AddItemsInListBloc>().add(
        AddItemsInListRequested(
          listId: listId,
          productId: productId,
          name: categoryItem.name,
          quantity: quantity,
          unit: unit,
          checked: false,
          position: position,
          price: price,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoriesItemsBloc, CategoriesItemsState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is CategoriesItemsLoadingError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<AddItemsInListBloc, AddItemsInListState>(
          listener: (context, state) {
            if (!mounted) return;

            if (state is AddItemsInListSuccess) {
              _pendingItemsToAdd--;

              if (_pendingItemsToAdd <= 0) {
                setState(() {
                  _isAddingItems = false;
                  _pendingItemsToAdd = 0;
                  itemsSelected.clear();
                });

                Navigator.of(
                  context,
                ).popUntil(ModalRoute.withName(Routes.shoppingListDetail));
                ToastAlert.show(context, Text('Itens adicionado com sucesso!'));
              }
            }

            if (state is AddItemsInListError) {
              setState(() {
                _isAddingItems = false;
                _pendingItemsToAdd = 0;
              });
              ToastAlert.show(context, Text(state.message));
            }
          },
        ),
      ],
      child: BlocBuilder<CategoriesItemsBloc, CategoriesItemsState>(
        builder: (context, state) {
          final currentShoppingListState = context
              .watch<CurrentShoppingListCubit>()
              .state;
          final currentShoppingList =
              currentShoppingListState is CurrentShoppingListLoaded
              ? currentShoppingListState.currentShoppingList
              : null;
          final isLoading = state is CategoriesItemsLoading;
          final categoriesItemsList = state is CategoriesItemsLoadingSuccess
              ? state.categoriesItemsList
              : [];

          final shoppingListLocate = currentShoppingList?.local ?? '';
          return Scaffold(
            appBar: AppBar(
              title: Text('Itens da Categorias'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => {
                  itemsSelected.clear(),
                  Navigator.pop(context),
                },
              ),
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : categoriesItemsList.isEmpty
                ? const Center(child: Text('Nenhum item encontrado.'))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16, 0.0),
                        child: TextField(
                          controller: _searchController,
                          maxLines: 1,
                          onChanged: (value) {
                            setState(() {
                              if (_searchController.text.isEmpty) {
                                _clearButtonVisible = false;
                              } else {
                                _clearButtonVisible = true;
                                _searchItem(
                                  categoriesItemsList
                                      as List<CategoriesItemEntity>,
                                );
                              }
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Pesquisar item',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            suffixIcon: showClearButtom(),
                          ),
                        ),
                      ),

                      searchItemList.isEmpty &&
                              _searchController.text.isNotEmpty
                          ? const Center(
                              child: Text('Item pesquisado não encontrado.'),
                            )
                          : Expanded(
                              child: _searchController.text.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: searchItemList.length,
                                      itemBuilder: (context, index) {
                                        final categoryItem =
                                            searchItemList[index];
                                        return CheckboxListTile(
                                          title: Text(categoryItem.name),
                                          value:
                                              itemsSelected.contains(
                                                categoryItem,
                                              )
                                              ? true
                                              : false,
                                          onChanged: (_) =>
                                              _toggleSelectedItem(categoryItem),
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      itemCount: categoriesItemsList.length,
                                      itemBuilder: (context, index) {
                                        final categoryItem =
                                            categoriesItemsList[index];
                                        return shoppingListLocate ==
                                                ShoppingListLocateEnum
                                                    .casa
                                                    .value
                                            ? CheckboxListTile(
                                                title: Text(categoryItem.name),
                                                value:
                                                    itemsSelected.contains(
                                                      categoryItem,
                                                    )
                                                    ? true
                                                    : false,
                                                onChanged: (_) =>
                                                    _toggleSelectedItem(
                                                      categoryItem,
                                                    ),
                                              )
                                            : ListTile(
                                                title: Text(categoryItem.name),
                                                trailing: Icon(
                                                  Icons.chevron_right,
                                                  size: 20,
                                                  color: Colors.grey[600],
                                                ),
                                                onTap: () => {},
                                              );
                                      },
                                    ),
                            ),
                      if (shoppingListLocate ==
                          ShoppingListLocateEnum.casa.value)
                        SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16.0,
                              0.0,
                              16.0,
                              20.0,
                            ),
                            child: Column(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Itens selecionados: ${itemsSelected.length}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SMButton(
                                  text: _isAddingItems
                                      ? 'Adicionando...'
                                      : 'Adicionar',
                                  isDisabled:
                                      itemsSelected.isEmpty || _isAddingItems,
                                  onPressed: () => _addSelectedItems(
                                    listId: currentShoppingList?.id ?? '',
                                    productId: itemsSelected[0].id,
                                    name: itemsSelected[0].name,
                                    quantity: 1,
                                    unit: '',
                                    checked: false,
                                    position: 1,
                                    price: 0.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
