import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orange_card/resources/models/folder.dart';
import 'package:orange_card/resources/viewmodels/FolderViewModel.dart';
import 'package:orange_card/constants/constants.dart';
import 'package:orange_card/ui/libraryPage/folder/components/folder_carditem.dart';
import 'package:orange_card/ui/libraryPage/folder/srceens/add_folder_screen.dart';
import 'package:orange_card/ui/skelton/folder.dart';

class FolderScreen extends StatefulWidget {
  final FolderViewModel folderViewModel;

  const FolderScreen({Key? key, required this.folderViewModel})
      : super(key: key);

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  void initState() {
    super.initState();
    // setdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await setdata();
        },
        child: Column(
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
                onChanged: (value) {
                  // Implement your search logic here
                },
              ),
            ),
            Expanded(child: _buildFolderList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _navigateToAddFolderScreen(context);
          await setdata();
          setState(() {});
        },
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFolderList() {
    return widget.folderViewModel.isLoading
        ? const FolderSkelton()
        : widget.folderViewModel.folders.isEmpty
            ? const Center(child: Text('Chưa có thư mục nào'))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: widget.folderViewModel.folders.length,
                itemBuilder: (context, index) {
                  final folder = widget.folderViewModel.folders[index];
                  return GestureDetector(
                    onTap: () async {
                      // Handle folder tap
                    },
                    child: FolderCardItem(
                      folder: folder,
                      onDelete: (folder) {
                        _showDeleteConfirmation(folder);
                      },
                      onEdit: (folder) {
                        _navigateToEditFolderScreen(context, folder);
                      },
                    ),
                  );
                },
              );
  }

  Future<void> _navigateToAddFolderScreen(BuildContext context) async {
    await showDialog<List>(
      context: context,
      builder: (_) => AddFolderScreen(
        folderViewModel: widget.folderViewModel,
      ),
    );
  }

  Future<void> _navigateToEditFolderScreen(
      BuildContext context, Folder folder) async {
    // Handle edit folder screen navigation
  }

  void _showDeleteConfirmation(Folder folder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận Xóa"),
          content: const Text("Bạn có chắc muốn xóa thư mục này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                await _deleteFolder(folder);
                Navigator.pop(context);
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFolder(Folder folder) async {
    await widget.folderViewModel.deleteFolder(folder);
    // Show success message
  }

  Future<void> setdata() async {
    await widget.folderViewModel.loadFolders();
  }
}
