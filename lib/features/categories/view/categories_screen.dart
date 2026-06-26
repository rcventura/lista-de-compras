import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/core/routes/routes.dart';
import 'package:lista_compras/features/categories/bloc/categories_bloc.dart';
import 'package:lista_compras/features/categories/bloc/categories_event.dart';
import 'package:lista_compras/features/categories/bloc/categories_state.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesBloc>().add(CategoriesFetchItemRequest());
  }

  Future<void> _navigateToCategoryDetails(String categoryId) async {
    await Navigator.pushNamed(
      context,
      Routes.categoriesItems,
      arguments: CategoriesItemsArgs(categoryId: categoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (!mounted) return;

        if (state is CategoryLoadingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      child: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          final isLoading = state is CategoryLoading;
          final categoryList = state is CategoryLoadingSuccess
              ? state.categoriesList
              : [];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Categorias'),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : categoryList.isEmpty
                ? const Center(child: Text('Nenhuma categoria encontrada.'))
                : GridView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      final category = categoryList[index];

                      return GestureDetector(
                        onTap: () {
                          print('Categoria selecionada: ${category.name} - ${category.id}');
                          _navigateToCategoryDetails(category.id);
                        },
                        child: Card(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  category.icon,
                                  style: const TextStyle(fontSize: 36),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.name,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                  ),
          );
        },
      ),
    );
  }
}
