class Word {
  final String id;
  late String english;
  late String vietnamese;

  Word({
    required this.id,
    required this.english,
    required this.vietnamese,
  });
  Word copyWith({
    String? english,
    String? vietnamese,
  }) {
    return Word(
      english: english ?? this.english,
      vietnamese: vietnamese ?? this.vietnamese, id: '',
    );
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      english: json['english'],
      vietnamese: json['vietnamese'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'vietnamese': vietnamese,
    };
  }
}
