import 'package:flutter/material.dart';

import '../../../../resources/models/topic.dart';


class EditTopicDialog extends StatefulWidget {
  final Topic topic;

  const EditTopicDialog({Key? key, required this.topic}) : super(key: key);

  @override
  State<EditTopicDialog> createState() => _EditTopicDialogState();
}

class _EditTopicDialogState extends State<EditTopicDialog> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the initial value of the topic's title
    _titleController = TextEditingController(text: widget.topic.title);
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit This ',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Topic Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    String title = _titleController.text;
                    if (title.isNotEmpty) {
                      // Create a new Topic object with the updated title
                      Topic updatedTopic = widget.topic.copyWith(title: title);
                      Navigator.pop(context, updatedTopic);
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
