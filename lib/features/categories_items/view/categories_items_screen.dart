import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_event.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_state.dart';

class CategoriesItemsScreen extends StatefulWidget {
  final String categoryId;
  const CategoriesItemsScreen({super.key, required this.categoryId});

  @override
  State<CategoriesItemsScreen> createState() => _CategoriesItemsScreenState();
}

class _CategoriesItemsScreenState extends State<CategoriesItemsScreen> {
  List<String> itemsSelected = [];
    final _searchController = TextEditingController();
var _clearButtonVisible = false;

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

    Widget showClearButtom() {
    if (_clearButtonVisible) {
      return IconButton(
        onPressed: _clearTextField,
        icon: Icon(Icons.close, size: 20, color: Colors.grey[600]),
      );
    }
    return const SizedBox.shrink();
  }

  void _toggleSelectedItem(String itemId) {
    setState(() {
      if (itemsSelected.contains(itemId)) {
        itemsSelected.remove(itemId);
      } else {
        itemsSelected.add(itemId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesItemsBloc, CategoriesItemsState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is CategoriesItemsLoadingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<CategoriesItemsBloc, CategoriesItemsState>(
        builder: (context, state) {
          final isLoading = state is CategoriesItemsLoading;
          final categoriesItemsList = state is CategoriesItemsLoadingSuccess
              ? state.categoriesItemsList
              : [];
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
                ? const Center(child: CircularProgressIndicator())
                : categoriesItemsList.isEmpty
                ? const Center(child: Text('Nenhum item encontrado.'))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16, 0.0),
                        child: TextField(
                            controller: _searchController,
                            maxLines: 1,
                            onChanged: (value) {
                              setState(() {
                                _searchController.text.isEmpty
                                    ? _clearButtonVisible = false
                                    : _clearButtonVisible = true;
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

                      Expanded(
                        child: ListView.builder(
                          itemCount: categoriesItemsList.length,
                          itemBuilder: (context, index) {
                            final categoryItem = categoriesItemsList[index];

                            return CheckboxListTile(
                              title: Text(categoryItem.name),
                              value: itemsSelected.contains(categoryItem.id)
                                  ? true
                                  : false,
                              onChanged: (_) =>
                                  _toggleSelectedItem(categoryItem.id),
                            );
                          },
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
