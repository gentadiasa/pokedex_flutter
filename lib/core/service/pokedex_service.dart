import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/pokedex_model.dart';

class PokedexService {
  Future<PokedexModel> getPokedex(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return PokedexModel.fromJson(jsonDecode(response.body));
    } catch (_) {
      rethrow;
    }
  }
}
