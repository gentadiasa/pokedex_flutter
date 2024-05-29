part of 'pokedex_bloc.dart';

@immutable
abstract class PokedexState {
  final PokedexModel pokedex;
  final List<Result>? pokedexSearch;
  final bool? loading;

  const PokedexState({
    required this.pokedex,
    this.pokedexSearch,
    this.loading = false,
  });
}

class PokedexInitial extends PokedexState {
  PokedexInitial() : super(pokedex: PokedexModel(count: 0, results: []), loading: false);
}

class PokedexLoading extends PokedexState {
  PokedexLoading() : super(pokedex: PokedexModel(count: 0, results: []), loading: true);
}

class PokedexSuccess extends PokedexState {
  final PokedexModel data;
  const PokedexSuccess(this.data) : super(loading: false, pokedex: data);
}

class PokedexFailed extends PokedexState {
  final PokedexModel data;
  final String message;

  const PokedexFailed({
    required this.data,
    required this.message,
  }) : super(pokedex: data, loading: false);
}

class PokedexFind extends PokedexState {
  final PokedexModel data;
  final List<Result> searchResult;

  const PokedexFind({
    required this.searchResult,
    required this.data,
  }) : super(pokedex: data, pokedexSearch: searchResult, loading: false);
}
