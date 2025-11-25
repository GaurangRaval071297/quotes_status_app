class Quotes {
  final String id;
  final String text;
  final String category;
  final String imageUrl;
  final int likes;
  final DateTime timestamp;
  bool liked;

  Quotes({
    required this.id,
    required this.text,
    required this.category,
    required this.imageUrl,
    required this.likes,
    required this.timestamp,
    this.liked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'imageUrl': imageUrl,
      'likes': likes,
      'timestamp': timestamp.millisecondsSinceEpoch,

    };
  }

  factory Quotes.fromMap(Map<String, dynamic> map, String id) {
    return Quotes(
      id: id,
      // ✅ Document ID use karen
      text: map['text'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      likes: map['likes'] ?? 0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      liked: map['liked'] ?? false,
    );
  }
}