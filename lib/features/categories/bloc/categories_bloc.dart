import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_compras/features/categories/data/categories_repository.dart';
import 'package:lista_compras/features/categories/domain/usercases/categories_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  late final CategoriesRepository _categoriesRespository;
  late final CategoriesUsecase _categoriesUsecase;

CategoriesBloc() : super(CategoryInitial()) {
    _categoriesRespository = CategoriesRepository(Supabase.instance.client);
    _categoriesUsecase = CategoriesUsecase(_categoriesRespository);

    on<CategoriesFetchItemRequest>(_onFetchCategoriesRequested);
  }

  Future<void> _onFetchCategoriesRequested(
    CategoriesFetchItemRequest event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoryLoading());

    try {
      final categories = await _categoriesUsecase.fetchCategories();
      emit(CategoryLoadingSuccess(categories));
    } catch (e) {
      emit(CategoryLoadingError('Erro ao carregar categorias. Tente novamente.'));
    }
}
}