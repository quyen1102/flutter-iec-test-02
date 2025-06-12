import 'package:shared_preferences/shared_preferences.dart';

/// Service for handling local storage of game progress
class AppPreferences {
  AppPreferences();

  static const String _coinBalanceKey = 'coin_balance';
  static const String _unlockedChaptersKey = 'unlocked_chapters';
  static const String _currentChapterKey = 'current_chapter';

  static final AppPreferences _instance = AppPreferences();

  static late final SharedPreferences _sharedPreferences;

  static AppPreferences get instance => _instance;

  AppPreferences._();

  static void init(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// Saves the current coin balance
  static Future<void> saveCoinBalance(int balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinBalanceKey, balance);
  }

  /// Loads the saved coin balance, returns default value if not found
  static Future<int> loadCoinBalance({int defaultValue = 50}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinBalanceKey) ?? defaultValue;
  }

  /// Saves the list of unlocked chapter indices
  static Future<void> saveUnlockedChapters(
    List<int> unlockedChapterIndices,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _unlockedChaptersKey,
      unlockedChapterIndices.map((index) => index.toString()).toList(),
    );
  }

  /// Loads the list of unlocked chapter indices
  static Future<List<int>> loadUnlockedChapters() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList =
        prefs.getStringList(_unlockedChaptersKey) ??
        ['0']; // Chapter 0 is unlocked by default
    return stringList.map((indexString) => int.parse(indexString)).toList();
  }

  /// Saves the current selected chapter index
  static Future<void> saveCurrentChapter(int chapterIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentChapterKey, chapterIndex);
  }

  /// Loads the current selected chapter index
  static Future<int> loadCurrentChapter({int defaultValue = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentChapterKey) ?? defaultValue;
  }

  /// Clears all saved game progress (useful for reset functionality)
  static Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_coinBalanceKey);
    await prefs.remove(_unlockedChaptersKey);
    await prefs.remove(_currentChapterKey);
  }

  /// Checks if this is the first time opening the app
  static Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey(_coinBalanceKey);
  }

  /// Saves game progress in a single call (more efficient for multiple updates)
  static Future<void> saveGameProgress({
    required int coinBalance,
    required List<int> unlockedChapters,
    required int currentChapter,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Save all data in parallel for better performance
    await Future.wait([
      prefs.setInt(_coinBalanceKey, coinBalance),
      prefs.setStringList(
        _unlockedChaptersKey,
        unlockedChapters.map((index) => index.toString()).toList(),
      ),
      prefs.setInt(_currentChapterKey, currentChapter),
    ]);
  }

  /// Loads all game progress in a single call
  static Future<GameProgress> loadGameProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final coinBalance = prefs.getInt(_coinBalanceKey) ?? 50;
    final unlockedChaptersString =
        prefs.getStringList(_unlockedChaptersKey) ?? ['0'];
    final unlockedChapters =
        unlockedChaptersString
            .map((indexString) => int.parse(indexString))
            .toList();
    final currentChapter = prefs.getInt(_currentChapterKey) ?? 0;

    return GameProgress(
      coinBalance: coinBalance,
      unlockedChapters: unlockedChapters,
      currentChapter: currentChapter,
    );
  }
}

/// Data class to hold game progress information
class GameProgress {
  final int coinBalance;
  final List<int> unlockedChapters;
  final int currentChapter;

  const GameProgress({
    required this.coinBalance,
    required this.unlockedChapters,
    required this.currentChapter,
  });

  @override
  String toString() {
    return 'GameProgress(coinBalance: $coinBalance, unlockedChapters: $unlockedChapters, currentChapter: $currentChapter)';
  }
}
