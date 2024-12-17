import 'package:flutter/material.dart';
import '../models/book.dart';
import '../database/database_helper.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;

  const EditBookScreen({super.key, required this.book});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String author;
  late String description;
  late int year;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    title = widget.book.title;
    author = widget.book.author;
    description = widget.book.description;
    year = widget.book.year;
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _formKey.currentState!.save();

      try {
        final book = Book(
          id: widget.book.id,
          title: title,
          author: author,
          description: description,
          year: year,
        );

        await DatabaseHelper.instance.update(book);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update book'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteBook() async {
    setState(() => _isLoading = true);
    try {
      await DatabaseHelper.instance.delete(widget.book.id!);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete book'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Book',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus Buku'),
                      ],
                    ),
                    content: const Text('Konfirmasi penghapusan buku?'),
                    actions: [
                      TextButton(
                        child: Text(
                          'Batal',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _deleteBook,
                        child: const Text('Hapus'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.indigo[800]!, Colors.indigo[50]!],
                stops: const [0.0, 0.3],
              ),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Hero(
                      tag: 'book-${widget.book.id}',
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Perincian Buku',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo[800],
                                ),
                              ),
                              const SizedBox(height: 20),
                              buildTextField(
                                label: 'Judul',
                                icon: Icons.book,
                                initialValue: title,
                                validator: (value) =>
                                    value?.isEmpty == true ? 'Required' : null,
                                onSaved: (value) => title = value!,
                              ),
                              const SizedBox(height: 16),
                              buildTextField(
                                label: 'Penulis',
                                icon: Icons.person,
                                initialValue: author,
                                validator: (value) =>
                                    value?.isEmpty == true ? 'Required' : null,
                                onSaved: (value) => author = value!,
                              ),
                              const SizedBox(height: 16),
                              buildTextField(
                                label: 'Deskripsi',
                                icon: Icons.description,
                                initialValue: description,
                                maxLines: 3,
                                validator: (value) =>
                                    value?.isEmpty == true ? 'Required' : null,
                                onSaved: (value) => description = value!,
                              ),
                              const SizedBox(height: 16),
                              buildTextField(
                                label: 'Tahun',
                                icon: Icons.calendar_today,
                                initialValue: year.toString(),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value?.isEmpty == true) return 'Required';
                                  if (int.tryParse(value!) == null) {
                                    return 'Invalid year';
                                  }
                                  return null;
                                },
                                onSaved: (value) => year = int.parse(value!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _isLoading ? null : _updateBook,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save),
                                  SizedBox(width: 8),
                                  Text(
                                    'Simpan Perubahan',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required IconData icon,
    required String initialValue,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: Icon(icon, color: Colors.indigo[800]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo[800]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(fontSize: 16),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
