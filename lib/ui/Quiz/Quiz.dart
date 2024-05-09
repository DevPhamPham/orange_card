import 'dart:async';
import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/resources/services/TTSService.dart';
import 'package:swipable_stack/swipable_stack.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class QuizPage extends StatefulWidget {
  final List<QuizQuestion> questions;

  const QuizPage({Key? key, required this.questions}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  int score = 0;
  bool isAnswered = false;
  final TTSService textToSpeechService = TTSService();
  late Timer _timer;

  void _startAutoAdvanceTimer() {
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (currentIndex < widget.questions.length - 1) {
        setState(() {
          currentIndex++;
          isAnswered = false;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void answerQuestion(String answer) {
    setState(() {
      if (!isAnswered) {
        if (answer == widget.questions[currentIndex].correctAnswer) {
          score++;
        }
        isAnswered = true;
      }
    });
  }

  @override
  void initState() {
    _startAutoAdvanceTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Column(
        children: [
          Text(
            question.question,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Column(
            children: question.options.map((option) {
              return ElevatedButton(
                onPressed: () => answerQuestion(option),
                child: Text(option),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Text(
            isAnswered ? 'Correct answer!' : '',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Score: $score / ${currentIndex + 1}',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QuizPage(
      questions: [
        QuizQuestion(
          question: 'What is 2 + 2?',
          options: ['3', '4', '5', '6'],
          correctAnswer: '4',
        ),
        QuizQuestion(
          question: 'What is the capital of France?',
          options: ['London', 'Paris', 'Berlin', 'Rome'],
          correctAnswer: 'Paris',
        ),
        // Add more questions here
      ],
    ),
  ));
}
