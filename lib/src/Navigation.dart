import 'package:flutter/material.dart';

abstract class Navigation {
  Future<void> pushNamed(String routeName);
  Future<void> pushReplacementNamed(String routeName);
  Future<void> popUntilAndPushNamed(String routeName);
  void pop();
}

class NavigationImplementation extends Navigation {
  final GlobalKey<NavigatorState> navigation;
  NavigationImplementation(this.navigation);

  @override
  void pop([dynamic result]) {
    navigation.currentState.pop(result);
  }

  @override
  Future<void> pushReplacementNamed(String routeName) {
    return navigation.currentState.pushReplacementNamed(routeName);
  }

  @override
  Future<void> pushNamed(String routeName) {
    return navigation.currentState.pushNamed(routeName);
  }

  @override
  Future<void> popUntilAndPushNamed(String routeName) {
    navigation.currentState.popUntil((Route route) => route.isFirst);
    return navigation.currentState.pushNamed(routeName);
  }
}
