class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id, // ✅ Document ID use karen
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}