import 'package:flutter/material.dart';
import 'package:orange_card/resources/models/folder.dart';
import 'package:orange_card/ui/auth/constants.dart';

class ListFolder extends StatefulWidget {
  const ListFolder({super.key});

  @override
  State<ListFolder> createState() => _ListFolderState();
}

enum SortOptions { byTitle, byTime, byChildren }

class _ListFolderState extends State<ListFolder> {
  SortOptions _selectedOption = SortOptions.byTitle;

  List<Folder> folders = [
    Folder(
        icon: Icons.folder,
        title: 'Folder 1',
        time: '10:00 AM',
        numberOfChildren: 5),
    Folder(
        icon: Icons.folder,
        title: 'Folder 2',
        time: '11:00 AM',
        numberOfChildren: 3),
    Folder(
        icon: Icons.folder,
        title: 'Folder 3',
        time: '12:00 PM',
        numberOfChildren: 7),
    Folder(
        icon: Icons.folder,
        title: 'Folder 3',
        time: '12:00 PM',
        numberOfChildren: 7),
    Folder(
        icon: Icons.folder,
        title: 'Folder 3',
        time: '12:00 PM',
        numberOfChildren: 7),
    Folder(
        icon: Icons.folder,
        title: 'Folder 3',
        time: '12:00 PM',
        numberOfChildren: 7),
    // Add more folders as needed
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        folders.addAll([
          Folder(
              icon: Icons.folder,
              title: 'New Folder 1',
              time: '1:00 PM',
              numberOfChildren: 2),
          Folder(
              icon: Icons.folder,
              title: 'New Folder 2',
              time: '2:00 PM',
              numberOfChildren: 4),
        ]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: TextField(
            autofocus:
                true, // Set to true if you want the search bar to have focus initially
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
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(folders[index].icon,
                          size: 64.0, color: kPrimaryColor),
                      const SizedBox(height: 16.0),
                      Text(
                        folders[index].title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Time: ${folders[index].time}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Children: ${folders[index].numberOfChildren.toString()}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _sortFolders() {
    switch (_selectedOption) {
      case SortOptions.byTitle:
        folders.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOptions.byTime:
        folders.sort((a, b) => a.time.compareTo(b.time));
        break;
      case SortOptions.byChildren:
        folders
            .sort((a, b) => a.numberOfChildren.compareTo(b.numberOfChildren));
        break;
    }
  }
}
