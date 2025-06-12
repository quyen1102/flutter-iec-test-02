/// Represents a single chapter in the book
class Chapter {
  final String title;
  final String content;
  final int unlockCost;
  bool isLocked;

  Chapter({
    required this.title,
    required this.content,
    required this.unlockCost,
    this.isLocked = true,
  });

  /// Creates a copy of this chapter with updated properties
  Chapter copyWith({
    String? title,
    String? content,
    int? unlockCost,
    bool? isLocked,
  }) {
    return Chapter(
      title: title ?? this.title,
      content: content ?? this.content,
      unlockCost: unlockCost ?? this.unlockCost,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  @override
  String toString() {
    return 'Chapter(title: $title, unlockCost: $unlockCost, isLocked: $isLocked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Chapter &&
        other.title == title &&
        other.content == content &&
        other.unlockCost == unlockCost &&
        other.isLocked == isLocked;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        unlockCost.hashCode ^
        isLocked.hashCode;
  }
}
