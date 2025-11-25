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
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThbBW04FAMjP1uvkbYI9EDqTY4Xncj_Crrww&s',
        },
        {
          'name': 'Friendship',
          'imageUrl': 'https://nationaltoday.com/wp-content/uploads/2021/12/International-Friendship-Month-1200x834.jpg',
        },
        {
          'name': 'Love',
          'imageUrl': 'https://img.freepik.com/free-photo/book-with-its-pages-shaping-as-heart_23-2148213870.jpg?semt=ais_hybrid&w=740&q=80',
        },
        {
          'name': 'Success',
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMRT9HQV6nkaV1fjxTasH7US2scNleVheNPQ&s',
        },
        {
          'name': 'Life',
          'imageUrl': 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjiBUAZk7VBC3pAUE_I1HcJsQsKSg_r7TL1ZyRJ56NG7Xva0OYoZBSlhDnFcJD8SGttE3KAXBeWTQvDpOwJhVw86C4QpxGUKOCUPSOXn8BDol_Hl2zVPwnAmtsosIHgYRB3czp7y3uFy8k/s1600/1wordLivelifenoregrets.jpg',
        },
        {
          'name': 'Sad',
          'imageUrl': 'https://images.pexels.com/photos/48794/boy-walking-teddy-bear-child-48794.jpeg?cs=srgb&dl=pexels-pixabay-48794.jpg&fm=jpg',
        },
        {
          'name': 'Positive Vibes',
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9HtOnT4caM6SY570smtoZj68Ik5DSXnep1H0aksAQ02J-El-k9V3mfefesPjYhEp_jxo&usqp=CAU',
        },
        {
          'name': 'Hard Work',
          'imageUrl': 'https://specials-images.forbesimg.com/imageserve/607f03cd14a3c2843c2b8664/960x0.jpg',
        },
        {
          'name': 'Breakup',
          'imageUrl': 'https://media.istockphoto.com/id/956341550/photo/grief-divorce-couple-holding-broken-heart-unhappy-relationship-hurt-feeling-for-lover.jpg?s=612x612&w=0&k=20&c=35Emjgi6PMaN4a1v_WJwVE8M0za-JgBbPE7oTTZcbDY=',
        },
        {
          'name': 'Family',
          'imageUrl': 'https://kidsusamontessori.org/wp-content/uploads/2024/12/Family-Top-Parenting-Resolutions-for-the-New-Year.jpg',
        },
        {
          'name': 'Respect',
          'imageUrl': 'https://susandayley.wordpress.com/wp-content/uploads/2011/05/handshake.jpg',
        },
        {
          'name': 'Trust',
          'imageUrl': 'https://susandayley.wordpress.com/wp-content/uploads/2011/05/handshake.jpg',
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
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThbBW04FAMjP1uvkbYI9EDqTY4Xncj_Crrww&s',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'A real friend is one who walks in when the rest of the world walks out.',
          'category': 'Friendship',
          'imageUrl': 'https://nationaltoday.com/wp-content/uploads/2021/12/International-Friendship-Month-1200x834.jpg',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Love is composed of a single soul inhabiting two bodies.',
          'category': 'Love',
          'imageUrl': 'https://img.freepik.com/free-photo/book-with-its-pages-shaping-as-heart_23-2148213870.jpg?semt=ais_hybrid&w=740&q=80',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
          'category': 'Success',
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMRT9HQV6nkaV1fjxTasH7US2scNleVheNPQ&s',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Life is what happens to you while you\'re busy making other plans.',
          'category': 'Life',
          'imageUrl': 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjiBUAZk7VBC3pAUE_I1HcJsQsKSg_r7TL1ZyRJ56NG7Xva0OYoZBSlhDnFcJD8SGttE3KAXBeWTQvDpOwJhVw86C4QpxGUKOCUPSOXn8BDol_Hl2zVPwnAmtsosIHgYRB3czp7y3uFy8k/s1600/1wordLivelifenoregrets.jpg',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'I smile, but I’m not okay.',
          'category': 'Sad',
          'imageUrl': 'https://images.pexels.com/photos/48794/boy-walking-teddy-bear-child-48794.jpeg?cs=srgb&dl=pexels-pixabay-48794.jpg&fm=jpg',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Surround yourself with people who bring out the best in you, not the stress in you.',
          'category': 'Positive Vibes',
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9HtOnT4caM6SY570smtoZj68Ik5DSXnep1H0aksAQ02J-El-k9V3mfefesPjYhEp_jxo&usqp=CAU',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Success doesn’t come from what you do occasionally; it comes from what you do consistently.',
          'category': 'Hard Work',
          'imageUrl': 'https://specials-images.forbesimg.com/imageserve/607f03cd14a3c2843c2b8664/960x0.jpg',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Sometimes the person you want the most is the person you’re better off without.',
          'category': 'Breakup',
          'imageUrl': 'https://media.istockphoto.com/id/956341550/photo/grief-divorce-couple-holding-broken-heart-unhappy-relationship-hurt-feeling-for-lover.jpg?s=612x612&w=0&k=20&c=35Emjgi6PMaN4a1v_WJwVE8M0za-JgBbPE7oTTZcbDY=',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Family is not just an important thing, it’s everything that keeps us grounded and loved.',
          'category': 'Family',
          'imageUrl': 'https://kidsusamontessori.org/wp-content/uploads/2024/12/Family-Top-Parenting-Resolutions-for-the-New-Year.jpg',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Respect is earned through actions, not demanded through words.',
          'category': 'Respect',
          'imageUrl': 'https://susandayley.wordpress.com/wp-content/uploads/2011/05/handshake.jpg',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
        {
          'text': 'Trust takes years to build, seconds to break, and a lifetime to repair.',
          'category': 'Trust',
          'imageUrl': 'https://susandayley.wordpress.com/wp-content/uploads/2011/05/handshake.jpg',
          'likes': 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      ];

      for (var quote in quotes) {
        await quotesRef.add(quote);
      }
    }
  }

  // Stream of categories - ✅ ERROR FIXED
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => Category.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id)) // ✅ Added doc.id as second parameter
          .toList(),
    );
  }

  // Stream of quotes by category - ✅ ERROR FIXED
  Stream<List<Quotes>> getQuotesByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('quotes')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Quotes.fromMap(doc.data(), doc.id)).toList());
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


  // Get quote by ID (optional - for delete confirmation)
  Future<Quotes?> getQuoteById(String quoteId) async {
    try {
      final doc = await _db.collection('quotes').doc(quoteId).get();
      if (doc.exists) {
        return Quotes.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

// Future<void> toggleLike(String quoteId, int currentLikes, bool isLiked) async {
//   await _db.collection('quotes').doc(quoteId).update({
//     'likes': isLiked ? currentLikes - 1 : currentLikes + 1,
//     'liked': !isLiked,
//   });
// }

}