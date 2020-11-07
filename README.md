# tasty_toast

[[Video on YouTube]](https://youtu.be/fg1exguly94)

A simple package which shows a toast on the screen. By default bottomCenter, but using `Alignment` you can place it anywhere.
I've created this package because I was looking for something similar, but didn't like how other packages handled my (simple) usecase.

You can easily customize the toast by providing a `TextStyle` for the text or `BoxDecoration` for the background.

! You will need a `context`.

(The toasts will be visible after switching screens as well.)

## Getting Started

#### Import tasty toast:
```dart
import 'package:tasty_toast/tasty_toast.dart';
```

#### Call `showToast` with the context variable:
```dart
showToast(
  context,
  "Some message!",
);
```
This will use the defaults, which is a dark toast, white letters and shows at the `bottomCenter`.

#### Optionally customize the toast:

```dart
showToast(
  context,
  "Fully customized",

  // Optional parameters:
  alignment: Alignment.centerLeft,
  textStyle: customTextStyle,
  background: customBoxDecoration,
  duration: Duration(seconds: 5),
  padding: EdgeInsets.all(25.0),
  offsetAnimationStart: Offset(-0.1, -0.1),  // Defines the starting position of the fly-in animation
);
```

# See in action

#### Android screen recording with a default and custom toast

Clicking like a mad man to show the behaviour when multiple toasts following up each other.
![iOS default](screenshots/tasty_toast_demo.gif)

