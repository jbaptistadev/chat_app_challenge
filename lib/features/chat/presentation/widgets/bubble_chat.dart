import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';

class BubbleChat extends StatelessWidget {
  final String content;
  final bool isMine;
  final DateTime createdAt;

  const BubbleChat({
    super.key,
    required this.content,
    required this.isMine,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return isMine ? _ownMessage() : _otherMessage();
  }

  Widget _ownMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10, left: 50, right: 5),
        decoration: BoxDecoration(
          color: const Color(0xff0098db),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(content, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 5),
            Text(
              format(createdAt, locale: 'es'),
              style: const TextStyle(
                color: Color.fromARGB(137, 232, 231, 231),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otherMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10, right: 50, left: 5),
        decoration: BoxDecoration(
          color: const Color(0xff1e579c),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 5),
            Text(
              format(createdAt, locale: 'es'),
              style: const TextStyle(
                color: Color.fromARGB(137, 232, 231, 231),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
