// lib/models/book.dart
class Book {
  final int? id;
  final String title;
  final String author;
  final String description;
  final int year;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.year,
  });

  // Menambahkan method copyWith
  Book copyWith({
    int? id,
    String? title,
    String? author,
    String? description,
    int? year,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'year': year,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      description: map['description'],
      year: map['year'],
    );
  }
}
