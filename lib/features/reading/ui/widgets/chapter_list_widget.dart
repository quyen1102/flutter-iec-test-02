import 'package:flutter/material.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/models/chapter_model.dart';

/// Widget that displays a horizontal list of chapters
class ChapterListWidget extends StatelessWidget {
  final Book book;
  final int currentChapterIndex;
  final int coinBalance;
  final Function(int) onChapterSelected;
  final Function(int, GlobalKey) onChapterUnlock;

  const ChapterListWidget({
    super.key,
    required this.book,
    required this.currentChapterIndex,
    required this.coinBalance,
    required this.onChapterSelected,
    required this.onChapterUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: book.chapters.length,
        itemBuilder: (context, index) {
          final chapter = book.chapters[index];
          final isSelected = index == currentChapterIndex;

          if (chapter.isLocked) {
            return _buildLockedChapter(chapter, index);
          } else {
            return _buildUnlockedChapter(chapter, index, isSelected);
          }
        },
      ),
    );
  }

  Widget _buildLockedChapter(Chapter chapter, int index) {
    final unlockButtonKey = GlobalKey();
    final hasEnoughCoins = coinBalance >= chapter.unlockCost;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Tooltip(
        message: "Unlock for ${chapter.unlockCost} coins",
        child: ElevatedButton.icon(
          key: unlockButtonKey,
          onPressed: () => onChapterUnlock(index, unlockButtonKey),
          icon: const Icon(Icons.lock, size: 16),
          label: Text(_getChapterShortTitle(chapter.title)),
          style: ElevatedButton.styleFrom(
            foregroundColor: hasEnoughCoins ? Colors.white : Colors.grey,
            backgroundColor:
                hasEnoughCoins
                    ? Colors.grey.shade800
                    : Colors.grey.shade800.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnlockedChapter(Chapter chapter, int index, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(_getChapterShortTitle(chapter.title)),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            onChapterSelected(index);
          }
        },
        backgroundColor: Colors.grey.shade800.withOpacity(0.5),
        selectedColor: Colors.indigo,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.indigoAccent : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  /// Extracts the short title (e.g., "Chapter 1" from "Chapter 1: The Azure Gem")
  String _getChapterShortTitle(String fullTitle) {
    final parts = fullTitle.split(':');
    return parts.isNotEmpty ? parts[0].trim() : fullTitle;
  }
}
