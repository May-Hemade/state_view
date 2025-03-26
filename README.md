# 🧩 View State Widget

**A simple yet powerful Flutter widget for handling loading, content, error, and network error UI states — with just one line of code.**

---

## ✨ Preview

![Loading](https://raw.githubusercontent.com/May-Hemade/state_view/master/screenshots/loading.png)
![Error](https://raw.githubusercontent.com/May-Hemade/state_view/master/screenshots/error.png)  
![Network](https://raw.githubusercontent.com/May-Hemade/state_view/master/screenshots/network.png)
![Content](https://raw.githubusercontent.com/May-Hemade/state_view/master/screenshots/content.png)

---

## 🚀 Features

✅ Show different UI states effortlessly  
✅ Built-in retry support  
✅ Easily customizable widgets  
✅ Fully theme-aware  
✅ Flutter + Dart package ready for production

---

## 🛠 Usage

```dart
StateView(
  state: ViewState.loading, // or content, error, networkError
  content: Text("🎉 Content Loaded!"),
  onRetry: _fetchData, // optional retry callback
);
```

🎯 ViewState Options

```dart
ViewState.loading

ViewState.content

ViewState.error

ViewState.networkError
```

🎨 Customization
You can override the default UI for each state:

```dart
StateView(
  state: ViewState.error,
  content: YourContentWidget(),
  errorWidget: Column(
    children: [
      Text("Something went wrong"),
      ElevatedButton(onPressed: _retry, child: Text("Retry")),
    ],
  ),
)
```

🔁 Auto Retry with Connectivity
You can optionally integrate the `connectivity_plus` package (a popular community-maintained library) to automatically retry when the device reconnects to the internet.

Although `connectivity_plus` is not included in this package by default, you can see how it's used in the example/ folder.

```dart
final _subscription = Connectivity().onConnectivityChanged.listen((results) {
  final hasConnection = results.any((r) => r != ConnectivityResult.none);
  if (currentState == ViewState.networkError && hasConnection) {
    _loadData(); // Auto-retry logic
  }
});

```

Just add it to your pubspec.yaml:

```yaml
dependencies:
  connectivity_plus: ^6.1.3
```

📲 This makes your app more resilient and user-friendly in offline scenarios.

📦 Installation
Add this to your pubspec.yaml:

```yaml
dependencies:
  view_state_widget: ^1.0.0
```

Then run:

```bash
flutter pub get
```
