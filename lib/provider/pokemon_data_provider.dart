import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:poki/models/pokemon.dart';
import 'package:poki/services/database_service.dart';
import 'package:poki/services/http_service.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HTTPService _httpService = GetIt.instance.get<HTTPService>();
  Response? res = await _httpService.get(url);
  if (res != null && res.data != null) {
    return Pokemon.fromJson(res.data!);
  }
  return null;
});

final favouritePokemonProvider =
    StateNotifierProvider<FavouritePokemonProvider, List<String>>(
  //                      //Provider type          //statetype
  (ref) {
    return FavouritePokemonProvider([]);
  },
);

class FavouritePokemonProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();

  String FAVOURITE_POKEMON_LIST_KEY = "FAVOURITE_POKEMON_LIST_KEY";
  FavouritePokemonProvider(
    super._state,
  ) {
    _setup();
  }
  Future<void> _setup() async {
    List<String>? result =
        await _databaseService.getList(FAVOURITE_POKEMON_LIST_KEY);
    state = result ?? [];
  }

  void addFavouritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }

  void removeFavouritePokemon(String url) {
    state = state.where((element) => element != url).toList();
    _databaseService.saveList(FAVOURITE_POKEMON_LIST_KEY, state);
  }
}
