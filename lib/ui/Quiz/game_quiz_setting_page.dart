import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/ui/Quiz/quiz.dart';
import 'package:orange_card/widgets/gap.dart';

class GameQuizSettingsPage extends StatefulWidget {
  final TopicViewModel topicViewModel;

  const GameQuizSettingsPage({
    Key? key,
    required this.topicViewModel,
  }) : super(key: key);

  @override
  State<GameQuizSettingsPage> createState() => _GameQuizSettingsPageState();
}

class _GameQuizSettingsPageState extends State<GameQuizSettingsPage> {
  late bool isAuto = false;
  late bool isEnglishQuestions = true;
  late bool isShuffleEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose your style'),backgroundColor: Colors.purpleAccent,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(height: 16),
            SwitchListTile(
              title: Text('Auto Mode'),
              subtitle: Text('Get a response as soon as you answer a word and automatically move on to the next question in 1 second.'),
              value: isAuto,
              onChanged: (value) {
                setState(() {
                  isAuto = value;
                });
              },
            ),
            const Gap(height: 16),
            ListTile(
              title: Text('Question Language'),
              subtitle: Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: isEnglishQuestions,
                    onChanged: (value) {
                      setState(() {
                        isEnglishQuestions = value as bool;
                      });
                    },
                  ),
                  Text('English'),
                  Radio(
                    value: false,
                    groupValue: isEnglishQuestions,
                    onChanged: (value) {
                      setState(() {
                        isEnglishQuestions = value as bool;
                      });
                    },
                  ),
                  Text('Vietnamese'),
                ],
              ),
            ),
            const Gap(height: 16),
            CheckboxListTile(
              title: Text('Shuffle Questions'),
              value: isShuffleEnabled,
              onChanged: (value) {
                setState(() {
                  isShuffleEnabled = value ?? false;
                });
              },
            ),
            const Gap(height: 16),
            ElevatedButton(
              onPressed: () {
                // Lưu các tùy chọn vào biến settings
                var settings = {
                  "autoEnabled": isAuto,
                  "englishQuestions": isEnglishQuestions,
                  "shuffleEnabled": isShuffleEnabled,
                };

                // Chuyển đến GameQuizPage và truyền settings
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameQuizPage(
                      settings: settings,
                      topicViewModel: widget.topicViewModel,
                      words: widget.topicViewModel.words,
                    ),
                  ),
                );
              },
              child: Text('Start Quiz'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
            ),
          ],
        ),
      ),
    );
  }
}
