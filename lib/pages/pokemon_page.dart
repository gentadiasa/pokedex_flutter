import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../core/bloc/home/pokedex_bloc.dart';
import '../core/bloc/pokemon/pokemon_bloc.dart';
import '../widget/pokemon_type_label.dart';
import '../utils/service_const.dart';
import '../utils/int.dart';
import '../utils/string.dart';
import '../core/models/pokemon_model.dart';
import '../utils/style/colors.dart';
import '../utils/style/elevation.dart';
import '../utils/style/typography.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key, required this.url});

  final String url;

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  @override
  void initState() {
    context.read<PokemonBloc>().add(GetPokemonEvent(url: widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        if (state is PokemonSuccess) {
          final pokemon = state.pokemon;
          final color = PokemonType.getColor(state.pokemon.types.first.type.name);

          return Scaffold(
            backgroundColor: color,
            body: Stack(
              children: [
                Positioned(
                  top: 40,
                  right: 20,
                  child: SvgPicture.asset(
                    'assets/icons/ic_pokeball.svg',
                    width: 208,
                    height: 208,
                    colorFilter: ColorFilter.mode(
                      GrayScale.white.withOpacity(0.1),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SafeArea(
                  child: Stack(
                    children: [
                      _detailCard(context, color, pokemon),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/ic_arrow_back.svg',
                                    width: 32,
                                    height: 32,
                                    colorFilter: const ColorFilter.mode(
                                      GrayScale.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                Text(
                                  pokemon.name.capitalizeFirstLetter(),
                                  style: Header.headline.copyWith(color: GrayScale.white),
                                ),
                                const Spacer(),
                                Text(
                                  pokemon.id.toNumberFormat(),
                                  style: Header.subtitle2.copyWith(color: GrayScale.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (pokemon.id != 1) {
                                    final previousUrl = '$baseUrl/pokemon/${pokemon.id - 1}';
                                    context.read<PokemonBloc>().add(GetPokemonEvent(url: previousUrl));
                                  }
                                },
                                icon: (pokemon.id != 1)
                                    ? SvgPicture.asset(
                                        'assets/icons/ic_chevron_left.svg',
                                        width: 32,
                                        height: 32,
                                        colorFilter: const ColorFilter.mode(
                                          GrayScale.white,
                                          BlendMode.srcIn,
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              Image.network(
                                pokemon.sprites.other!.officialArtwork.frontDefault,
                                width: 200,
                                height: 200,
                              ),
                              BlocBuilder<PokedexBloc, PokedexState>(
                                builder: (context, state) {
                                  if (state is PokedexSuccess) {
                                    return IconButton(
                                      onPressed: () {
                                        if (pokemon.id != state.pokedex.count) {
                                          final previousUrl = '$baseUrl/pokemon/${pokemon.id + 1}';
                                          context.read<PokemonBloc>().add(GetPokemonEvent(url: previousUrl));
                                        }
                                      },
                                      icon: (pokemon.id != state.pokedex.count)
                                          ? SvgPicture.asset(
                                              'assets/icons/ic_chevron_right.svg',
                                              width: 32,
                                              height: 32,
                                              colorFilter: const ColorFilter.mode(
                                                GrayScale.white,
                                                BlendMode.srcIn,
                                              ),
                                            )
                                          : const SizedBox(),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is PokemonFailed) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(state.message),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _detailCard(BuildContext context, Color color, PokemonModel pokemon) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 224, 4, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        boxShadow: InnerShadow.dp2,
        borderRadius: BorderRadius.circular(8),
        color: GrayScale.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: 56),
          SizedBox(
            height: 20,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: pokemon.types.length,
              itemBuilder: (context, index) => PokemonTypeLabel(typeName: pokemon.types[index].type.name),
              separatorBuilder: (context, index) => const SizedBox(width: 16),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'About',
            style: Header.subtitle1.copyWith(color: color),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_weight.svg',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          pokemon.weight.toWeightString(),
                          style: Body.body3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Weight',
                    style: Body.caption,
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 48,
                color: GrayScale.light,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_straighten.svg',
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          pokemon.height.toHeightString(),
                          style: Body.body3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Height',
                    style: Body.caption,
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 48,
                color: GrayScale.light,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 32,
                    child: Column(
                      children: (pokemon.abilities.length > 2 ? pokemon.abilities.take(2) : pokemon.abilities)
                          .map(
                            (e) => Text(
                              e.ability.name.capitalizeEachWord(),
                              style: Body.body3,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Moves',
                    style: Body.caption,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Base Stats',
            style: Header.subtitle1.copyWith(color: color),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _stat(context, 'HP', pokemon.stats[0].baseStat, color),
              _stat(context, 'ATK', pokemon.stats[1].baseStat, color),
              _stat(context, 'DEF', pokemon.stats[2].baseStat, color),
              _stat(context, 'SATK', pokemon.stats[3].baseStat, color),
              _stat(context, 'SDEF', pokemon.stats[4].baseStat, color),
              _stat(context, 'SPD', pokemon.stats[5].baseStat, color),
            ],
          )
        ],
      ),
    );
  }

  Widget _stat(
    BuildContext context,
    String attribute,
    int value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 30,
          child: Text(
            attribute,
            style: Header.subtitle3.copyWith(color: color),
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 1,
          height: 16,
          color: GrayScale.light,
        ),
        const SizedBox(width: 8),
        Text(
          value.toNumberFormat().substring(1),
          style: Body.body3,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            backgroundColor: color.withOpacity(0.25),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            value: value / 100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
