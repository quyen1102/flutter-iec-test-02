import 'package:flutter_bloc/flutter_bloc.dart';
import 'book_reader_state.dart';
import '../data/book_repository.dart';
import '../../../core/models/chapter_model.dart';
import '../../../core/services/storage_service.dart';

/// Cubit that manages the state of the book reader
class BookReaderCubit extends Cubit<BookReaderState> {
  final BookRepository _bookRepository;

  BookReaderCubit(this._bookRepository) : super(const BookReaderState());

  /// Loads the book from the repository and restores saved progress
  Future<void> loadBook() async {
    emit(state.copyWith(status: BookReaderStatus.loading));

    try {
      // Load book content
      final book = await _bookRepository.getBook();

      // Load saved progress
      final progress = await AppPreferences.loadGameProgress();

      // Apply saved progress to chapters
      final updatedChapters = List<Chapter>.from(book.chapters);
      for (int i = 0; i < updatedChapters.length; i++) {
        if (progress.unlockedChapters.contains(i)) {
          updatedChapters[i] = updatedChapters[i].copyWith(isLocked: false);
        }
      }

      final updatedBook = book.copyWith(chapters: updatedChapters);

      emit(
        state.copyWith(
          book: updatedBook,
          coinBalance: progress.coinBalance,
          currentChapterIndex: progress.currentChapter,
          status: BookReaderStatus.success,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: BookReaderStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Unlocks a chapter if the user has enough coins
  /// Returns true if the unlock was successful, false otherwise
  bool unlockChapter(int chapterIndex) {
    if (state.book == null || chapterIndex >= state.book!.chapters.length) {
      return false;
    }

    final chapter = state.book!.chapters[chapterIndex];

    // Check if chapter is already unlocked
    if (!chapter.isLocked) {
      return true;
    }

    // Check if user has enough coins
    if (state.coinBalance < chapter.unlockCost) {
      return false;
    }

    // Create a new list of chapters with the unlocked chapter
    final updatedChapters = List<Chapter>.from(state.book!.chapters);
    updatedChapters[chapterIndex] = chapter.copyWith(isLocked: false);

    // Create updated book
    final updatedBook = state.book!.copyWith(chapters: updatedChapters);

    // Update state with new coin balance and unlocked chapter
    final newCoinBalance = state.coinBalance - chapter.unlockCost;
    emit(
      state.copyWith(
        book: updatedBook,
        coinBalance: newCoinBalance,
        currentChapterIndex: chapterIndex, // Navigate to unlocked chapter
      ),
    );

    // Save progress to storage
    _saveCurrentProgress();

    return true;
  }

  /// Toggles between scrolling and sliding reading modes
  void toggleReadingMode() {
    final newMode =
        state.readingMode == ReadingMode.scrolling
            ? ReadingMode.sliding
            : ReadingMode.scrolling;

    emit(state.copyWith(readingMode: newMode));
  }

  /// Changes the current chapter (for navigation)
  void selectChapter(int chapterIndex) {
    if (state.book == null || chapterIndex >= state.book!.chapters.length) {
      return;
    }

    final chapter = state.book!.chapters[chapterIndex];

    // Only allow selecting unlocked chapters
    if (!chapter.isLocked) {
      emit(state.copyWith(currentChapterIndex: chapterIndex));

      // Save current chapter selection
      AppPreferences.saveCurrentChapter(chapterIndex);
    }
  }

  /// Adds coins to the user's balance (for testing or rewards)
  void addCoins(int amount) {
    if (amount > 0) {
      emit(state.copyWith(coinBalance: state.coinBalance + amount));
    }
  }

  /// Gets the paginated content for sliding mode
  List<String> getPaginatedContent(String content) {
    // Simple pagination logic - split by paragraphs
    // In a real app, you would use TextPainter for more accurate pagination
    return content.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
  }

  /// Saves current game progress to local storage
  void _saveCurrentProgress() {
    if (state.book == null) return;

    final unlockedChapters = <int>[];
    for (int i = 0; i < state.book!.chapters.length; i++) {
      if (!state.book!.chapters[i].isLocked) {
        unlockedChapters.add(i);
      }
    }

    // Save progress asynchronously (fire and forget)
    AppPreferences.saveGameProgress(
      coinBalance: state.coinBalance,
      unlockedChapters: unlockedChapters,
      currentChapter: state.currentChapterIndex,
    );
  }

  /// Resets all game progress to initial state
  Future<void> resetProgress() async {
    await AppPreferences.clearAllProgress();
    await loadBook(); // Reload with fresh state
  }

  /// Adds coins and saves progress
  void addCoinsAndSave(int amount) {
    if (amount > 0) {
      emit(state.copyWith(coinBalance: state.coinBalance + amount));
      _saveCurrentProgress();
    }
  }

  void toggleDebugMode() {
    emit(state.copyWith(isDebugMode: !state.isDebugMode));
  }
}
