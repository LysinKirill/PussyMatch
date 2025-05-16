import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cat.dart';
import '../bloc/liked_cats/liked_cats_bloc.dart';

class FilterDropdown extends StatelessWidget {
  final Function(String?) onBreedSelected;

  const FilterDropdown({
    super.key,
    required this.onBreedSelected,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LikedCatsBloc>().state;

    if (state is! LikedCatsLoaded) return const SizedBox();

    final uniqueBreeds = state.cats
        .map((cat) => cat.breed)
        .toSet()
        .toList();

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: DropdownButton<String?>(
        hint: const Text('Filter by breed'),
        value: state.filteredBreedId,
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text('All breeds'),
          ),
          ...uniqueBreeds.map((breed) {
            return DropdownMenuItem(
              value: breed.id,
              child: Text(breed.name),
            );
          }).toList(),
        ],
        onChanged: onBreedSelected,
      ),
    );
  }
}