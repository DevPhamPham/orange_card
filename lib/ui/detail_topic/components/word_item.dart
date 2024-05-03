import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/resources/services/TTSService.dart';

class WordItem extends StatefulWidget {
  final Word word;
  final Color backgroundColor;
  const WordItem(
      {super.key, required this.word, required this.backgroundColor});

  @override
  State<WordItem> createState() => _WordItemState();
}

class _WordItemState extends State<WordItem> {
  final TTSService textToSpeechService = TTSService();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Text(
                widget.word.english.toString(),
              )),
              Expanded(
                  child: Text(
                widget.word.vietnamese,
              ))
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  iconSize: 20,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () async {
                    await textToSpeechService.speak(widget.word.english!);
                  },
                  icon: const Icon(Icons.volume_down),
                  iconSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
