import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/resources/utils/enum.dart';

class BottomSheetContent extends StatefulWidget {
  final List<Word> words;
  final Function(List<Word>) onFilter;

  const BottomSheetContent({
    super.key,
    required this.words,
    required this.onFilter,
  });

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  List<Word> currentWords = [];

  @override
  void initState() {
    currentWords = widget.words;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Call the function to start auto advance timer
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Vuốt tự động'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Call the function to start auto advance timer
            },
            icon: const Icon(Icons.tap_and_play_rounded),
            label: const Text('Ngẫu nhiên'),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Lọc theo'),
            trailing: DropdownButton<String>(
              value: 'ALL', // Default value
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    switch (value) {
                      case 'ALL':
                        currentWords = widget.words;
                        break;
                      case 'MARKED':
                        currentWords = widget.words
                            .where((word) => word.marked == STATUS.MARKED)
                            .toList();
                        break;
                      case 'NOT_MARKED':
                        currentWords = widget.words
                            .where((word) => word.marked == STATUS.NOT_MARKED)
                            .toList();
                        break;
                      default:
                        break;
                    }
                  });
                  widget.onFilter(currentWords);
                  print(currentWords.length);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: 'ALL',
                  child: Text('Tất cả'),
                ),
                DropdownMenuItem(
                  value: 'MARKED',
                  child: Text('Đã đánh dấu'),
                ),
                DropdownMenuItem(
                  value: 'NOT_MARKED',
                  child: Text('Chưa đánh dấu'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}