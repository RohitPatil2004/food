import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/recipe_service.dart';
import 'youtube_video.dart';
import '../services/bookmark_service.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final int recipeId;
  final String recipeTitle;

  const RecipeDetailsScreen({
    Key? key,
    required this.recipeId,
    required this.recipeTitle,
  }) : super(key: key);

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late Future<Map<String, dynamic>> _recipeDetails;
  String? _youtubeVideoId;
  bool _isLoadingVideo = false;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _recipeDetails = RecipeService.getRecipeDetails(widget.recipeId);
    _fetchYoutubeVideo();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final bookmarked = await BookmarkService.isBookmarked(widget.recipeId);
    setState(() {
      _isBookmarked = bookmarked;
    });
  }

  Future<void> _toggleBookmark(Map<String, dynamic> recipe) async {
    if (_isBookmarked) {
      await BookmarkService.removeBookmark(widget.recipeId);
    } else {
      // Save minimal recipe info for bookmark
      final bookmarkData = {
        'id': widget.recipeId,
        'title': widget.recipeTitle,
        'image': recipe['image'],
      };
      await BookmarkService.addBookmark(bookmarkData);
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  Future<void> _fetchYoutubeVideo() async {
    setState(() => _isLoadingVideo = true);
    
    const apiKey = 'AIzaSyDU_jztpM8Voo-akYziQyoNQoTeJfcWCm4';
    final query = '${widget.recipeTitle} recipe'.replaceAll(' ', '+');
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey&maxResults=1',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          setState(() {
            _youtubeVideoId = data['items'][0]['id']['videoId'];
          });
        }
      }
    } catch (e) {
      debugPrint('YouTube API Error: $e');
    } finally {
      setState(() => _isLoadingVideo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeTitle),
        backgroundColor: Colors.deepOrange,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: _recipeDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final recipe = snapshot.data!;
                return IconButton(
                  icon: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                  onPressed: () => _toggleBookmark(recipe),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      floatingActionButton: _youtubeVideoId != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YoutubeVideoPage(
                      videoId: _youtubeVideoId!,
                      recipeTitle: widget.recipeTitle,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.play_arrow),
              backgroundColor: Colors.red,
            )
          : null,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _recipeDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.deepOrange),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber, size: 48, color: Colors.amber),
                  SizedBox(height: 16),
                  Text(
                    'No recipe details found',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          final recipe = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoadingVideo)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                    ),
                  )
                else if (recipe['image'] != null)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        recipe['image'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingredients:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...(recipe['extendedIngredients'] as List).map((ingredient) => 
                          ListTile(
                            leading: Icon(Icons.circle, size: 8, color: Colors.deepOrange),
                            title: Text(ingredient['original']),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Instructions:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        if (recipe['analyzedInstructions'] != null && 
                            recipe['analyzedInstructions'].isNotEmpty)
                          ...recipe['analyzedInstructions'][0]['steps'].map<Widget>((step) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Step ${step['number']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(step['step']),
                                  const Divider(color: Colors.orangeAccent),
                                ],
                              ),
                            );
                          }).toList()
                        else if (recipe['instructions'] != null && 
                                recipe['instructions'].isNotEmpty)
                          Text(recipe['instructions'])
                        else
                          Text(
                            'No instructions available',
                            style: TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}