import 'dart:math';
import 'package:flutter/material.dart';

class WakeUpGame extends StatefulWidget {
  final Function onGameComplete;

  const WakeUpGame({
    super.key,
    required this.onGameComplete,
  });

  @override
  State<WakeUpGame> createState() => _WakeUpGameState();
}

class _WakeUpGameState extends State<WakeUpGame> {
  late int num1;
  late int num2;
  late String operation;
  late int correctAnswer;
  List<int> answers = [];
  bool hasAnswered = false;
  String feedback = '';
  int currentStreak = 0;
  final int requiredStreak = 5;
  List<bool> progressIndicators = List.generate(5, (index) => false);
  
  @override
  void initState() {
    super.initState();
    _generateProblem();
  }

  void _generateProblem() {
    final random = Random();
    num1 = random.nextInt(20) + 1;
    num2 = random.nextInt(20) + 1;
    
    final operations = ['+', '-', '×'];
    operation = operations[random.nextInt(operations.length)];
    
    switch (operation) {
      case '+':
        correctAnswer = num1 + num2;
        break;
      case '-':
        if (num2 > num1) {
          final temp = num1;
          num1 = num2;
          num2 = temp;
        }
        correctAnswer = num1 - num2;
        break;
      case '×':
        num1 = random.nextInt(10) + 1;
        num2 = random.nextInt(10) + 1;
        correctAnswer = num1 * num2;
        break;
      default:
        correctAnswer = num1 + num2;
    }
    
    answers = [correctAnswer];
    while (answers.length < 4) {
      int wrongAnswer = correctAnswer + random.nextInt(10) - 5;
      if (!answers.contains(wrongAnswer) && wrongAnswer >= 0) {
        answers.add(wrongAnswer);
      }
    }
    answers.shuffle();
  }

  void _checkAnswer(int selectedAnswer) {
    if (hasAnswered) return;
    
    setState(() {
      hasAnswered = true;
      if (selectedAnswer == correctAnswer) {
        currentStreak++;
        progressIndicators[currentStreak - 1] = true;
        
        if (currentStreak >= requiredStreak) {
          feedback = 'Congratulations! You\'ve earned your sleep! 😴';
          Future.delayed(const Duration(seconds: 1), () {
            widget.onGameComplete();
          });
        } else {
          feedback = 'Correct! ${requiredStreak - currentStreak} more to go!';
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              hasAnswered = false;
              feedback = '';
              _generateProblem();
            });
          });
        }
      } else {
        feedback = 'Wrong! Your streak has been reset!';
        currentStreak = 0;
        progressIndicators = List.generate(5, (index) => false);
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            hasAnswered = false;
            feedback = '';
            _generateProblem();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;
    return Container(
      height: height * 0.75,
      width: width * 0.75,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Solve 5 in a Row to Stop the Alarm:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  progressIndicators[index] ? Icons.check_circle : Icons.circle_outlined,
                  color: progressIndicators[index] ? Colors.green : Colors.grey,
                  size: 24,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(
            '$num1 $operation $num2 = ?',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: answers.map((answer) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: hasAnswered
                      ? (answer == correctAnswer ? Colors.green : Colors.red)
                      : Theme.of(context).primaryColor,
                ),
                onPressed: () => _checkAnswer(answer),
                child: Text(
                  answer.toString(),
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          if (feedback.isNotEmpty)
            Text(
              feedback,
              style: TextStyle(
                fontSize: 18,
                color: feedback.contains('Wrong') ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}