import 'package:flutter/material.dart';
import 'package:orange_card/constants/constants.dart';
import 'package:orange_card/resources/models/folder.dart';
import 'package:orange_card/resources/viewmodels/FolderViewModel.dart';

class FolderDialog extends StatefulWidget {
  final List<Folder> folders;
  final String topicId;
  final FolderViewModel folderViewModel;
  const FolderDialog(
      {super.key,
      required this.folders,
      required this.topicId,
      required this.folderViewModel});

  @override
  State<FolderDialog> createState() => _FolderDialogState();
}

class _FolderDialogState extends State<FolderDialog> {
  late List<Folder> filteredFolders;
  late bool isHaveTopic = false;
  @override
  void initState() {
    super.initState();
    filteredFolders = widget.folders;
  }

  void _filterFolders(String query) {
    setState(() {
      filteredFolders = widget.folders.where((folder) {
        return folder.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
        height: screenHeight * 0.5, // Set height to 50% of screen height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: _filterFolders,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredFolders.length,
                itemBuilder: (context, index) {
                  final folder = filteredFolders[index];
                  isHaveTopic = checkInFolder(folder);
                  return Card(
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: 6,
                    shadowColor: kPrimaryColor,
                    child: ListTile(
                      leading: const Icon(Icons.folder,
                          size: 48.0, color: kPrimaryColor),
                      title: Text(
                        folder.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${folder.topicIds.length} chủ đề',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () async {
                          bool newIsHaveTopic;
                          if (isHaveTopic) {
                            widget.folderViewModel.removeTopicIdFromFolder(
                              folder.id!,
                              widget.topicId,
                            );
                            newIsHaveTopic = false;
                          } else {
                            widget.folderViewModel.addTopicIdToFolder(
                              folder.id!,
                              widget.topicId,
                            );
                            newIsHaveTopic = true;
                          }
                          setState(() {
                            isHaveTopic = newIsHaveTopic;
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: isHaveTopic ? Colors.red : Colors.blue),
                            child: isHaveTopic
                                ? const Text(
                                    "Xóa",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const Text(
                                    "Thêm",
                                    style: TextStyle(color: Colors.white),
                                  )),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool checkInFolder(Folder folder) {
    return folder.topicIds.contains(widget.topicId);
  }
}
