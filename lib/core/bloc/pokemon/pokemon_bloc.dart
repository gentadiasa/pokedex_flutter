import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../models/pokemon_model.dart';
import '../../service/pokemon_service.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService _service;

  PokemonBloc(this._service) : super(PokemonInitial()) {
    on<GetPokemonEvent>((event, emit) async {
      try {
        emit(PokemonLoading());
        final pokemon = await _service.getPokemon(event.url);
        emit(PokemonSuccess(pokemon: pokemon));
      } catch (e) {
        emit(PokemonFailed(message: e.toString()));
      }
    });
  }
}
