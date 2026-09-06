import 'package:flutter/material.dart';
import 'package:latifa_almaneea_project2/const/app_color.dart';
import '../models/question_model.dart';
import '../services/api.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<QuestionModel>> _futureQuestions;

  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _answered = false;

  final List<AnsweredQuestion> _answeredQuestions = [];

  @override
  void initState() {
    super.initState();
    _futureQuestions = TriviaApiService.fetchQuestions(widget.categoryId);
  }

  void _retry() {
    setState(() {
      _futureQuestions = TriviaApiService.fetchQuestions(widget.categoryId);
      _currentIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _answered = false;
      _answeredQuestions.clear();
    });
  }

  void _selectAnswer(QuestionModel question, String answer, int total) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = answer;
      _answered = true;
      if (answer == question.correctAnswer) _score++;

      _answeredQuestions.add(AnsweredQuestion(
        question: question.question,
        selectedAnswer: answer,
        correctAnswer: question.correctAnswer,
      ));
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      if (_currentIndex + 1 < total) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _answered = false;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              score: _score,
              total: total,
              categoryName: widget.categoryName,
              answeredQuestions: _answeredQuestions,
            ),
          ),
        );
      }
    });
  }

  Color _answerBackground(String option, String correctAnswer) {
    if (!_answered) return AppColors.surface;
    if (option == correctAnswer) return AppColors.correct.withOpacity(0.12);
    if (option == _selectedAnswer) return AppColors.wrong.withOpacity(0.12);
    return AppColors.surface;
  }

  Color _answerBorder(String option, String correctAnswer) {
    if (!_answered) return Colors.black.withOpacity(0.06);
    if (option == correctAnswer) return AppColors.correct;
    if (option == _selectedAnswer) return AppColors.wrong;
    return Colors.black.withOpacity(0.06);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          widget.categoryName.contains(':')
              ? widget.categoryName.split(':').last.trim()
              : widget.categoryName,
          style: const TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<QuestionModel>>(
        future: _futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 56, color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final questions = snapshot.data ?? [];

          if (questions.isEmpty) {
            return const Center(
              child: Text(
                'No questions available for this category.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final question = questions[_currentIndex];
          final total = questions.length;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / total,
                    minHeight: 8,
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Question ${_currentIndex + 1} of $total  •  ${question.difficulty}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: ListView.separated(
                    itemCount: question.allAnswers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final option = question.allAnswers[i];

                      return GestureDetector(
                        onTap: () =>
                            _selectAnswer(question, option, total),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 18),
                          decoration: BoxDecoration(
                            color:
                                _answerBackground(option, question.correctAnswer),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  _answerBorder(option, question.correctAnswer),
                              width: 1.6,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (_answered && option == question.correctAnswer)
                                const Icon(Icons.check_circle_rounded,
                                    color: AppColors.correct),
                              if (_answered &&
                                  option == _selectedAnswer &&
                                  option != question.correctAnswer)
                                const Icon(Icons.cancel_rounded,
                                    color: AppColors.wrong),
                            ],
                          ),
                        ),
                      );
                    },
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