import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_flutter/core/bloc/home/pokedex_bloc.dart';
import 'package:pokedex_flutter/utils/style/colors.dart';
import 'package:pokedex_flutter/utils/style/elevation.dart';
import 'package:pokedex_flutter/utils/style/typography.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({
    super.key,
    required this.searchController
  });

  final TextEditingController searchController;

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      decoration: BoxDecoration(
        color: GrayScale.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: widget.searchController.text.isNotEmpty ? DropShadow.dp2 : InnerShadow.dp2,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_search.svg',
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              Identity.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.searchController,
              cursorHeight: 10,
              cursorRadius: const Radius.circular(500),
              style: const TextStyle(
                fontSize: 10,
                height: 0.9,
              ),
              onChanged: (value) {
                context.read<PokedexBloc>().add(SearchPokedexEvent(query: value));
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: Body.body3.copyWith(color: GrayScale.medium),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (widget.searchController.text.isNotEmpty)
            InkWell(
              onTap: () {
                setState(() {
                  widget.searchController.text = '';
                });
              },
              child: SvgPicture.asset(
                'assets/icons/ic_close.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Identity.primary,
                  BlendMode.srcIn,
                ),
              ),
            )
        ],
      ),
    );
  }
}
