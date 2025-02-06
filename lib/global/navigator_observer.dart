import 'package:flutter/material.dart';

class AppNavigatorObserver extends NavigatorObserver {
  static BuildContext? currentContext;

  @override
  void didPush(Route route, Route? previousRoute) {
    currentContext = route.navigator?.context;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    currentContext = previousRoute?.navigator?.context;
  }
}
