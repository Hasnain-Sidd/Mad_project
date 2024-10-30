import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/book.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper dbHelper;
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    fetchBooks();
  }

  void fetchBooks() async {
    final data = await dbHelper.getBooks();
    setState(() {
      books = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 3,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(book: book),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Image.network(book.coverImage, height: 120, fit: BoxFit.cover),
                  SizedBox(height: 5),
                  Text(book.title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsScreen()),
          ).then((value) => fetchBooks());
        },
      ),
    );
  }
}
