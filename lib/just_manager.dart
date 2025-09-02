import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// JM is a custom ChangeNotifier wrapper that allows
/// getting, setting, and manually notifying listeners of a value.
class JM<T> extends ChangeNotifier {
  /// Creates a JM instance with an initial value.
  JM(this._value);

  T _value;

  /// Returns the current value.
  T call() => _value;

  /// Sets a new value without notifying listeners.
  void callSet(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
  }

  /// Sets a new value and notifies all listeners.
  void set(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  /// Manually notifies listeners without changing the value.
  void up() {
    notifyListeners();
  }

  /// Notifies listeners for multiple JM instances at once.
  static void multiUp(List<JM> list) {
    for (var jm in list) {
      jm.notifyListeners();
    }
  }

  /// Returns a string representation of the object for debugging.
  @override
  String toString() => '${describeIdentity(this)}($_value)';
}

/// A widget that listens to multiple JM instances and rebuilds
/// its child when any of them changes.
class JMListener extends StatelessWidget {
  /// The list of JM objects to listen to.
  final List<JM> listenables;

  /// Builder function that returns the child widget.
  final Widget Function() childBuilder;

  const JMListener({
    super.key,
    required this.listenables,
    required this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      /// Merges multiple listenables into a single animation.
      animation: Listenable.merge(listenables),
      builder: (context, _) => childBuilder(),
    );
  }
}

/// A widget that listens to a single JM instance and rebuilds
/// its child when the JM changes.
class JMListenerSingle extends StatelessWidget {
  /// The JM object to listen to.
  final JM listenable;

  /// Builder function that returns the child widget.
  final Widget Function() childBuilder;

  const JMListenerSingle({
    super.key,
    required this.listenable,
    required this.childBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      /// Directly listen to a single JM without merge overhead
      animation: listenable,
      builder: (context, _) => childBuilder(),
    );
  }
}

/// A custom Scaffold that rebuilds its body whenever
/// the specified JM listenables change.
class JMScaffold extends StatefulWidget {
  const JMScaffold({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    required this.listenables,
    required this.body,
  });

  final PreferredSizeWidget? appBar;
  final List<JM<dynamic>> listenables;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;

  /// Builder function that returns the body widget.
  final Widget Function() body;

  @override
  State<JMScaffold> createState() => _JMScaffoldState();
}

class _JMScaffoldState extends State<JMScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: widget.appBar,

      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      persistentFooterButtons: widget.persistentFooterButtons,
      persistentFooterAlignment: widget.persistentFooterAlignment,
      drawer: widget.drawer,
      onDrawerChanged: widget.onDrawerChanged,
      endDrawer: widget.endDrawer,
      onEndDrawerChanged: widget.onEndDrawerChanged,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      primary: widget.primary,
      drawerDragStartBehavior: widget.drawerDragStartBehavior,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      drawerScrimColor: widget.drawerScrimColor,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
      restorationId: widget.restorationId,

      /// Body wrapped in a JMListener to rebuild on JM changes.
      body: JMListener(
        listenables: widget.listenables,
        childBuilder: widget.body,
      ),
    );
  }
}
