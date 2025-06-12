import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_flip/page_flip.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/models/chapter_model.dart';
import '../../cubit/book_reader_cubit.dart';
import '../../cubit/book_reader_state.dart';

class SlidingView extends StatefulWidget {
  const SlidingView({super.key, required this.cubit});
  final BookReaderCubit cubit;

  @override
  _SlidingViewState createState() => _SlidingViewState();
}

class _SlidingViewState extends State<SlidingView> {
  GlobalKey<PageFlipWidgetState> _pageFlipController =
      GlobalKey<PageFlipWidgetState>();
  int? _lastChapterIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookReaderCubit, BookReaderState>(
      buildWhen:
          (previous, current) =>
              previous.currentChapterIndex != current.currentChapterIndex ||
              previous.pages != current.pages ||
              previous.currentPageIndex != current.currentPageIndex ||
              previous.fontSize != current.fontSize ||
              previous.lineHeight != current.lineHeight,
      builder: (context, state) {
        final currentChapter = state.currentChapter;

        // Create new controller when chapter changes
        if (_lastChapterIndex != state.currentChapterIndex) {
          _pageFlipController = GlobalKey<PageFlipWidgetState>();
          _lastChapterIndex = state.currentChapterIndex;
          print("Chapter changed - pages: ${state.pages.length}");
        }

        if (currentChapter?.content.isEmpty ?? true) {
          return _buildNoChapterSelectedMessage();
        }

        if (currentChapter?.isLocked ?? true) {
          return _buildLockedChapterMessage();
        }

        if (state.isLoading) {
          return _buildLoadingMessage();
        }

        return Column(
          children: [
            _buildChapterHeader(
              currentChapter?.title ?? 'Unknown Chapter',
              state.currentChapterIndex + 1,
              state.book?.chapters.length ?? 0,
            ),
            Expanded(child: _buildPageView(state)),
            _buildPageIndicator(state),
          ],
        );
      },
    );
  }

  Widget _buildNoChapterSelectedMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No chapter selected',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedChapterMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Chapter is locked',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Text(
            'Switch to scrolling mode to unlock chapters',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildChapterHeader(
    String title,
    int chapterIndex,
    int totalChapters,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPageView(BookReaderState state) {
    if (state.pages.isEmpty) {
      return const Center(
        child: Text(
          'No content available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return PageFlipWidget(
      key: _pageFlipController,
      backgroundColor: Colors.grey.shade900,
      children: List.generate(
        state.pages.length,
        (index) => _buildPageContent(index, state),
      ),
      onPageFlipped: (index) {
        // Use cubit method instead of setState
        print("Page flipped to: $index");
        widget.cubit.goToPage(index);
      },
    );
  }

  Widget _buildPageContent(
    int index,
    BookReaderState state, {
    bool isLastPage = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade900, Colors.grey.shade800],
        ),
        border: Border.all(color: Colors.indigo.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Page header
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Page ${index + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${index + 1} / ${state.pages.length}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            color: Colors.indigo.withOpacity(0.3),
            margin: const EdgeInsets.only(bottom: 24),
          ),
          // Page content
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                index < state.pages.length ? state.pages[index] : '',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: state.fontSize,
                  height: state.lineHeight,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          // Last page indicator
          if (isLastPage)
            Container(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_stories,
                    color: Colors.indigo.shade300,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'End of Chapter',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.indigo.shade300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(BookReaderState state) {
    if (state.pages.length <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed:
                state.canGoToPreviousPage
                    ? () {
                      final prevPage = (state.currentPageIndex - 1).clamp(
                        0,
                        state.pages.length - 1,
                      );
                      _pageFlipController.currentState?.goToPage(prevPage);
                      widget.cubit.goToPreviousPage();
                    }
                    : null,
            icon: const Icon(Icons.chevron_left),
            iconSize: 32,
            color:
                state.canGoToPreviousPage ? Colors.white : Colors.grey.shade600,
          ),
          Text(
            'Page ${state.currentPageIndex + 1} of ${state.pages.length}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
          IconButton(
            onPressed:
                state.canGoToNextPage
                    ? () {
                      final nextPage = (state.currentPageIndex + 1).clamp(
                        0,
                        state.pages.length - 1,
                      );
                      _pageFlipController.currentState?.goToPage(nextPage);
                      widget.cubit.goToNextPage();
                    }
                    : null,
            icon: const Icon(Icons.chevron_right),
            iconSize: 32,
            color: state.canGoToNextPage ? Colors.white : Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}
