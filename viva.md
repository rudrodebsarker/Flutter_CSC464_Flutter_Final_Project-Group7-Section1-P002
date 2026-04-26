# Viva Q&A (Project Context: Kata Golla by 7)

## 1. What is this project about?
This is a Flutter Tic Tac Toe app named **Kata Golla by 7**. It supports local gameplay, a 10-second turn timer, scoreboard tracking, and Cloud Firestore-based match history.

## 2. Which state management approach is used?
The project uses **Provider** with `ChangeNotifier`. `GameProvider` manages gameplay state and `HistoryProvider` manages Firestore history stream data.

## 3. What is `BuildContext` in this project?
`BuildContext` identifies a widget's location in the tree. In this app it is used for `context.read<GameProvider>()`, `context.watch<HistoryProvider>()`, navigation with `Navigator`, and showing UI like `SnackBar` and dialogs.

## 4. Why is `BuildContext` important here?
Without correct context, provider lookup and navigation can fail. For example, setup/game/history screens use context to read providers and move between routes (`/setup`, `/game`, `/history`).

## 5. What is a constructor?
A constructor initializes an object. Example: `const SetupScreen({super.key});` creates the screen widget and forwards the key.

## 6. What is a named constructor used in this project?
`MatchModel.fromFirestore(DocumentSnapshot doc)` is a named constructor used to create a model object from Firestore document data.

## 7. What is `final` in Dart?
`final` means value can be assigned once at runtime. Example: in providers, dependencies like `final FirestoreService _firestoreService;` are assigned once and reused.

## 8. What is `const` in Dart?
`const` creates compile-time constants. Example: `const SetupScreen()` and `const Duration(seconds: 1)` reduce rebuild cost and improve performance for fixed values.

## 9. What is the difference between `final` and `const` (final constant question)?
`final` is single-assignment runtime constant. `const` is compile-time constant and deeply immutable. In short: all `const` are fixed before run, while `final` is fixed after first assignment.

## 10. Why are many widgets marked `const`?
Because their configuration is static. Flutter can skip unnecessary rebuild work, which improves rendering efficiency.

## 11. Why is `GameScreen` a `StatefulWidget`?
It needs lifecycle control for timer start/stop and result popup handling (`initState`, `didChangeDependencies`, `deactivate`, `dispose`).

## 12. Why is `HistoryScreen` a `StatelessWidget`?
It relies on provider updates (`watch`) instead of local mutable widget state, so a stateless widget is enough.

## 13. How does the app start Firebase safely?
In `main()`: `WidgetsFlutterBinding.ensureInitialized()` is called first, then `Firebase.initializeApp(...)`, then `runApp(...)`.

## 14. How is dependency injection done?
`MultiProvider` is used at app root to register `GameProvider` and `HistoryProvider`, making them available to all routes.

## 15. How does turn timer logic work?
`GameProvider` starts a periodic timer with 10 seconds per turn. Each second decreases `turnTimeLeft`. If time expires, the current player loses and opponent wins.

## 16. How is winner detection implemented?
The provider stores all 8 winning index combinations for a 3x3 board and checks them after each move.

## 17. How is invalid move handling done?
`makeMove` returns early if index is out of range, cell is already filled, or game result already exists.

## 18. How are match results saved?
When game ends, `GameScreen` creates a `MatchModel` and calls `HistoryProvider.saveMatch(...)`, which forwards to `FirestoreService.saveMatch(...)`.

## 19. Why is `FieldValue.serverTimestamp()` used?
It ensures consistent, server-side match creation time for reliable ordering and cross-device consistency.

## 20. How is history shown in real time?
`HistoryProvider.init()` subscribes to a Firestore stream (`snapshots()`). New matches automatically appear in `HistoryScreen` without manual refresh.

## 21. How is win rate calculated?
`HistoryProvider` calculates win rate from non-tie matches and returns a rounded percentage string.

## 22. What is the role of `dispose()` in this project?
`dispose()` cleans up timers and stream subscriptions to avoid memory leaks and background work after screen/provider destruction.

## 23. What is the difference between `resetBoard()` and `resetAll()`?
`resetBoard()` starts a new round while keeping scoreboard. `resetAll()` clears board, names, and score counters for a fresh game session.

## 24. What are key packages used?
`provider`, `firebase_core`, `cloud_firestore`, `intl`, `uuid`, and `google_fonts`.

## 25. What architecture pattern is followed?
A simple layered structure: **UI (screens/widgets)** -> **Providers (state/business logic)** -> **Services (Firestore)** -> **Model (`MatchModel`)**.
