class Quotes {
  final String id;
  final String text;
  final String category;
  final String imageUrl;
  final int likes;

  Quotes({
    required this.id,
    required this.text,
    required this.category,
    required this.imageUrl,
    required this.likes,
  });

  factory Quotes.fromMap(Map<String, dynamic> data, String id) {
    return Quotes(
      id: id,
      text: data['text'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      likes: data['likes'] ?? 0,
    );
  }
}
