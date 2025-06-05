import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../domain/entities/cat.dart';
import '../bloc/cat_list/cat_list_bloc.dart';

class ActionButtons extends StatelessWidget {
  final CardSwiperController controller;
  final int currentIndex;
  final List<Cat> cats;

  const ActionButtons({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.cats,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dislike button
          IconButton(
            icon: const Icon(Icons.thumb_down, size: 40, color: Colors.red),
            onPressed: () async {
              controller.swipe(CardSwiperDirection.left);
                context.read<CatListBloc>().add(const CatSwiped());
            },
          ),
          const SizedBox(width: 40),
          // Like button
          IconButton(
            icon: const Icon(Icons.thumb_up, size: 40, color: Colors.green),
            onPressed: () async {
              controller.swipe(CardSwiperDirection.right);
            },
          ),
        ],
      ),
    );
  }
}
