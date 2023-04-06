import 'package:flutter/material.dart';

class RankItem extends StatefulWidget {
  String uid;
  String firstName;
  int streak;
  int rank;

  RankItem({
    required this.uid,
    required this.firstName,
    this.streak = 0,
    this.rank = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<RankItem> createState() => _RankItemState();
}

class _RankItemState extends State<RankItem> {
  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tileColor: Colors.white,
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
          fontSize: 17,
          color: Colors.black,
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
