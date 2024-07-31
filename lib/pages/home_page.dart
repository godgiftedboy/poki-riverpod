import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poki/controllers/homepage_controller.dart';
import 'package:poki/helpers/helpers.dart';
import 'package:poki/models/page_data.dart';
import 'package:poki/models/pokemon.dart';
import 'package:poki/provider/pokemon_data_provider.dart';
import 'package:poki/widgets/pokemon_card.dart';
import 'package:poki/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>(
  (ref) => HomePageController(
    HomePageData.initial(),
  ),
);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late HomePageController _homePageController;
  late HomePageData _homePageData;

  final ScrollController _allPokemonListScrollController = ScrollController();

  late List<String> _favouritePokemons;

  @override
  void initState() {
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListerner);
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollListerner);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListerner() {
    if ((_allPokemonListScrollController.offset >=
            _allPokemonListScrollController.position.maxScrollExtent * 1) &&
        !_allPokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(
      homePageControllerProvider.notifier,
    );
    _homePageData = ref.watch(homePageControllerProvider);

    _favouritePokemons = ref.watch(favouritePokemonProvider);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.symmetric(
              horizontal: getWidth(context) * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _favouritePokemonsList(
                  context,
                ),
                _allPokemonList(
                  context,
                ),
              ],
            )),
      )),
    );
  }

  Widget _allPokemonList(
    BuildContext context,
  ) {
    return SizedBox(
      width: getWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All Pokemons",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: getHeight(context) * 0.6,
            child: ListView.builder(
                controller: _allPokemonListScrollController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokemon =
                      _homePageData.data!.results![index];
                  return PokemonListTile(pokemonUrl: pokemon.url!);
                }),
          )
        ],
      ),
    );
  }

  Widget _favouritePokemonsList(BuildContext context) {
    return SizedBox(
      width: getWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favourites",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: getHeight(context) * 0.5,
            width: getWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favouritePokemons.isEmpty)
                  const Text("No Favourite pokemons yet!"),
                if (_favouritePokemons.isNotEmpty)
                  SizedBox(
                    height: getHeight(context) * 0.48,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: _favouritePokemons.length,
                        itemBuilder: (context, index) {
                          String pokemonUrl = _favouritePokemons[index];
                          return PokemonCard(pokemonUrl: pokemonUrl);
                        }),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
