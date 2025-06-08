class Message {
  Message({
    required this.id,
    required this.from,
    required this.to,
    required this.content,
    required this.createdAt,
    required this.isMine,
  });

  final String id;

  final String from;

  final String to;

  final String content;

  final DateTime createdAt;

  final bool isMine;
}
