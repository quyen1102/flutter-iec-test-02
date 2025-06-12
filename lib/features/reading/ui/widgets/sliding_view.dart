import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';
import '../../../../core/models/book_model.dart';
import '../../../../core/models/chapter_model.dart';

class SlidingView extends StatefulWidget {
  final Book book;
  final int currentChapterIndex;
  final Function(int) onChapterChanged;

  const SlidingView({
    super.key,
    required this.book,
    required this.currentChapterIndex,
    required this.onChapterChanged,
  });

  @override
  _SlidingViewState createState() => _SlidingViewState();
}

class _SlidingViewState extends State<SlidingView> {
  final GlobalKey<PageFlipWidgetState> _pageFlipController =
      GlobalKey<PageFlipWidgetState>();
  List<String> _pages = [];
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _updateContent();
  }

  @override
  void didUpdateWidget(SlidingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentChapterIndex != widget.currentChapterIndex ||
        oldWidget.book != widget.book) {
      _updateContent();
    }
  }

  void _updateContent() {
    final unlockedChapters = widget.book.unlockedChapters;

    if (unlockedChapters.isNotEmpty) {
      int unlockedIndex = 0;
      for (int i = 0; i < unlockedChapters.length; i++) {
        if (widget.book.chapters.indexOf(unlockedChapters[i]) ==
            widget.currentChapterIndex) {
          unlockedIndex = i;
          break;
        }
      }

      final currentChapter = unlockedChapters[unlockedIndex];
      _pages = _paginateChapter(currentChapter.content);
      _currentPageIndex = 0;
    } else {
      _pages = [];
    }
  }

  /// [content]: The full text of the chapter.
  /// [wordsPerPage]: The target number of words for each page.
  /// Returns a list of strings, where each string is a page.
  List<String> _paginateChapter(String content, {int wordsPerPage = 150}) {
    final words = content.trim().split(RegExp(r'\s+'));

    if (words.isEmpty || words.first.isEmpty) {
      return [];
    }

    final pages = <String>[];
    var currentPageWords = <String>[];

    for (final word in words) {
      currentPageWords.add(word);
      if (currentPageWords.length >= wordsPerPage) {
        pages.add(currentPageWords.join(' '));
        currentPageWords = [];
      }
    }

    if (currentPageWords.isNotEmpty) {
      pages.add(currentPageWords.join(' '));
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final unlockedChapters = widget.book.unlockedChapters;

    if (unlockedChapters.isEmpty) {
      return _buildNoUnlockedChaptersMessage();
    }

    if (_pages.isEmpty) {
      return _buildLoadingMessage();
    }

    return Column(
      children: [
        _buildChapterHeader(unlockedChapters),
        Expanded(child: _buildPageView()),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildNoUnlockedChaptersMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No unlocked chapters available',
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

  Widget _buildChapterHeader(List<Chapter> unlockedChapters) {
    Chapter? currentChapter;
    int chapterNumber = 1;

    for (int i = 0; i < unlockedChapters.length; i++) {
      if (widget.book.chapters.indexOf(unlockedChapters[i]) ==
          widget.currentChapterIndex) {
        currentChapter = unlockedChapters[i];
        chapterNumber = i + 1;
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            currentChapter?.title ?? 'Unknown Chapter',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${chapterNumber} of ${unlockedChapters.length} unlocked chapters',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageFlipWidget(
      key: _pageFlipController,
      backgroundColor: Colors.grey.shade900,
      lastPage: _buildPageContent(_pages.length - 1, isLastPage: true),
      children: [for (int i = 0; i < _pages.length; i++) _buildPageContent(i)],
    );
  }

  Widget _buildPageContent(int index, {bool isLastPage = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade900, Colors.grey.shade800],
        ),
        border: Border.all(
          color: Colors.indigo.withValues(alpha: 0.3),
          width: 2,
        ),
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
                  '${index + 1} / ${_pages.length}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            color: Colors.indigo.withValues(alpha: 0.3),
            margin: const EdgeInsets.only(bottom: 24),
          ),
          // Page content
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                index < _pages.length ? _pages[index] : '',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.8,
                  color: Colors.white.withValues(alpha: 0.9),
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

  Widget _buildPageIndicator() {
    if (_pages.length <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed:
                _currentPageIndex > 0
                    ? () {
                      final prevPage = (_currentPageIndex - 1).clamp(
                        0,
                        _pages.length - 1,
                      );
                      _pageFlipController.currentState?.goToPage(prevPage);
                      setState(() {
                        _currentPageIndex = prevPage;
                      });
                    }
                    : null,
            icon: const Icon(Icons.chevron_left),
            iconSize: 32,
            color: _currentPageIndex > 0 ? Colors.white : Colors.grey.shade600,
          ),
          Text(
            'Tap or swipe to flip pages',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
          IconButton(
            onPressed:
                _currentPageIndex < _pages.length - 1
                    ? () {
                      final nextPage = (_currentPageIndex + 1).clamp(
                        0,
                        _pages.length - 1,
                      );
                      _pageFlipController.currentState?.goToPage(nextPage);
                      setState(() {
                        _currentPageIndex = nextPage;
                      });
                    }
                    : null,
            icon: const Icon(Icons.chevron_right),
            iconSize: 32,
            color:
                _currentPageIndex < _pages.length - 1
                    ? Colors.white
                    : Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}
