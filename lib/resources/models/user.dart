class UserCurrent {
  final String username;
  final String avatar;
  List<String> topicIds;

  UserCurrent({
    required this.username,
    required this.avatar,
    required this.topicIds,
  });

  factory UserCurrent.fromMap(Map<String, dynamic> map) => UserCurrent(
        username: map['displayName'],
        avatar: map['avatarUrl'],
        topicIds: List<String>.from(map['topicIds']),
      );

  Map<String, dynamic> toMap() => {
        'displayName': username,
        'avatarUrl': avatar,
        'topicIds': topicIds,
      };
}
