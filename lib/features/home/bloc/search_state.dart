import 'package:lista_compras/features/home/domain/entities/home_entity.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchFetchSuccess extends SearchState {
  final List<HomeEntity> searchResults;
  SearchFetchSuccess(this.searchResults);
}

class SearchFetchError extends SearchState {
  final String message;
  SearchFetchError(this.message);
}
