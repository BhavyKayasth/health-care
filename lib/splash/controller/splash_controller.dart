import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider
final splashControllerProvider =
StateNotifierProvider<SplashController, double>(
      (ref) => SplashController(),
);

class SplashController extends StateNotifier<double> {
  SplashController() : super(0.0);

  Timer? _timer;

  /// Starts loading progress from 0% to 100%
  void startLoading({
    required VoidCallback onCompleted,
  }) {
    _timer?.cancel();

    state = 0;

    _timer = Timer.periodic(
      const Duration(milliseconds: 30),
          (timer) {
        if (state >= 1.0) {
          timer.cancel();
          onCompleted();
          return;
        }

        state += 0.02;

        if (state > 1.0) {
          state = 1.0;
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

typedef VoidCallback = void Function();