class Word {
  String? id;
  String? english;
  String vietnamese;
  int createdAt;
  int updatedAt;
  String type;
  String? imageUrl;
  bool learnt;
  Map<String, dynamic> markedUser;

  Word({
    this.id,
    this.english,
    required this.vietnamese,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    this.imageUrl,
    required this.learnt,
    required this.markedUser,
  });

  Word copyWith({
    String? id,
    String? english,
    String? vietnamese,
    int? createdAt,
    int? updatedAt,
    String? type,
    String? imageUrl,
    bool? learnt,
    Map<String, dynamic>? markedUser,
  }) {
    return Word(
      id: id ?? this.id,
      english: english ?? this.english,
      vietnamese: vietnamese ?? this.vietnamese,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      learnt: learnt ?? this.learnt,
      markedUser: markedUser ?? this.markedUser,
    );
  }

  factory Word.fromMap(Map<String, dynamic> map, String id) {
    return Word(
      id: id,
      english: map['english'],
      vietnamese: map['vietnamese'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      type: map['type'] ?? '',
      imageUrl: map['imageUrl'],
      learnt: map['learnt'] ?? false,
      markedUser: map['markedUser'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'english': english,
      'vietnamese': vietnamese,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'type': type,
      'imageUrl': imageUrl,
      'learnt': learnt,
      'markedUser': markedUser,
    };
  }
}
