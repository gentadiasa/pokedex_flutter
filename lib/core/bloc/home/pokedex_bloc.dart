import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/pokedex_model.dart';
import '../../service/pokedex_service.dart';

part 'pokedex_event.dart';
part 'pokedex_state.dart';

class PokedexBloc extends Bloc<PokedexEvent, PokedexState> {
  final PokedexService _service;
  PokedexBloc(this._service) : super(PokedexInitial()) {
    PokedexModel? pokedex;

    on<GetPokedexEvent>((event, emit) async {
      try {
        emit(PokedexLoading());
        pokedex = await _service.getPokedex(event.url);
        emit(PokedexSuccess(pokedex!));
      } catch (e) {
        emit(PokedexFailed(data: state.pokedex, message: e.toString()));
      }
    });

    on<GetMorePokedexEvent>((event, emit) async {
      try {
        final newPokedex = await _service.getPokedex(event.url);
        pokedex?.previous = newPokedex.previous;
        pokedex?.next = newPokedex.next;
        pokedex?.results.addAll(newPokedex.results);
        emit(PokedexSuccess(pokedex!));
      } catch (e) {
        emit(PokedexFailed(data: state.pokedex, message: e.toString()));
      }
    });

    on<SearchPokedexEvent>((event, emit) async {
      List<Result> searchList = [];
      searchList = state.pokedex.results.where((element) {
        return element.name.toLowerCase().contains(event.query.trim().toLowerCase());
      },).toList();
      emit(PokedexFind(searchResult: searchList, data: state.pokedex));
    });
  }
}
