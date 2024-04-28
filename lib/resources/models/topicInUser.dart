class TopicInUser {
  int? lastUse;
  String? id;

  TopicInUser({
    this.lastUse,
    this.id,
  });

  TopicInUser copyWith({
    int? lastUse,
    String? id,
  }) {
    return TopicInUser(
      lastUse: lastUse ?? this.lastUse,
      id: id ?? this.id,
    );
  }

  factory TopicInUser.fromMap(Map<String, dynamic> map) {
    return TopicInUser(
      lastUse: map['lastUse'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastUse': lastUse,
      'id': id,
    };
  }
}
