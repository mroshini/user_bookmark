import 'package:bookmark/core/utils/routes_constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialSetup();
  }

  initialSetup() async {
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(context, mainHome);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.book_outlined,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
