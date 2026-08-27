import "../../domain/entities/friendship.dart";

class FriendshipModel extends Friendship {
  const FriendshipModel({
    required super.id,
    required super.userId,
    required super.friendId,
    required super.createdAt,
  });

  factory FriendshipModel.fromJson(Map<String, dynamic> json) {
    return FriendshipModel(
      id: json["id"] as String,
      userId: json["user_id"] as String,
      friendId: json["friend_id"] as String,
      createdAt: DateTime.parse(json["created_at"] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "friend_id": friendId,
    "created_at": createdAt.toIso8601String(),
  };
}
