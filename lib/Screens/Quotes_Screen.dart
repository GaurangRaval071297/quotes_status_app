import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quotes.dart';
import '../services/firebase_service.dart';
import '../widgets/quote_card.dart';

class QuotesScreen extends StatefulWidget {
  final String category;

  const QuotesScreen({super.key, required this.category});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final TextEditingController _deleteController = TextEditingController();

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quote'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter Quote ID to delete:'),
            const SizedBox(height: 10),
            TextField(
              controller: _deleteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter quote ID',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _confirmDelete(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    final quoteId = _deleteController.text.trim();
    if (quoteId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a quote ID')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete quote $quoteId? (Y/N)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close confirmation dialog
              _deleteQuote(quoteId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteQuote(String quoteId) async {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);

    try {
      await firebaseService.deleteQuote(quoteId);
      _deleteController.clear();
      Navigator.pop(context); // Close delete dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote $quoteId deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting quote: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Quotes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteDialog,
            tooltip: 'Delete Quote',
          ),
        ],
      ),
      body: StreamBuilder<List<Quotes>>(
        stream: firebaseService.getQuotesByCategory(widget.category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final quotes12 = snapshot.data ?? [];

          if (quotes12.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.quiz, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No quotes available for this category',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => firebaseService.initializeData(),
                    child: const Text('Load Sample Quotes'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: quotes12.length,
            itemBuilder: (context, index) {
              final quote = quotes12[index]; // This is now guaranteed to be a Quotes object
              return QuoteCard(quote: quote);
            },
          );
        },
      ),
    );
  }
}
