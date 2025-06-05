import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/liked_cats/liked_cats_bloc.dart';

class FilterDropdown extends StatelessWidget {
  final Function(String?) onBreedSelected;

  const FilterDropdown({super.key, required this.onBreedSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikedCatsBloc, LikedCatsState>(
      builder: (context, state) {
        if (state is! LikedCatsLoaded) return const SizedBox();

        final breeds = <String, String>{};
        for (final cat in state.cats) {
          breeds[cat.breed.id] = cat.breed.name;
        }

        final items = [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('All Breeds'),
          ),
          ...breeds.entries.map((entry) => DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          )),
        ];

        return Container(
          constraints: const BoxConstraints(maxWidth: 150),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<String>(
            value: state.filteredBreedId,
            items: items,
            onChanged: onBreedSelected,
            underline: Container(),
            icon: const Icon(Icons.filter_list),
            hint: const Text('Filter'),
            borderRadius: BorderRadius.circular(12),
            isDense: true,
          ),
        );
      },
    );
  }
}