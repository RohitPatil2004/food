import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeService {
  static const String _apiKey = '248dee6cf8dd44109b434abd54c91ce0'; // Register at spoonacular.com
  static const String _baseUrl = 'https://api.spoonacular.com/recipes';

  static Future<List<dynamic>> findRecipesByIngredients(List<String> ingredients) async {
    final params = {
      'ingredients': ingredients.join(','),
      'number': '10',
      'apiKey': _apiKey
    };
    final url = Uri.parse('$_baseUrl/findByIngredients?${Uri(queryParameters: params).query}');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to load recipes');
    } catch (e) {
      throw Exception('Error fetching recipes: $e');
    }
  }

  static Future<Map<String, dynamic>> getRecipeDetails(int id) async {
    final url = Uri.parse('$_baseUrl/$id/information?apiKey=$_apiKey&includeNutrition=false');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to load recipe details');
    } catch (e) {
      throw Exception('Error fetching recipe details: $e');
    }
  }
}
