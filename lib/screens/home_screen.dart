import 'package:flutter/material.dart';
import 'package:tic_tac_game/models/logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            SwitchListTile.adaptive(
              title: const Text(
                'Turn Of/On Two Players',
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              value: isSwitched,
              onChanged: (newValue) {
                setState(
                  () {
                    isSwitched = newValue;
                  },
                );
              },
            ),
            Text(
              'it\'s $activePlayer Turn'.toUpperCase(),
              style: const TextStyle(fontSize: 50),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: GridView.count(
                  padding: const EdgeInsets.all(8),
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: List.generate(
                    9,
                    (index) => InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: gameOver ? null : () => _onTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                            Player.playerX.contains(index)
                                ? 'X'
                                : Player.playerO.contains(index)
                                    ? 'O'
                                    : '',
                            style: TextStyle(
                                fontSize: 40,
                                color: Player.playerX.contains(index)
                                    ? Colors.blue
                                    : Colors.red),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
            Text(
              result.toUpperCase(),
              style: const TextStyle(fontSize: 45),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).splashColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)))),
              onPressed: () {
                setState(() {
                  Player.playerX = [];
                  Player.playerO = [];
                  activePlayer = 'X';
                  gameOver = false;
                  turn = 0;
                  result = '';
                  isSwitched = false;
                });
              },
              icon: const Icon(Icons.repeat),
              label: const Text(
                'Repeat The Game',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  _onTap(int index) async {
    if ((!Player.playerX.contains(index) || Player.playerX.isEmpty) &&
        (!Player.playerO.contains(index) || Player.playerO.isEmpty)) {
      game.playGame(index, activePlayer);
      updateState();
      if (!gameOver && !isSwitched && turn!=9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    return setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;
      String winner = game.checkWinner();
      if (winner != '') {
        gameOver = false;
        result = 'Winner Is $winner';
      } else if (gameOver && turn == 9) {
        result = 'It\'s Draw';
      }
    });
  }
}
