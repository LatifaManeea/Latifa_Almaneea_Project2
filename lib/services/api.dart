import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/question_model.dart';

class TriviaApiService {
  static const String baseUrl = 'https://opentdb.com';

  /// list screen
  static Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api_category.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> rawList =
          jsonData['trivia_categories'] as List<dynamic>? ?? [];
      return rawList
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load categories (status code: ${response.statusCode})',
      );
    }
  }

  /// details screen
  static Future<List<QuestionModel>> fetchQuestions(int categoryId) async {
    final uri = Uri.parse(
      '$baseUrl/api.php?amount=10&category=$categoryId&type=multiple',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData['response_code'] != 0) {
        throw Exception(
          'No questions available for this category right now.',
        );
      }

      final List<dynamic> rawList = jsonData['results'] as List<dynamic>? ?? [];
      return rawList
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load questions (status code: ${response.statusCode})',
      );
    }
  }
}