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
  bool _isLoading = false;

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
        content: Text('Are you sure you want to delete quote $quoteId?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteQuote(quoteId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteQuote(String quoteId) async {
    setState(() {
      _isLoading = true;
    });

    final firebaseService = Provider.of<FirebaseService>(context, listen: false);

    try {
      await firebaseService.deleteQuote(quoteId);
      _deleteController.clear();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote $quoteId deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting quote: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _retryLoading() {
    setState(() {});
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
            onPressed: _isLoading ? null : _showDeleteDialog,
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading quotes',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _retryLoading,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final quotes = snapshot.data ?? [];

          if (quotes.isEmpty) {
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
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return QuoteCard(quote: quote);
            },
          );
        },
      ),
    );
  }
}