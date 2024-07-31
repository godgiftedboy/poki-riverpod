import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poki/models/pokemon.dart';
import 'package:poki/provider/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  late FavouritePokemonProvider _favouritePokemonProvider;
  late List<String> _favouritePokemons;

  PokemonListTile({required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favouritePokemonProvider = ref.watch(favouritePokemonProvider.notifier);
    _favouritePokemons = ref.watch(favouritePokemonProvider);
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, stackTrace) {
      return Text('Error: $error');
    }, loading: () {
      return _tile(context, true, null);
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(
                  pokemon.sprites!.frontDefault!,
                ),
              )
            : CircleAvatar(),
        title: Text(pokemon != null
            ? pokemon.name!.toUpperCase()
            : "Loading .. for full line skeltonizer"),
        subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),
        trailing: IconButton(
          onPressed: () {
            if (_favouritePokemons.contains(pokemonUrl)) {
              _favouritePokemonProvider.removeFavouritePokemon(pokemonUrl);
            } else {
              _favouritePokemonProvider.addFavouritePokemon(pokemonUrl);
            }
          },
          icon: Icon(
            _favouritePokemons.contains(pokemonUrl)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
