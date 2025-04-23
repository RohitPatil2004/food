import 'package:flutter/material.dart';
import '../services/bookmark_service.dart';
import 'recipe_details_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late Future<List<Map<String, dynamic>>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    _bookmarksFuture = BookmarkService.getBookmarks();
  }

  Future<void> _removeBookmark(int recipeId) async {
    await BookmarkService.removeBookmark(recipeId);
    setState(() {
      _loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookmarksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final bookmarks = snapshot.data ?? [];
          if (bookmarks.isEmpty) {
            return const Center(child: Text('No bookmarks yet.'));
          }
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final recipe = bookmarks[index];
              return ListTile(
                leading: recipe['image'] != null
                    ? Image.network(
                        recipe['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : null,
                title: Text(recipe['title'] ?? 'No title'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeBookmark(recipe['id']),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailsScreen(
                        recipeId: recipe['id'],
                        recipeTitle: recipe['title'] ?? '',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
