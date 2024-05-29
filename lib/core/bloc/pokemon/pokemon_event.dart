part of 'pokemon_bloc.dart';

@immutable
sealed class PokemonEvent {}

final class GetPokemonEvent extends PokemonEvent {
  final String url;

  GetPokemonEvent({required this.url});
}
