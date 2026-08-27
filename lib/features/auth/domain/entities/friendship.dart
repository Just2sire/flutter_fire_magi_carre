class Friendship {
  const Friendship({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String friendId;
  final DateTime createdAt;
}
