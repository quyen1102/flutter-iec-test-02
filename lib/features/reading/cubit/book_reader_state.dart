import '../../../core/models/book_model.dart';

/// Enum to define the two reading modes
enum ReadingMode { scrolling, sliding }

/// Enum to define the state status
enum BookReaderStatus { initial, loading, success, failure }

/// State class for the BookReader cubit
class BookReaderState {
  final Book? book;
  final int coinBalance;
  final ReadingMode readingMode;
  final BookReaderStatus status;
  final String? errorMessage;
  final int currentChapterIndex;
  final bool isDebugMode;

  // Page-related states for sliding mode
  final int currentPageIndex;
  final List<String> pages;
  final double fontSize;
  final double lineHeight;

  const BookReaderState({
    this.book,
    this.coinBalance = 50, // Start with 50 coins as requested
    this.readingMode = ReadingMode.scrolling,
    this.status = BookReaderStatus.initial,
    this.errorMessage,
    this.currentChapterIndex = 0,
    this.isDebugMode = false,
    this.currentPageIndex = 0,
    this.pages = const [],
    this.fontSize = 18.0,
    this.lineHeight = 1.8,
  });

  /// Creates a copy of this state with updated properties
  BookReaderState copyWith({
    Book? book,
    int? coinBalance,
    ReadingMode? readingMode,
    BookReaderStatus? status,
    String? errorMessage,
    int? currentChapterIndex,
    bool? isDebugMode,
    int? currentPageIndex,
    List<String>? pages,
    double? fontSize,
    double? lineHeight,
  }) {
    return BookReaderState(
      book: book ?? this.book,
      coinBalance: coinBalance ?? this.coinBalance,
      readingMode: readingMode ?? this.readingMode,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      isDebugMode: isDebugMode ?? this.isDebugMode,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      pages: pages ?? this.pages,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
    );
  }

  /// Returns true if the state is in loading status
  bool get isLoading => status == BookReaderStatus.loading;

  /// Returns true if the state has a book loaded successfully
  bool get hasBookLoaded => book != null && status == BookReaderStatus.success;

  /// Returns true if the state has an error
  bool get hasError => status == BookReaderStatus.failure;

  /// Returns the current chapter if available
  get currentChapter {
    if (book == null || book!.chapters.isEmpty) return null;
    if (currentChapterIndex >= book!.chapters.length) return null;
    return book!.chapters[currentChapterIndex];
  }

  /// Returns true if there are pages available
  bool get hasPages => pages.isNotEmpty;

  /// Returns true if can go to next page
  bool get canGoToNextPage => currentPageIndex < pages.length - 1;

  /// Returns true if can go to previous page
  bool get canGoToPreviousPage => currentPageIndex > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookReaderState &&
        other.book == book &&
        other.coinBalance == coinBalance &&
        other.readingMode == readingMode &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        other.currentChapterIndex == currentChapterIndex &&
        other.isDebugMode == isDebugMode &&
        other.currentPageIndex == currentPageIndex &&
        other.pages == pages &&
        other.fontSize == fontSize &&
        other.lineHeight == lineHeight;
  }

  @override
  int get hashCode {
    return book.hashCode ^
        coinBalance.hashCode ^
        readingMode.hashCode ^
        status.hashCode ^
        errorMessage.hashCode ^
        currentChapterIndex.hashCode ^
        isDebugMode.hashCode ^
        currentPageIndex.hashCode ^
        pages.hashCode ^
        fontSize.hashCode ^
        lineHeight.hashCode;
  }

  @override
  String toString() {
    return 'BookReaderState(book: ${book?.title}, coinBalance: $coinBalance, readingMode: $readingMode, status: $status, currentChapterIndex: $currentChapterIndex, currentPageIndex: $currentPageIndex, pagesCount: ${pages.length}, isDebugMode: $isDebugMode)';
  }
}
