import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/int.dart';
import '../utils/string.dart';
import '../core/models/pokemon_model.dart';
import '../core/service/pokemon_service.dart';
import '../utils/style/colors.dart';
import '../utils/style/elevation.dart';
import '../utils/style/typography.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PokemonService().getPokemon(url),
      builder: (context, snapshot) {
        PokemonModel? pokemon;
        if (snapshot.hasData) {
          pokemon = snapshot.data;
        }
        return LayoutBuilder(
          builder: (context, constraint) {
            return InkWell(
              onTap: () {
                context.goNamed(
                  'pokemon',
                  pathParameters: {
                    'id': '${pokemon?.id}',
                  },
                  extra: url,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: GrayScale.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: DropShadow.dp2,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: constraint.maxHeight * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: GrayScale.background,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: pokemon?.sprites.other?.officialArtwork.frontDefault != null
                          ? Image.network(pokemon!.sprites.other!.officialArtwork.frontDefault)
                          : Image.asset('assets/images/img_silhouette.png'),
                    ),
                    Positioned(
                      top: 4,
                      right: 8,
                      child: Text(
                        pokemon?.id.toNumberFormat() ?? '#999',
                        style: Body.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 8,
                      left: 8,
                      child: Text(
                        pokemon?.name.capitalizeFirstLetter() ?? 'Pokémon Name',
                        style: Body.body3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
