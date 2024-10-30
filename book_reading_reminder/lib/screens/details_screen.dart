import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/book.dart';

class DetailsScreen extends StatefulWidget {
  final Book? book;

  DetailsScreen({this.book});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title, author, coverImage;
  DateTime? reminderDate;
  TimeOfDay? reminderTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.book == null ? 'Add Book' : 'Edit Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.book?.title,
                decoration: InputDecoration(labelText: 'Book Title'),
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                initialValue: widget.book?.author,
                decoration: InputDecoration(labelText: 'Author'),
                onSaved: (value) => author = value!,
              ),
              TextFormField(
                initialValue: widget.book?.coverImage,
                decoration: InputDecoration(labelText: 'Cover Image URL'),
                onSaved: (value) => coverImage = value!,
              ),
              SizedBox(height: 16),

              // Reminder Date Picker
              ListTile(
                title: Text(
                  reminderDate == null
                      ? 'Select Reminder Date'
                      : 'Reminder Date: ${reminderDate!.toLocal()}'.split(' ')[0],
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      reminderDate = pickedDate;
                    });
                  }
                },
              ),

              // Reminder Time Picker
              ListTile(
                title: Text(
                  reminderTime == null
                      ? 'Select Reminder Time'
                      : 'Reminder Time: ${reminderTime!.format(context)}',
                ),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      reminderTime = pickedTime;
                    });
                  }
                },
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Set default reminder if no date or time is selected
                    if (reminderDate == null) reminderDate = DateTime.now();
                    if (reminderTime == null) reminderTime = TimeOfDay.now();

                    // Combine date and time for reminderDateTime
                    final combinedDateTime = DateTime(
                      reminderDate!.year,
                      reminderDate!.month,
                      reminderDate!.day,
                      reminderTime!.hour,
                      reminderTime!.minute,
                    );

                    final snackBar = SnackBar(
                      content: Text('Reminder set for $combinedDateTime'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    final newBook = Book(
                      title: title,
                      author: author,
                      coverImage: coverImage,
                      reminderDateTime: combinedDateTime.toString(),
                    );
                    final dbHelper = DatabaseHelper();
                    await dbHelper.insertBook(newBook);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
