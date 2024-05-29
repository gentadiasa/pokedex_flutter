import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_flutter/widget/search_textfield.dart';
import '../core/bloc/home/pokedex_bloc.dart';
import '../utils/service_const.dart';
import '../widget/pokemon_card.dart';
import '../utils/style/colors.dart';
import '../utils/style/elevation.dart';
class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  int limit = 16;
  bool isBottom = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<PokedexBloc>().add(GetPokedexEvent(url: '$baseUrl/pokemon/?offset=0&limit=$limit'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Center(
                    child:
                      Image.network(
                        "https://pokeapi.co/static/pokeapi_256.3fa72200.png",
                        width: 150,
                        height: 100,
                      ),
                  ),
                  SearchTextfield(searchController: _searchController)
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  boxShadow: InnerShadow.dp2,
                  borderRadius: BorderRadius.circular(8),
                  color: GrayScale.white,
                ),
                child: BlocBuilder<PokedexBloc, PokedexState>(
                  builder: (context, state) {
                    if (state is PokedexSuccess || state is PokedexFind) {
                      _scrollController.addListener(() {
                        if ((_scrollController.position.pixels == _scrollController.position.maxScrollExtent) &&
                            state.pokedex.next != null) {
                          context.read<PokedexBloc>().add(GetMorePokedexEvent(url: state.pokedex.next!));
                        }
                      });

                      final results = state.pokedexSearch ?? state.pokedex.results;

                      return SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 12,
                                crossAxisCount: 3,
                                crossAxisSpacing: 6,
                              ),
                              itemCount: results.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index < results.length) {
                                  return PokemonCard(url: results[index].url);
                                }
                                if (state.pokedex.next != null && _searchController.text == '') {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    } else if (state is PokedexFailed) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else if (state is PokedexLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
