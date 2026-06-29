import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_event.dart';
import 'package:lista_compras/features/categories_items/bloc/categories_items_state.dart';
import 'package:lista_compras/features/categories_items/data/categories_item_repository.dart';
import 'package:lista_compras/features/categories_items/domain/entity/categories_item_entity.dart';
import 'package:lista_compras/features/categories_items/domain/usecase/categories_item_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesItemsBloc
    extends Bloc<CategoriesItemsEvent, CategoriesItemsState> {
  late final CategoryItemRepository _categoriesRepository;
  late final CategoriesItemsUsecase _categoriesItemsUsecase;
  List<CategoriesItemEntity> _categoriesItems = [];
  final List<int> itensSelected = [];
  
  CategoriesItemsBloc() : super(CategoriesItemsInitial()) {
    _categoriesRepository = CategoryItemRepository(Supabase.instance.client);
    _categoriesItemsUsecase = CategoriesItemsUsecase(_categoriesRepository);
    
    on<CategoriesItemsFetchRequest>(_onLoadCategoriesItems);
    on<CategoriesItemsSelected>(_onCategoriesItemSelected);
  }

  Future<void> _onLoadCategoriesItems(
    CategoriesItemsFetchRequest event,
    Emitter<CategoriesItemsState> emit,
  ) async {
    emit(CategoriesItemsLoading());
    try {
      final categoriesItems = await _categoriesItemsUsecase.fetchCategoriesItems(event.categoryId);
      _categoriesItems = categoriesItems;
      emit(CategoriesItemsLoadingSuccess(categoriesItems));
    } catch (e) {
      emit(CategoriesItemsLoadingError('Erro ao carregar os produtos dessa categoria, tente novamente'));
    }
  }

  void _onCategoriesItemSelected(
    CategoriesItemsSelected event,
    Emitter<CategoriesItemsState> emit,
  ) {
    if (event.itemIndex < 0 || event.itemIndex >= _categoriesItems.length) return;
    itensSelected.add(event.itemIndex);
    emit(CategoriesItemsLoadingSuccess(
      _categoriesItems,
      selectedIndex: event.itemIndex,
    ));
  }
}
