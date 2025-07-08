import 'package:flutter/material.dart';

import '../main.dart';

class RouteObserverWithStack extends NavigatorObserver {
  final List<Route<dynamic>> routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
    debugPrint('Stack after push: ${routeStack.map((r) => r.settings.name).toList()}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.remove(route);
    debugPrint('Stack after pop: ${routeStack.map((r) => r.settings.name).toList()}');
    super.didPop(route, previousRoute);
  }
}

String? getCurrentRouteName() {
  return routeObserver.routeStack.isNotEmpty
      ? routeObserver.routeStack.last.settings.name
      : null;
}
