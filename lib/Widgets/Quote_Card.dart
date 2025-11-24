import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../services/firebase_service.dart';
import '../models/quotes.dart';

class QuoteCard extends StatelessWidget {
  final Quotes quote;

  const QuoteCard({super.key, required this.quote});

  Future<void> _downloadImage(BuildContext context) async {
    try {
      // Download image
      final response = await http.get(Uri.parse(quote.imageUrl));

      if (response.statusCode == 200) {
        // For now, we'll just share the image since gallery saving requires more setup
        await Share.share(
          '${quote.text}\n\nImage: ${quote.imageUrl}\n\nShared from Quotes App',
          subject: '${quote.category} Quote',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image shared successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _shareQuote(BuildContext context) async {
    try {
      await Share.share(
        '${quote.text}\n\nShared from Quotes App',
        subject: '${quote.category} Quote',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing: $e')),
      );
    }
  }

  void _likeQuote(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    firebaseService.likeQuote(quote.id, quote.likes);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Quote Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              quote.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Image not available', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),

          // Quote Text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              quote.text,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Like Button
                _ActionButton(
                  icon: quote.likes > 0 ? Icons.favorite : Icons.favorite_border,
                  label: '${quote.likes}',
                  onPressed: () => _likeQuote(context),
                  color: Colors.red,
                ),

                // Share Button
                _ActionButton(
                  icon: Icons.share,
                  label: 'Share',
                  onPressed: () => _shareQuote(context),
                  color: Colors.blue,
                ),

                // Download Button
                _ActionButton(
                  icon: Icons.download,
                  label: 'Save',
                  onPressed: () => _downloadImage(context),
                  color: Colors.green,
                ),
              ],
            ),
          ),

          // Quote ID and Category
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category: ${quote.category}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'ID: ${quote.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          iconSize: 28,
          color: color,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
