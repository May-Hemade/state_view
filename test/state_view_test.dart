import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_view/src/state_view.dart';

void main() {
  testWidgets('StateView displays loading widget correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StateView(
            state: ViewState.loading,
            content: Text("Content Loaded"),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text("Loading... Please wait"), findsOneWidget);
  });

  testWidgets('StateView displays content widget correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StateView(
            state: ViewState.content,
            content: Text('Content Loaded'),
          ),
        ),
      ),
    );

    expect(find.text('Content Loaded'), findsOneWidget);
  });

  testWidgets('StateView displays default error UI with retry button', (
    WidgetTester tester,
  ) async {
    void retry() {}

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StateView(
            state: ViewState.error,
            content: const Text('Content Loaded'),
            onRetry: retry,
          ),
        ),
      ),
    );

    expect(
      find.text("Something went wrong. Please try again."),
      findsOneWidget,
    );
    expect(find.text("Retry"), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('StateView displays custom error widget if provided', (
    WidgetTester tester,
  ) async {
    void retry() {}

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StateView(
            state: ViewState.error,
            content: const Text('Content Loaded'),
            errorWidget: Column(
              children: [
                const Text("Custom error UI"),
                ElevatedButton(onPressed: retry, child: const Text("Retry")),
              ],
            ),
            onRetry: retry,
          ),
        ),
      ),
    );

    expect(find.text("Custom error UI"), findsOneWidget);
    expect(find.text("Retry"), findsOneWidget);
  });

  testWidgets('StateView displays default network error message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StateView(
            state: ViewState.networkError,
            content: Text('Content Loaded'),
          ),
        ),
      ),
    );

    expect(
      find.text("No internet connection. Please check your network."),
      findsOneWidget,
    );
  });

  testWidgets('StateView displays custom network error widget if provided', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StateView(
            state: ViewState.networkError,
            content: Text('Content Loaded'),
            networkErrorWidget: Center(child: Text("Custom network error")),
          ),
        ),
      ),
    );

    expect(find.text("Custom network error"), findsOneWidget);
  });
}
