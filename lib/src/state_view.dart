import 'package:flutter/material.dart';

enum ViewState { loading, content, error, networkError }

/// A utility widget to handle UI for loading, content, error, and networkError states.
///
/// [state] determines which widget to display.
/// [content] is shown when state is [ViewState.content].
/// [loadingWidget], [errorWidget], and [networkErrorWidget] are optional overrides.
/// If not provided, default widgets are shown with built-in theming.
/// [onRetry] provides a callback for Retry buttons in error states.
class StateView extends StatelessWidget {
  final ViewState state;
  final Widget content;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? networkErrorWidget;
  final VoidCallback? onRetry;

  const StateView({
    super.key,
    required this.state,
    required this.content,
    this.loadingWidget,
    this.errorWidget,
    this.networkErrorWidget,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ViewState.loading:
        return loadingWidget ?? _DefaultLoading();

      case ViewState.error:
        return errorWidget ??
            _DefaultError(
              icon: Icons.error_outline_outlined,
              message: "Something went wrong. Please try again.",
              onRetry: onRetry,
            );

      case ViewState.networkError:
        return networkErrorWidget ??
            _DefaultError(
              icon: Icons.wifi_off_rounded,
              message: "No internet connection. Please check your network.",
              onRetry: onRetry,
            );

      case ViewState.content:
        return content;
    }
  }
}

class _DefaultLoading extends StatelessWidget {
  const _DefaultLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
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

class _DefaultError extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  const _DefaultError({
    required this.icon,
    required this.message,
    this.onRetry,
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
          if (onRetry != null)
            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
