import 'package:flutter/material.dart';
import 'package:fruit_cutting_game/main_router_game.dart';
import 'package:proyek/screens/widgets/game_container.dart';
import 'package:flame/game.dart';

class GameListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game List')),
      body: GameContainer(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GameWidget(game: MainRouterGame())),
          );
        },
        title: "Fruit Slicing",
        imagePath: "assets/images/fruit-slicing.png",
      ),
    );
  }
}
