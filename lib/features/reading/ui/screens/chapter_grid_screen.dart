import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/book_reader_cubit.dart';
import '../../cubit/book_reader_state.dart';
import '../../data/local_book_repository.dart';
import '../widgets/coin_balance_widget.dart';
import '../widgets/flying_coin_manager.dart';
import '../widgets/debug_controls.dart';
import 'reading_screen.dart';
import '../../../../core/models/chapter_model.dart';

/// Initial screen showing chapters in a grid layout
///

class ChapterGridScreen extends StatefulWidget {
  const ChapterGridScreen({super.key});

  @override
  State<ChapterGridScreen> createState() => _ChapterGridScreenState();
}

class _ChapterGridScreenState extends State<ChapterGridScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              BookReaderCubit(context.read<LocalBookRepository>())..loadBook(),
      child: const ChapterGridScreenContent(),
    );
  }
}

class ChapterGridScreenContent extends StatefulWidget {
  const ChapterGridScreenContent({super.key});

  @override
  State<ChapterGridScreenContent> createState() =>
      _ChapterGridScreenContentState();
}

class _ChapterGridScreenContentState extends State<ChapterGridScreenContent> {
  final GlobalKey _coinBalanceKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: FlyingCoinsManager(
        child: SafeArea(
          child: BlocBuilder<BookReaderCubit, BookReaderState>(
            builder: (context, state) {
              if (state.isLoading) {
                return _buildLoadingScreen();
              }

              if (state.hasError) {
                return _buildErrorScreen(state.errorMessage ?? 'Unknown error');
              }

              if (!state.hasBookLoaded || state.book == null) {
                return _buildNoContentScreen();
              }

              return _buildMainContent(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.indigo),
          SizedBox(height: 16),
          Text(
            'Loading chapters...',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error loading chapters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<BookReaderCubit>().loadBook(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoContentScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No chapters available',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, BookReaderState state) {
    return Column(
      children: [
        _buildHeader(context, state),
        Expanded(child: _buildChapterGrid(context, state)),
        // Add debug controls at the bottom (only in debug mode)
        if (state.isDebugMode) const DebugControls(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, BookReaderState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade800, Colors.indigo.shade600],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Book title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.book?.title ?? 'Unknown Book',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${state.book?.unlockedChaptersCount ?? 0} of ${state.book?.chapters.length ?? 0} chapters unlocked',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // Coin balance
              CoinBalanceWidget(
                coinBalance: state.coinBalance,
                globalKey: _coinBalanceKey,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tap unlocked chapters to start reading. Use coins to unlock new chapters.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () => context.read<BookReaderCubit>().toggleDebugMode(),
            child: const Text('Toggle Debug Mode'),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterGrid(BuildContext context, BookReaderState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: state.book!.chapters.length,
        itemBuilder: (context, index) {
          final chapter = state.book!.chapters[index];
          return _buildChapterCard(context, chapter, index, state);
        },
      ),
    );
  }

  Widget _buildChapterCard(
    BuildContext context,
    Chapter chapter,
    int index,
    BookReaderState state,
  ) {
    final isUnlocked = !chapter.isLocked;
    final unlockButtonKey = GlobalKey();

    return GestureDetector(
      onTap:
          isUnlocked
              ? () => _navigateToReading(context, index)
              : () => _handleChapterUnlock(context, index, unlockButtonKey),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isUnlocked
                    ? [Colors.indigo.shade700, Colors.indigo.shade500]
                    : [Colors.grey.shade800, Colors.grey.shade700],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? Colors.indigo.shade300 : Colors.grey.shade600,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Chapter icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      isUnlocked
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  isUnlocked ? Icons.menu_book : Icons.lock,
                  size: 30,
                  color: isUnlocked ? Colors.white : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 12),
              // Chapter title
              Text(
                _getChapterShortTitle(chapter.title),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? Colors.white : Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Chapter status
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'UNLOCKED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade300,
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    Container(
                      key: unlockButtonKey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 12,
                            color: Colors.orange.shade300,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${chapter.unlockCost}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'TAP TO UNLOCK',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getChapterShortTitle(String fullTitle) {
    final parts = fullTitle.split(':');
    return parts.isNotEmpty ? parts[0].trim() : fullTitle;
  }

  void _navigateToReading(BuildContext context, int chapterIndex) {
    // Get the cubit and navigate to reading screen
    final cubit = context.read<BookReaderCubit>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) =>
                ReadingScreen(cubit: cubit, initialChapterIndex: chapterIndex),
      ),
    );
  }

  void _handleChapterUnlock(
    BuildContext context,
    int chapterIndex,
    GlobalKey unlockButtonKey,
  ) {
    final cubit = context.read<BookReaderCubit>();
    final flyingCoinsManager = FlyingCoinsManager.of(context);

    if (flyingCoinsManager != null) {
      // Start the flying coins animation
      flyingCoinsManager.startFlyingCoinsAnimation(
        startKey: _coinBalanceKey,
        endKey: unlockButtonKey,
        onComplete: () {
          // After animation completes, try to unlock the chapter
          final success = cubit.unlockChapter(chapterIndex);

          if (!success) {
            // Show error message if unlock failed
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Not enough coins to unlock this chapter!"),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            // Show success message and auto-navigate
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Chapter ${chapterIndex + 1} unlocked!"),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 1),
              ),
            );

            // Auto navigate to the newly unlocked chapter after a short delay
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (mounted) {
                _navigateToReading(context, chapterIndex);
              }
            });
          }
        },
        coinCount: 5,
      );
    } else {
      // Fallback if animation manager is not available
      final success = cubit.unlockChapter(chapterIndex);

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Not enough coins to unlock this chapter!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        _navigateToReading(context, chapterIndex);
      }
    }
  }
}
