import 'package:flutter/material.dart';
import 'package:tasty_toast/tasty_toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasty Toasts Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasty Toasts Demo"),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: () => showToast(
                context,
                "Default toast",
              ),
              child: Text("Show default toast!"),
            ),
            RaisedButton(
              onPressed: () {
                var customTextStyle = TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                );

                var customBackground = BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00AEFF),
                      Color(0xFF0076FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(41.0),
                );

                showToast(
                  context,
                  "Fully customized",

                  // Optional parameters:
                  alignment: Alignment.centerLeft,
                  textStyle: customTextStyle,
                  background: customBackground,
                  duration: Duration(seconds: 5),
                  padding: EdgeInsets.all(25.0),
                  offsetAnimationStart: Offset(-0.1, -0.1),
                );
              },
              child: Text("Show custom toast!"),
            ),
          ],
        ),
      ),
    );
  }
}
