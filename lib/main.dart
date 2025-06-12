import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iec_test_02/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/reading/cubit/book_reader_cubit.dart';
import 'features/reading/data/local_book_repository.dart';
import 'features/reading/ui/screens/chapter_grid_screen.dart';

// Main function to run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppPreferences.init(await SharedPreferences.getInstance());

  runApp(const BookReaderApp());
}

// --- MAIN WIDGETS ---
// The main application widget
class BookReaderApp extends StatelessWidget {
  const BookReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<LocalBookRepository>(
      create: (context) => LocalBookRepository(),
      child: MaterialApp(
        title: 'Flutter Book Reader Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          brightness: Brightness.dark,
          fontFamily: 'Georgia',
        ),
        home: ChapterGridScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
