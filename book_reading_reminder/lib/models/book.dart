class Book {
  int? id;
  String title;
  String author;
  String coverImage;
  String reminderDateTime;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.reminderDateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverImage': coverImage,
      'reminderDateTime': reminderDateTime,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      coverImage: map['coverImage'],
      reminderDateTime: map['reminderDateTime'],
    );
  }
}
