import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:poki/models/pokemon.dart';
import 'package:poki/services/http_service.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HTTPService _httpService = GetIt.instance.get<HTTPService>();
  Response? res = await _httpService.get(url);
  if (res != null && res.data != null) {
    return Pokemon.fromJson(res.data!);
  }
});

final favouritePokemonProvider =
    StateNotifierProvider<FavouritePokemonProvider, List<String>>(
  //                      //Provider type          //statetype
  (ref) {
    return FavouritePokemonProvider([]);
  },
);

class FavouritePokemonProvider extends StateNotifier<List<String>> {
  FavouritePokemonProvider(
    super._state,
  ) {
    _setup();
  }
  Future<void> _setup() async {}

  void addFavouritePokemon(String url) {
    state = [...state, url];
  }

  void removeFavouritePokemon(String url) {
    state = state.where((element) => element != url).toList();
  }
}
