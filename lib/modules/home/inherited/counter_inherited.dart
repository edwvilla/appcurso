import 'package:flutter/material.dart';

class CounterNotifier with ChangeNotifier {
  int _count = 0;

  int get value => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterInheritedNotifier extends InheritedNotifier<CounterNotifier> {
  const CounterInheritedNotifier({
    super.key,
    required Widget child,
    required CounterNotifier notifier,
  }) : super(child: child, notifier: notifier);

  static CounterInheritedNotifier? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CounterInheritedNotifier>();
  }
}
