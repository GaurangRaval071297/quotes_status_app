import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import '../services/firebase_service.dart';
import '../models/quotes.dart';

class QuoteCard extends StatefulWidget {
  final Quotes quote;

  const QuoteCard({super.key, required this.quote});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      // Android 13+
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      // Android 12 or lower
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      return false;
    }

    // iOS
    if (await Permission.photos.request().isGranted) {
      return true;
    }

    return false;
  }

  Future<void> _downloadImage(BuildContext context) async {
    try {
      bool permission = await _requestPermission();
      if (!permission) {
        throw Exception("Storage permission denied");
      }

      final url = widget.quote.imageUrl;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception("Failed to download image");
      }

      Uint8List bytes = Uint8List.fromList(response.bodyBytes);

      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        name: "quote_${widget.quote.id}.jpg",
        quality: 100,
      );

      print(result);

      if (result["isSuccess"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Image saved to Gallery ✔"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception("Gallery save failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Future<void> _shareQuote(BuildContext context) async {
    try {
      // Step 1: Download the image
      final url = widget.quote.imageUrl;
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Step 2: Save the image to a temporary file
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/shared_quote_${widget.quote.id}.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Step 3: Share the image and the quote text
        final textToShare = '${widget.quote.text}\n\nShared from Quotes App';

        await Share.shareXFiles(
          [XFile(file.path)], // Share the image
          text: textToShare,  // Share the text along with it
        );
      } else {
        throw Exception("Failed to download image");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error sharing image: $e"),
        ),
      );
    }
  }


  // void _likeQuote(BuildContext context) {
  //   final firebaseService = Provider.of<FirebaseService>(context, listen: false);
  //   firebaseService.toggleLike(
  //     widget.quote.id,
  //     widget.quote.likes,
  //     widget.quote.liked,
  //   );
  // }



  void _likeQuote(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    firebaseService.likeQuote(widget.quote.id, widget.quote.likes);
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              widget.quote.imageUrl,
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

          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.quote.text,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: widget.quote.likes > 0 ? Icons.favorite : Icons.favorite_border,
                  label: '${widget.quote.likes}',
                  onPressed: () => _likeQuote(context),
                  color: Colors.red,
                ),

                _ActionButton(
                  icon: Icons.share,
                  label: 'Share',
                  onPressed: () => _shareQuote(context),
                  color: Colors.blue,
                ),

                _ActionButton(
                  icon: Icons.download,
                  label: 'Save',
                  onPressed: () => _downloadImage(context),
                  color: Colors.green,
                ),
              ],
            ),
          ),

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
                  'Category: ${widget.quote.category}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'ID: ${widget.quote.id}',
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