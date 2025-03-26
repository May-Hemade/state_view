import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:view_state_widget/view_state_widget.dart';

void main() {
  testWidgets('ViewStateWidget displays loading widget correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ViewStateWidget(
            state: ViewState.loading,
            content: Text("Content Loaded"),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text("Loading... Please wait."), findsOneWidget);
  });

  testWidgets('ViewStateWidget displays content widget correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ViewStateWidget(
            state: ViewState.content,
            content: Text('Content Loaded'),
          ),
        ),
      ),
    );

    expect(find.text('Content Loaded'), findsOneWidget);
  });

  testWidgets('ViewStateWidget displays default error UI with retry button', (
    WidgetTester tester,
  ) async {
    bool retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ViewStateWidget(
            state: ViewState.error,
            content: const Text('Content Loaded'),
            onRetry: () {
              retried = true;
            },
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

    await tester.tap(find.text("Retry"));
    await tester.pump();

    expect(retried, isTrue);
  });

  testWidgets('ViewStateWidget displays custom error widget if provided', (
    WidgetTester tester,
  ) async {
    void retry() {}

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ViewStateWidget(
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

  testWidgets('ViewStateWidget displays default network error message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ViewStateWidget(
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

  testWidgets(
    'ViewStateWidget displays custom network error widget if provided',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ViewStateWidget(
              state: ViewState.networkError,
              content: Text('Content Loaded'),
              networkErrorWidget: Center(child: Text("Custom network error")),
            ),
          ),
        ),
      );

      expect(find.text("Custom network error"), findsOneWidget);
    },
  );
}
