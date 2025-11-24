class Quotes {
  final String id;
  final String text;
  final String imageUrl;
  final String category;
  final int likes;

  Quotes({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.category,
    required this.likes,
  });

  factory Quotes.fromMap(Map<String, dynamic> data, String id) {
    return Quotes(
      id: id,
      text: data['text'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      likes: data['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'category': category,
      'likes': likes,
    };
  }
}
