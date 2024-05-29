import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonService {
  Future<PokemonModel> getPokemon(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return PokemonModel.fromJson(jsonDecode(response.body));
    } catch (_) {
      rethrow;
    }
  }
}
