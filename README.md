# Flutter Book Reader Demo

A Flutter book reading app with chapter unlocking functionality, built using the **Cubit pattern** for state management and implementing a **feature-first folder structure**.

## 🚀 Features

### Core Features
- **Chapter Unlocking System**: Users start with 50 coins and can unlock chapters by spending coins
- **Flying Coins Animation**: Animated coins fly from the balance to unlock buttons when purchasing chapters
- **Two Reading Modes**:
  - **Scrolling Mode**: Displays all unlocked chapters in a vertical scrollable view with unlock buttons for locked chapters
  - **Sliding Mode**: PageView with horizontal swiping, showing only unlocked chapters with page navigation

### Technical Features
- **Cubit State Management**: Clean separation of business logic from UI using the flutter_bloc package
- **Feature-First Architecture**: Organized codebase with clear separation of concerns
- **Responsive UI**: Modern dark theme with smooth animations and transitions
- **Error Handling**: Proper loading states, error messages, and user feedback

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point
├── core/
│   ├── models/
│   │   ├── book_model.dart            # Book data model
│   │   └── chapter_model.dart         # Chapter data model
│   └── constants/
│       └── app_content.dart           # Hardcoded story content
└── features/
    └── reading/
        ├── cubit/
        │   ├── book_reader_cubit.dart # Business logic and state management
        │   └── book_reader_state.dart # State definitions and enums
        ├── data/
        │   ├── book_repository.dart    # Abstract repository interface
        │   └── local_book_repository.dart # Local data implementation
        └── ui/
            ├── screens/
            │   └── reading_screen.dart # Main reading screen
            └── widgets/
                ├── chapter_list_widget.dart    # Horizontal chapter selector
                ├── coin_balance_widget.dart    # Coin balance display
                ├── scrolling_view.dart         # Scrolling mode content
                ├── sliding_view.dart           # Sliding mode content
                └── flying_coins_animation.dart # Coin animation system
```

## 🎮 How to Use

1. **Start Reading**: The app loads with the first chapter unlocked
2. **View Chapters**: Horizontal chapter list shows all chapters with lock/unlock status
3. **Unlock Chapters**: Tap locked chapters to spend coins and unlock them
4. **Watch Animation**: Enjoy the flying coins animation when unlocking
5. **Switch Modes**: Use the toggle button to switch between scrolling and sliding reading modes

## 🛠 Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- IDE (VS Code, Android Studio, etc.)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd flutter_iec_test_02
```

2. **Install dependencies**
```bash
fvm use
fvm flutter pub get
```

3. **Run the app**
```bash
fvm flutter run
```

## 📚 Story Content

The app features "**The Lighthouse of Whispering Souls**" - a fictional 5-chapter story about:
- **Chapter 1**: The Azure Gem (Free)
- **Chapter 2**: The Silent Song (10 coins)
- **Chapter 3**: The Shadow on the Water (15 coins)
- **Chapter 4**: The Keeper's Gambit (20 coins)
- **Chapter 5**: One Light Extinguished, A Thousand Ignited (25 coins)

## 🏗 Architecture Details

### State Management
- **BookReaderCubit**: Manages book loading, chapter unlocking, reading mode switching
- **BookReaderState**: Contains book data, coin balance, current chapter, reading mode, and loading status

### Data Layer
- **Repository Pattern**: Clean abstraction for data access
- **Local Repository**: Provides hardcoded book content with simulated async loading

### UI Components
- **Modular Widgets**: Each UI component is separated into its own widget file
- **Animation System**: Custom flying coins animation with position-based trajectories
- **Responsive Design**: Adapts to different screen sizes and orientations

## 🎨 UI/UX Features

- **Dark Theme**: Elegant dark color scheme optimized for reading
- **Smooth Animations**: 
  - Flying coins animation on chapter unlock
  - Smooth transitions between reading modes
  - Loading states and error handling
- **Intuitive Navigation**: Clear visual indicators for locked/unlocked chapters
- **Accessibility**: Tooltips, proper contrast ratios, and semantic widgets

## 🔧 Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  flutter_bloc: ^8.1.6    # State management with Cubit
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test: sdk: flutter
  flutter_lints: ^5.0.0
```

## 🚀 Performance Considerations

- **Efficient State Updates**: Immutable state objects with copyWith methods
- **Widget Optimization**: Proper use of keys for AnimatedSwitcher
- **Memory Management**: Proper disposal of animation controllers
- **Lazy Loading**: Content is loaded only when needed

## 🧪 Testing

The app is structured to support easy testing:
- **Unit Tests**: Cubit business logic can be tested independently
- **Widget Tests**: Individual widgets can be tested in isolation
- **Integration Tests**: Full user flows can be tested end-to-end

## 📈 Future Enhancements

Potential improvements for the app:
- **Persistence**: Save reading progress and coin balance locally
- **More Animations**: Chapter transition animations, reading progress indicators
- **Customization**: Font size, theme options, reading speed settings
- **Social Features**: Reading achievements, sharing progress
- **Content Management**: Dynamic content loading from API

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests for new features
5. Submit a pull request

## 📄 License

This project is for demonstration purposes. Feel free to use and modify as needed.