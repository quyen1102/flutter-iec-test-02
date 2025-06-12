import 'package:flutter/material.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/models/chapter_model.dart';

/// Widget that displays book content in scrolling mode
/// Shows all unlocked chapters in a single scrollable view
class ScrollingView extends StatelessWidget {
  final Book book;
  final int coinBalance;
  final Function(int, GlobalKey) onChapterUnlock;

  const ScrollingView({
    super.key,
    required this.book,
    required this.coinBalance,
    required this.onChapterUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            book.chapters.asMap().entries.map((entry) {
              final index = entry.key;
              final chapter = entry.value;

              return _buildChapterSection(chapter, index);
            }).toList(),
      ),
    );
  }

  Widget _buildChapterSection(Chapter chapter, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter title
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            chapter.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // Chapter content or unlock button
        if (chapter.isLocked)
          _buildUnlockSection(chapter, index)
        else
          _buildChapterContent(chapter),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildChapterContent(Chapter chapter) {
    return Text(
      chapter.content,
      style: TextStyle(
        fontSize: 18,
        height: 1.6,
        color: Colors.white.withValues(alpha: 0.85),
      ),
    );
  }

  Widget _buildUnlockSection(Chapter chapter, int index) {
    final unlockButtonKey = GlobalKey();
    final hasEnoughCoins = coinBalance >= chapter.unlockCost;

    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.lock, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'This chapter is locked',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unlock for ${chapter.unlockCost} coins',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            key: unlockButtonKey,
            onPressed:
                hasEnoughCoins
                    ? () => onChapterUnlock(index, unlockButtonKey)
                    : null,
            icon: Icon(hasEnoughCoins ? Icons.lock_open : Icons.lock, size: 20),
            label: Text(
              hasEnoughCoins ? 'Unlock Chapter' : 'Not enough coins',
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: hasEnoughCoins ? Colors.white : Colors.grey,
              backgroundColor:
                  hasEnoughCoins ? Colors.indigo : Colors.grey.shade800,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
