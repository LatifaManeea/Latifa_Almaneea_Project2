import 'dart:math';
import 'package:html_unescape/html_unescape.dart';

final _unescape = HtmlUnescape();

class QuestionModel {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> allAnswers; // correct + incorrect, shuffled once

  QuestionModel({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.allAnswers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final correct = _unescape.convert(json['correct_answer'] as String);
    final incorrect = (json['incorrect_answers'] as List<dynamic>)
        .map((e) => _unescape.convert(e as String))
        .toList();

    final answers = [...incorrect, correct]..shuffle(Random());

    return QuestionModel(
      category: _unescape.convert(json['category'] as String),
      difficulty: json['difficulty'] as String,
      question: _unescape.convert(json['question'] as String),
      correctAnswer: correct,
      allAnswers: answers,
    );
  }
}

/// A lightweight record of one answered question, built while the quiz
/// is played, and handed to the results screen for the review list.
class AnsweredQuestion {
  final String question;
  final String selectedAnswer;
  final String correctAnswer;

  AnsweredQuestion({
    required this.question,
    required this.selectedAnswer,
    required this.correctAnswer,
  });

  bool get isCorrect => selectedAnswer == correctAnswer;
}