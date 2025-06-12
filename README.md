# Flutter Book Reader Demo

A Flutter book reading app with chapter unlocking functionality, built using the **Cubit pattern** for state management and implementing a **feature-first folder structure**.

## 🚀 Features

### Core Features
- **Chapter Grid Screen**: Initial screen showing all chapters in a 2x2 grid layout with lock/unlock status
- **Chapter Unlocking System**: Users start with 50 coins and can unlock chapters by spending coins
- **Enhanced Flying Coins Animation**: 
  - **Bezier Curve Paths**: Natural parabolic movement instead of straight lines
  - **Trail Effects**: Fading particles following each coin with stagger animation
  - **Physics-Based Motion**: 3 full rotations, bounce & scale effects with elastic curves
  - **Visual Enhancement**: Gradient colors, multiple shadow layers, glow effects
- **Two Reading Modes**:
  - **Scrolling Mode**: Displays all unlocked chapters in a vertical scrollable view with unlock buttons for locked chapters
  - **Sliding Mode**: 3D page flip effect using PageFlipWidget for realistic book reading experience
- **Persistent Storage**: Game progress saved locally using SharedPreferences

### Technical Features
- **Cubit State Management**: Clean separation of business logic from UI using the flutter_bloc package
- **Feature-First Architecture**: Organized codebase with clear separation of concerns
- **Local Data Persistence**: 
  - Coin balance automatically saved and restored
  - Chapter unlock status preserved across app sessions
  - Current reading position remembered
  - Batch save operations for optimal performance
- **Advanced Animation System**: 
  - Position-based coin trajectories with bezier curves
  - Dynamic coin position updates and smooth transitions
  - Trail management with particle history
- **Responsive UI**: Modern dark theme with smooth animations and transitions
- **Error Handling**: Proper loading states, error messages, and user feedback

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point with SharedPreferences initialization
├── core/
│   ├── models/
│   │   ├── book_model.dart            # Book data model with unlock count helpers
│   │   └── chapter_model.dart         # Chapter data model with copyWith
│   ├── constants/
│   │   └── app_content.dart           # Hardcoded story content
│   └── services/
│       └── storage_service.dart       # SharedPreferences wrapper for game progress
└── features/
    └── reading/
        ├── cubit/
        │   ├── book_reader_cubit.dart # Business logic with persistence integration
        │   └── book_reader_state.dart # State definitions and enums
        ├── data/
        │   ├── book_repository.dart    # Abstract repository interface
        │   └── local_book_repository.dart # Local data implementation
        └── ui/
            ├── screens/
            │   ├── chapter_grid_screen.dart    # Initial chapter selection screen
            │   └── reading_screen.dart         # Main reading screen
            └── widgets/
                ├── chapter_list_widget.dart       # Horizontal chapter selector
                ├── coin_balance_widget.dart       # Coin balance display with GlobalKey
                ├── scrolling_view.dart            # Scrolling mode content
                ├── sliding_view.dart              # 3D page flip mode content
                ├── flying_coins_animation.dart    # Advanced coin animation system
                ├── flying_coin_manager.dart       # Animation coordinator
                └── debug_controls.dart            # Development testing controls
```

## 🎮 How to Use

1. **Chapter Selection**: App starts with Chapter Grid Screen showing all 5 chapters in a 2x2 grid
2. **Initial Setup**: First chapter is unlocked, others require coins to unlock
3. **Unlock Chapters**: 
   - Tap locked chapters to trigger flying coins animation
   - Coins automatically deducted from balance if sufficient
   - Auto-navigate to newly unlocked chapter
4. **Reading Experience**: 
   - **Scrolling Mode**: Vertical scroll through all unlocked content
   - **3D Page Flip Mode**: Realistic book page turning with PageFlipWidget
5. **Progress Persistence**: All progress automatically saved and restored on app restart
6. **Debug Controls**: Testing buttons available in debug mode for adding coins and resetting progress

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
- **BookReaderCubit**: Manages book loading, chapter unlocking, reading mode switching, and persistence
- **BookReaderState**: Contains book data, coin balance, current chapter, reading mode, and loading status
- **Automatic Persistence**: State changes trigger automatic saving to SharedPreferences

### Data Layer
- **Repository Pattern**: Clean abstraction for data access
- **Local Repository**: Provides hardcoded book content with simulated async loading
- **Storage Service**: SharedPreferences wrapper with batch operations and error handling
- **Progress Restoration**: Automatic loading of saved progress on app startup

### UI Components
- **Modular Widgets**: Each UI component is separated into its own widget file
- **Advanced Animation System**: 
  - **Flying Coins Manager**: Coordinates multiple coin animations across the app
  - **Bezier Trajectory Calculation**: Physics-based coin movement with parabolic arcs
  - **Dynamic Position Updates**: Real-time coin position tracking and trail effects
  - **Global Key Management**: Precise animation targeting between UI elements
- **3D Page Flip Integration**: PageFlipWidget for realistic book reading experience
- **Responsive Design**: Adapts to different screen sizes and orientations

## 🎨 UI/UX Features

- **Modern Dark Theme**: Elegant color scheme with gradient backgrounds and indigo accents
- **Advanced Animation System**: 
  - **Enhanced Flying Coins**: Bezier curves, trail effects, spinning rotation, elastic bounce
  - **3D Page Flip Effects**: Realistic book page turning animation using PageFlipWidget  
  - **Stagger Animations**: Sequential coin launches with 0.08s delays for natural flow
  - **Visual Enhancements**: Multiple shadow layers, glow effects, gradient coins
  - **Smooth Transitions**: Between reading modes and chapter navigation
- **Chapter Grid Interface**: 2x2 grid layout with visual lock/unlock indicators
- **Dynamic Coin Position Updates**: Real-time balance updates with smooth transitions
- **Intuitive Navigation**: 
  - Clear visual indicators for locked/unlocked chapters
  - Auto-navigation to newly unlocked chapters
  - Back button navigation between screens
- **Accessibility**: Tooltips, proper contrast ratios, and semantic widgets
- **Debug Interface**: Developer controls for testing coin management and progress reset

## 🔧 Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  flutter_bloc: ^8.1.6           # State management with Cubit pattern
  shared_preferences: ^2.5.3     # Local storage for game progress persistence
  page_flip: ^0.2.5+1            # 3D page flip animation widget
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test: sdk: flutter
  flutter_lints: ^5.0.0
```

