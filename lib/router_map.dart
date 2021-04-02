import 'package:bookmark/core/utils/routes_constants.dart';
import 'package:bookmark/ui/routes/home_screen.dart';
import 'package:flutter/material.dart';

class RouterNavigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainHome:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route found for the name $settings.name',
              ),
            ),
          ),
        );
    }
  }
}
