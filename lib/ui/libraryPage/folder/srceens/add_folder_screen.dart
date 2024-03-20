import 'package:flutter/material.dart';

class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({super.key});

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
          onPressed: () {
            // Create the new folder
            String folderName = _folderNameController.text;
            // You can add your logic here to create the folder
            print('Folder name: $folderName');
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
