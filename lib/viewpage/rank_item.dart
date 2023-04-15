import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RankItem extends StatefulWidget {
  String uid;
  String firstName;
  int streak;
  int rank;
  bool isUser;

  RankItem({
    required this.uid,
    required this.firstName,
    required this.isUser,
    this.streak = 0,
    this.rank = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<RankItem> createState() => _RankItemState();
}

class _RankItemState extends State<RankItem> {
  Color nonUserColor = Colors.white;
  Color userColor = Colors.yellow;

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tileColor: widget.isUser ? userColor : nonUserColor,
      leading: Text(
        widget.rank.toString(),
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
      ),
      title: Text(
        widget.firstName,
        style: const TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 35, 112, 255),
        ),
      ),
      trailing: Text(
        widget.streak.toString(),
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
      ),
    );
  }
}
