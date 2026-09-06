import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:latifa_almaneea_project2/const/app_color.dart';
import '../models/question_model.dart';
import 'main_navigation.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String categoryName;
  final List<AnsweredQuestion> answeredQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.categoryName,
    required this.answeredQuestions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  int get _wrong => widget.total - widget.score;

  String get _message => 'You got ${widget.score} out of ${widget.total}!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 24,
            maxBlastForce: 22,
            minBlastForce: 8,
            gravity: 0.25,
            colors: const [
              AppColors.primary,
              AppColors.secondary,
              AppColors.accent,
            ],
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Column(
                    children: [
                      Text(
                        _message,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.categoryName.contains(':')
                            ? widget.categoryName.split(':').last.trim()
                            : widget.categoryName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatChip(
                            label: 'Correct',
                            value: '${widget.score}',
                            color: AppColors.correct,
                            icon: Icons.check_circle_rounded,
                          ),
                          _StatChip(
                            label: 'Wrong',
                            value: '$_wrong',
                            color: AppColors.wrong,
                            icon: Icons.cancel_rounded,
                          ),
                          _StatChip(
                            label: 'Total',
                            value: '${widget.total}',
                            color: AppColors.secondary,
                            icon: Icons.quiz_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Center(
                    child: Text(
                      'Review your answers',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: widget.answeredQuestions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final a = widget.answeredQuestions[i];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: (a.isCorrect
                                    ? AppColors.correct
                                    : AppColors.wrong)
                                .withOpacity(0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              a.isCorrect
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              color: a.isCorrect
                                  ? AppColors.correct
                                  : AppColors.wrong,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.question,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    a.isCorrect
                                        ? 'Your answer: ${a.selectedAnswer}'
                                        : 'You: ${a.selectedAnswer}  •  Correct: ${a.correctAnswer}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: a.isCorrect
                                          ? AppColors.textSecondary
                                          : AppColors.wrong,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MainNavigation()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'Choose Another Category',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}