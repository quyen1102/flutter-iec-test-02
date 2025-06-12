import 'chapter_model.dart';

/// Represents the book containing multiple chapters
class Book {
  final String title;
  final List<Chapter> chapters;

  Book({required this.title, required this.chapters});

  /// Creates a copy of this book with updated properties
  Book copyWith({String? title, List<Chapter>? chapters}) {
    return Book(
      title: title ?? this.title,
      chapters: chapters ?? this.chapters,
    );
  }

  /// Returns the number of unlocked chapters
  int get unlockedChaptersCount {
    return chapters.where((chapter) => !chapter.isLocked).length;
  }

  /// Returns only the unlocked chapters
  List<Chapter> get unlockedChapters {
    return chapters.where((chapter) => !chapter.isLocked).toList();
  }

  @override
  String toString() {
    return 'Book(title: $title, chapters: ${chapters.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book &&
        other.title == title &&
        _listEquals(other.chapters, chapters);
  }

  @override
  int get hashCode {
    return title.hashCode ^ chapters.hashCode;
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
