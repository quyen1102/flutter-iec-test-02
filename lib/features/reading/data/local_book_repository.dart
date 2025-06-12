import 'book_repository.dart';
import '../../../core/models/book_model.dart';
import '../../../core/constants/app_content.dart';

/// Local implementation of BookRepository that returns hardcoded book data
class LocalBookRepository implements BookRepository {
  @override
  Future<Book> getBook() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return AppContent.demoBook;
  }
}