## 🚀 Performance Considerations

- **Efficient State Updates**: Immutable state objects with copyWith methods
- **Smart Persistence**: 
  - Batch save operations to minimize SharedPreferences writes
  - Automatic progress restoration without blocking UI
  - Debounced coin balance updates for smooth animation
- **Animation Optimization**: 
  - Trail position management with circular buffer
  - Proper disposal of animation controllers and GlobalKeys
  - Optimized bezier curve calculations for 60fps performance
- **Widget Optimization**: 
  - Proper use of keys for AnimatedSwitcher and PageFlipWidget
  - Efficient rebuilds with BlocBuilder and targeted updates
- **Memory Management**: 
  - Automatic cleanup of animation resources
  - Lazy loading of chapter content
  - Efficient coin position tracking

## 🎬 Animation System Deep Dive

### Flying Coins Animation Architecture
```dart
// Enhanced coin animation with physics-based motion
class CoinAnimation {
  final Offset startPosition, endPosition, midPoint;
  final Animation<double> positionAnimation, rotationAnimation, 
                         scaleAnimation, opacityAnimation;
  final Color color;
  final List<Offset> trailPositions; // Trail effect management
}
```

### Key Animation Features
- **Bezier Curve Trajectories**: Natural parabolic flight paths with randomized control points
- **Stagger System**: 0.08s delays between coin launches for sequential effect
- **Trail Management**: Particle history with fading opacity and scaling effects
- **Global Key Targeting**: Precise position-based animation between UI elements
- **Dynamic Color System**: 6 gradient gold/amber color variations per coin
- **Physics Integration**: 3 full rotations, elastic bounce curves, 1200ms duration

### Coin Position Update Flow
1. **Tap Detection** → Capture source/target GlobalKey positions
2. **Animation Start** → Calculate bezier control points with randomization
3. **Frame Updates** → Update coin positions, manage trail history
4. **State Changes** → Automatic coin balance persistence during animation
5. **Completion** → Cleanup resources, trigger UI updates

## 🧪 Testing

The app is structured to support easy testing:
- **Unit Tests**: Cubit business logic and storage service can be tested independently
- **Widget Tests**: Individual widgets and animation components tested in isolation
- **Integration Tests**: Full user flows including persistence and animations
- **Debug Controls**: Built-in testing interface for coin management and progress reset

## 📈 Future Enhancements

Potential improvements for the app:
- **Enhanced Persistence**: Cloud sync for cross-device progress
- **Advanced Animations**: 
  - Chapter transition effects between grid and reading screens
  - Reading progress indicators with particle effects
  - Interactive coin collection mini-games
- **Customization**: 
  - Font size and family selection
  - Reading speed settings for auto-scroll
  - Theme color variations and light mode
- **Social Features**: 
  - Reading achievements and milestones
  - Progress sharing with friends
  - Chapter rating and review system
- **Content Management**: 
  - Dynamic content loading from API
  - User-generated story uploads
  - Multi-language support
- **Advanced Reading Features**:
  - Bookmark system with notes
  - Text highlighting and annotations
  - Audio narration with synchronized text

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests for new features
5. Submit a pull request

## 📄 License

This project is for demonstration purposes. Feel free to use and modify as needed.