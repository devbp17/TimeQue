import 'package:flutter/material.dart';
import 'package:proyek/utils/constants.dart';

class GameContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String imagePath;

  const GameContainer({
    super.key,
    required this.onTap,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(5),
        ),
        width: 120,
        height: 150,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(imagePath,fit: BoxFit.contain,)
                )
              ),
              SizedBox(height: 10),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
