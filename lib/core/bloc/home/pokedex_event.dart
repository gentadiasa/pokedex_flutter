part of 'pokedex_bloc.dart';

@immutable
sealed class PokedexEvent {}

final class GetPokedexEvent extends PokedexEvent {
  final String url;

  GetPokedexEvent({required this.url});
}

final class GetMorePokedexEvent extends PokedexEvent {
  final String url;

  GetMorePokedexEvent({required this.url});
}

final class SearchPokedexEvent extends PokedexEvent {
  final String query;

  SearchPokedexEvent({required this.query});
}
