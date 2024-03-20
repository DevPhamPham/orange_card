import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/ui/auth/constants.dart';

class AddWordItem extends StatefulWidget {
  final VoidCallback onDelete;
  final Word word;
  final Function(Word) onUpdateWord; // Callback function to update the word

  const AddWordItem({
    Key? key,
    required this.word,
    required this.onDelete,
    required this.onUpdateWord,
  }) : super(key: key);

  @override
  State<AddWordItem> createState() => _AddWordItemState();
}

class _AddWordItemState extends State<AddWordItem> {
  final _formKey = GlobalKey<FormState>();
  late String _english;
  late String _vietnamese;

  @override
  void initState() {
    super.initState();
    _english = widget.word.english;
    _vietnamese = widget.word.vietnamese;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.grey, width: 1), // Add border
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _english,
                decoration: const InputDecoration(
                  labelText: 'English',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter English word';
                  }
                  return null;
                },
                onSaved: (value) {
                  _english = value!;
                },
                onChanged: (value) {
                  widget.onUpdateWord(widget.word.copyWith(english: value));
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _vietnamese,
                decoration: const InputDecoration(
                  labelText: 'Vietnamese',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Vietnamese word';
                  }
                  return null;
                },
                onSaved: (value) {
                  _vietnamese = value!;
                },
                onChanged: (value) {
                  // Update the word whenever Vietnamese text changes
                  widget.onUpdateWord(widget.word.copyWith(vietnamese: value));
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  widget.onDelete();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDangerColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
