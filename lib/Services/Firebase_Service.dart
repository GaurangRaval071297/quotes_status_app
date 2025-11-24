import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';
import '../models/quotes.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize default data
  Future<void> initializeData() async {
    final categoriesRef = _db.collection('categories');
    final quotesRef = _db.collection('quotes');

    // Check if categories already exist
    final categoriesSnapshot = await categoriesRef.get();
    if (categoriesSnapshot.docs.isEmpty) {
      // Add default categories
      final categories = [
        {
          'name': 'Motivational',
          'imageUrl': 'https://picsum.photos/200/300?random=1',
        },
        {
          'name': 'Friendship',
          'imageUrl': 'https://picsum.photos/200/300?random=2',
        },
        {
          'name': 'Love',
          'imageUrl': 'https://picsum.photos/200/300?random=3',
        },
        {
          'name': 'Success',
          'imageUrl': 'https://picsum.photos/200/300?random=4',
        },
        {
          'name': 'Life',
          'imageUrl': 'https://picsum.photos/200/300?random=5',
        },
      ];

      for (var category in categories) {
        await categoriesRef.add(category);
      }
    }

    // Check if quotes already exist
    final quotesSnapshot = await quotesRef.get();
    if (quotesSnapshot.docs.isEmpty) {
      // Add sample quotes
      final quotes = [
        {
          'text': 'The only way to do great work is to love what you do.',
          'category': 'Motivational',
          'imageUrl': 'https://picsum.photos/400/600?random=10',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'A real friend is one who walks in when the rest of the world walks out.',
          'category': 'Friendship',
          'imageUrl': 'https://picsum.photos/400/600?random=11',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Love is composed of a single soul inhabiting two bodies.',
          'category': 'Love',
          'imageUrl': 'https://picsum.photos/400/600?random=12',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
          'category': 'Success',
          'imageUrl': 'https://picsum.photos/400/600?random=13',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Life is what happens to you while you\'re busy making other plans.',
          'category': 'Life',
          'imageUrl': 'https://picsum.photos/400/600?random=14',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      ];

      for (var quote in quotes) {
        await quotesRef.add(quote);
      }
    }
  }

  // Stream of categories
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  // Stream of quotes by category
  Stream<List<Quotes>> getQuotesByCategory(String category) {
    return _db
        .collection('quotes')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Quotes.fromMap(doc.data(), doc.id))
        .toList()
    );
  }

  // Like a quote
  Future<void> likeQuote(String quoteId, int currentLikes) async {
    await _db.collection('quotes').doc(quoteId).update({
      'likes': currentLikes + 1,
    });
  }

  // Delete a quote
  Future<void> deleteQuote(String quoteId) async {
    await _db.collection('quotes').doc(quoteId).delete();
  }

  // Add a new quote
  Future<void> addQuote(Quotes quote) async {
    await _db.collection('quotes').doc(quote.id).set(quote.toMap());
  }
}
