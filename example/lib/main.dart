import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:state_view/state_view.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ViewState _currentState = ViewState.loading;

  late final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  Future<bool> _isConnected() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.any(
      (result) => result != ConnectivityResult.none,
    );
  }

  Future<void> _loadData() async {
    setState(() {
      _currentState = ViewState.loading;
    });

    if (!await _isConnected()) {
      setState(() {
        _currentState = ViewState.networkError;
      });
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    final options = [
      ViewState.content,
      ViewState.error,
      ViewState.networkError,
    ];
    final randomIndex = Random().nextInt(options.length);

    setState(() {
      _currentState = options[randomIndex];
    });
  }

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (_currentState == ViewState.networkError && hasConnection) {
        _loadData();
      }
    });

    _loadData();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18, color: Colors.deepOrangeAccent),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,

      home: Scaffold(
        appBar: AppBar(title: const Text("State View Example")),
        body: StateView(
          state: _currentState,
          content: const _SuccessContent(),
          loadingWidget: _LoadingContent(),
          errorWidget: ErrorStateWidget(
            icon: Icons.error_outline,
            message: "Uh-oh! Something didn’t work as expected.",
            onRetry: _loadData,
          ),
          networkErrorWidget: ErrorStateWidget(
            icon: Icons.wifi_off_outlined,
            message: "Internet connection lost. Waiting to reconnect...",
            onRetry: _loadData,
          ),
          onRetry: _loadData,
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text("Loading... Please wait."),
        ],
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "✨ Yay! Everything's working smoothly!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            "You’re all set 🎉",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.icon,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 50),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
