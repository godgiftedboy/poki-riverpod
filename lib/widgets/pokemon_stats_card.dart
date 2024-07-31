import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poki/provider/pokemon_data_provider.dart';

class PokemonStatCard extends ConsumerWidget {
  final String pokemonUrl;

  const PokemonStatCard({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return AlertDialog(
        title: const Text("Statistics"),
        content: pokemon.when(
          data: (data) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: data?.stats
                      ?.map((e) => Text(
                          "${e.stat?.name?.toUpperCase()} : ${e.baseStat}"))
                      .toList() ??
                  [],
            );
          },
          error: (error, stackTree) {
            return Text("Error: $error");
          },
          loading: () => const CircularProgressIndicator(
            color: Colors.white,
          ),
        ));
  }
}
