import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/book_reader_cubit.dart';
import '../../cubit/book_reader_state.dart';
import '../widgets/coin_balance_widget.dart';
import '../widgets/chapter_list_widget.dart';
import '../widgets/flying_coin_manager.dart';
import '../widgets/scrolling_view.dart';
import '../widgets/sliding_view.dart';
import '../widgets/debug_controls.dart';
import '../widgets/flying_coins_animation.dart';

class ReadingScreen extends StatefulWidget {
  final BookReaderCubit cubit;
  final int initialChapterIndex;

  const ReadingScreen({
    super.key,
    required this.cubit,
    required this.initialChapterIndex,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final GlobalKey _coinBalanceKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.cubit.selectChapter(widget.initialChapterIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: FlyingCoinsManager(
          child: SafeArea(
            child: BlocBuilder<BookReaderCubit, BookReaderState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return _buildLoadingScreen();
                }

                if (state.hasError) {
                  return _buildErrorScreen(
                    state.errorMessage ?? 'Unknown error',
                  );
                }

                if (!state.hasBookLoaded || state.book == null) {
                  return _buildNoContentScreen();
                }

                return _buildMainContent(context, state);
              },
            ),
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
            'Loading book...',
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
            'Error loading book',
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
            onPressed: () {
              context.read<BookReaderCubit>().loadBook();
            },
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
            'No book content available',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, BookReaderState state) {
    return Column(
      children: [
        _buildAppBar(context, state),
        if (state.readingMode == ReadingMode.sliding)
          _buildChapterList(context, state),

        Expanded(child: _buildReadingContent(context, state)),
        // Add debug controls at the bottom (only in debug mode)
        if (state.isDebugMode) const DebugControls(),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, BookReaderState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button and Book Title
          Flexible(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    state.book?.title ?? 'Unknown Book',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Coin Balance and Mode Toggle
          Row(
            children: [
              CoinBalanceWidget(
                coinBalance: state.coinBalance,
                globalKey: _coinBalanceKey,
              ),
              const SizedBox(width: 12),
              _buildModeToggle(context, state),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle(BuildContext context, BookReaderState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ToggleButtons(
        isSelected: [
          state.readingMode == ReadingMode.scrolling,
          state.readingMode == ReadingMode.sliding,
        ],
        onPressed: (index) {
          context.read<BookReaderCubit>().toggleReadingMode();
        },
        borderRadius: BorderRadius.circular(20),
        selectedColor: Colors.black,
        color: Colors.white,
        fillColor: Colors.indigoAccent,
        splashColor: Colors.indigo.withValues(alpha: 0.2),
        borderWidth: 0,
        selectedBorderColor: Colors.transparent,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.menu, size: 20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.book, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList(BuildContext context, BookReaderState state) {
    return ChapterListWidget(
      book: state.book!,
      currentChapterIndex: state.currentChapterIndex,
      coinBalance: state.coinBalance,
      onChapterSelected: (index) {
        context.read<BookReaderCubit>().selectChapter(index);
      },
      onChapterUnlock: (index, unlockButtonKey) {
        _handleChapterUnlock(context, index, unlockButtonKey);
      },
    );
  }

  Widget _buildReadingContent(BuildContext context, BookReaderState state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child:
          state.readingMode == ReadingMode.scrolling
              ? ScrollingView(
                key: const ValueKey('scrolling'),
                book: state.book!,
                coinBalance: state.coinBalance,
                onChapterUnlock: (index, unlockButtonKey) {
                  _handleChapterUnlock(context, index, unlockButtonKey);
                },
              )
              : SlidingView(cubit: context.read<BookReaderCubit>()),
    );
  }

  /// Handles chapter unlock with flying coins animation
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
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Chapter ${chapterIndex + 1} unlocked!"),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
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
      }
    }
  }
}
