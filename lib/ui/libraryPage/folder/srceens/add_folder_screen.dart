import 'package:flutter/material.dart';
import 'package:orange_card/resources/viewmodels/FolderViewModel.dart';

class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({super.key, required this.folderViewModel});
  final FolderViewModel folderViewModel;
  @override
  State<AddFolderScreen> createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  final TextEditingController _folderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Folder'),
      content: TextField(
        controller: _folderNameController,
        decoration: const InputDecoration(
          labelText: 'Folder Name',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            String folderName = _folderNameController.text;
            widget.folderViewModel.addFolder(folderName);
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
