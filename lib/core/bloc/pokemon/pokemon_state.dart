part of 'pokemon_bloc.dart';

@immutable
sealed class PokemonState {}

final class PokemonInitial extends PokemonState {}

final class PokemonLoading extends PokemonState {}

final class PokemonSuccess extends PokemonState {
  final PokemonModel pokemon;

  PokemonSuccess({required this.pokemon});
}

final class PokemonFailed extends PokemonState {
  final String message;

  PokemonFailed({required this.message});
}
