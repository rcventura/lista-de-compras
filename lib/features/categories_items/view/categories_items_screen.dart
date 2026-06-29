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
  @override
  void initState() {
    super.initState();
    context.read<CategoriesItemsBloc>().add(
      CategoriesItemsFetchRequest(categoryId: widget.categoryId),
    );
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
          final selectedIndex = state is CategoriesItemsLoadingSuccess
              ? state.selectedIndex
              : null;

          return Scaffold(
            appBar: AppBar(
              title: Text('Itens da Categoria'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : categoriesItemsList.isEmpty
                ? const Center(child: Text('Nenhum item encontrado.'))
                : ListView.builder(
                    itemCount: categoriesItemsList.length,
                    itemBuilder: (context, index) {
                      final categoryItem = categoriesItemsList[index];

                      return ListTile(
                        title: Text(categoryItem.name),
                        trailing: selectedIndex == index
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          context.read<CategoriesItemsBloc>().add(
                            CategoriesItemsSelected(index),
                          );
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
