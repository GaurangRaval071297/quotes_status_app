import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Category.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Example: initialize default categories (if needed)
  Future<void> initializeData() async {
    final categoriesRef = _db.collection('categories');

    final snapshot = await categoriesRef.get();
    if (snapshot.docs.isEmpty) {
      // Add some default categories
      await categoriesRef.add({
        'name': 'Motivation',
        'imageUrl': 'https://example.com/motivation.jpg',
      });
      await categoriesRef.add({
        'name': 'Life',
        'imageUrl': 'https://example.com/life.jpg',
      });
      // Add more categories as needed
    }
  }

  // Stream of categories
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => Category.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }
}
