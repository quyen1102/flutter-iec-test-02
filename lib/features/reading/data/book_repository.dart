import '../../../core/models/book_model.dart';

/// Abstract repository for book data
abstract class BookRepository {
  /// Retrieves the book data
  Future<Book> getBook();
}
