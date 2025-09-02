
# just_manager

`just_manager` is a lightweight Flutter state management package built around a flexible and easy-to-use `JM` (Just Manage) wrapper. It simplifies reactive state updates, multi-listenable management, and rebuild control without introducing heavy boilerplate.

---

## Features

- Simple, callable `JM<T>` wrapper for values.
- Easily set, get, and notify listeners.
- Support for multiple listenables with `JMListener` and `multiUp`.
- Optional `JMScaffold` for auto-rebuilding Scaffold body.
- Minimal boilerplate compared to `ChangeNotifier` and `ValueNotifier`.

---

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  just_manager:
    git:
      url: https://github.com/JeaFrid/just-manager.git
```

Then run:

```bash
flutter pub get
```

---

## Quick Start

### 1. Create a JM

```dart
import 'package:just_manager/just_manager.dart';

final counter = JM<int>(0);
```

### 2. Read and Update

```dart
// Get current value
print(counter()); // 0

// Update without notifying listeners
counter.callSet(5);

// Update and notify listeners
counter.set(10);
```

### 3. Listen for Changes

```dart
JMListener(
  listenables: [counter],
  childBuilder: () {
    return Text('Counter: ${counter()}');
  },
);
```

### 4. Rebuild Multiple JM Instances

```dart
final name = JM<String>('Alice');
final age = JM<int>(25);

// Manually notify all
JM.multiUp([counter, name, age]);
```

### 5. Using JMScaffold

`JMScaffold` is a drop-in replacement for `Scaffold` that rebuilds its body whenever the specified JM listenables change.

```dart
JMScaffold(
  listenables: [counter],
  appBar: AppBar(title: Text('JM Example')),
  body: () {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Counter: ${counter()}'),
          ElevatedButton(
            onPressed: () => counter.set(counter() + 1),
            child: Text('Increment'),
          ),
        ],
      ),
    );
  },
);
```

---

## API Overview

### JM<T>

- `JM(T value)` → Initialize JM with a value.
- `T call()` → Returns the current value.
- `void callSet(T newValue)` → Sets value without notifying listeners.
- `void set(T newValue)` → Sets value and notifies listeners.
- `void up()` → Manually notify listeners.
- `static void multiUp(List<JM> list)` → Notify multiple JM instances at once.

### JMListener

- `JMListener(listenables: [...], childBuilder: () => Widget)` → Rebuilds child widget when any JM in `listenables` changes.

### JMScaffold

- Drop-in Scaffold replacement.
- `listenables` → List of JM instances to rebuild body when updated.
- `body` → Builder function that returns the body widget.

---

## Why Use JM?

- Simplifies state management compared to `ChangeNotifier` or `ValueNotifier`.
- Callable API allows cleaner and shorter code.
- Built-in support for multiple listenables.
- Minimalistic and flexible; works with any Flutter widget tree.

---

## License

MIT © 2025 JeaFriday# just-manager
