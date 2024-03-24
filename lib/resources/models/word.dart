class Word {
  final String id;
  late String english;
  late String vietnamese;
  final int created_at;
  late String type;

  Word({
    required this.id,
    required this.created_at,
    required this.type,
    required this.english,
    required this.vietnamese,
  });

  Word copyWith({
    String? english,
    String? vietnamese,
    String? type,
  }) {
    return Word(
      id: this.id,
      created_at: this.created_at,
      type: type ?? this.type,
      english: english ?? this.english,
      vietnamese: vietnamese ?? this.vietnamese,
    );
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      created_at: json['created_at'],
      type: json['type'],
      english: json['english'],
      vietnamese: json['vietnamese'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': created_at,
      'type': type,
      'english': english,
      'vietnamese': vietnamese,
    };
  }
}
