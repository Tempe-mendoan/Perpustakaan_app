import 'dart:io'; // Untuk mendukung operasi file pada desktop
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    // Lokasi khusus untuk database
    final customDir = Directory(
        r'C:\Users\hosea\Documents\Programming\book_app - Copy\database_perpustakaan');

    // Pastikan direktori ada
    if (!await customDir.exists()) {
      await customDir.create(recursive: true); // Buat direktori jika belum ada
    }

    // Gabungkan path file database
    final path = join(customDir.path, fileName);

    // Buka atau buat database
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        description TEXT NOT NULL,
        year INTEGER NOT NULL
      )
    ''');
  }

  Future<Book> create(Book book) async {
    final db = await instance.database;
    final id = await db.insert('books', book.toMap());
    return book.copyWith(id: id);
  }

  Future<List<Book>> getAllBooks() async {
    final db = await instance.database;
    final result = await db.query('books');
    return result.map((json) => Book.fromMap(json)).toList();
  }

  Future<int> update(Book book) async {
    final db = await instance.database;
    return db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
