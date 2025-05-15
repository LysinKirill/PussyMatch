import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class ActionButtons extends StatelessWidget {
  final CardSwiperController controller;

  const ActionButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.thumb_down, size: 40, color: Colors.red),
            onPressed: () => controller.swipe(CardSwiperDirection.left),
          ),
          SizedBox(width: 40),
          IconButton(
            icon: Icon(Icons.thumb_up, size: 40, color: Colors.green),
            onPressed: () => controller.swipe(CardSwiperDirection.right),
          ),
        ],
      ),
    );
  }
}
