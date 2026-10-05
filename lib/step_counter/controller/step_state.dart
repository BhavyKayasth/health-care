class StepState {
  //==========================================================
  // CURRENT STEPS
  //==========================================================

  final int steps;

  //==========================================================
  // DAILY STEP GOAL
  //==========================================================

  final int goal;

  //==========================================================
  // DISTANCE IN KM
  //==========================================================

  final double distanceKm;

  //==========================================================
  // ACTIVE MINUTES
  //==========================================================

  final int activeMinutes;

  //==========================================================
  // ESTIMATED CALORIES
  //==========================================================

  final double calories;

  //==========================================================
  // STEP COUNTER AVAILABLE
  //==========================================================

  final bool isAvailable;

  //==========================================================
  // LOADING
  //==========================================================

  final bool isLoading;

  //==========================================================
  // DAILY STEP HISTORY
  //==========================================================

  final Map<String, int> dailySteps;

  //==========================================================
  // CONSTRUCTOR
  //==========================================================

  const StepState({
    required this.steps,
    required this.goal,
    required this.distanceKm,
    required this.activeMinutes,
    required this.calories,
    required this.isAvailable,
    required this.isLoading,
    required this.dailySteps,
  });

  //==========================================================
  // INITIAL STATE
  //==========================================================

  factory StepState.initial() {
    return const StepState(
      steps: 0,
      goal: 10000,
      distanceKm: 0.0,
      activeMinutes: 0,
      calories: 0.0,
      isAvailable: false,
      isLoading: true,
      dailySteps: {},
    );
  }

  //==========================================================
  // COPY WITH
  //==========================================================

  StepState copyWith({
    int? steps,
    int? goal,
    double? distanceKm,
    int? activeMinutes,
    double? calories,
    bool? isAvailable,
    bool? isLoading,
    Map<String, int>? dailySteps,
  }) {
    return StepState(
      steps: steps ?? this.steps,
      goal: goal ?? this.goal,
      distanceKm: distanceKm ?? this.distanceKm,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      calories: calories ?? this.calories,
      isAvailable: isAvailable ?? this.isAvailable,
      isLoading: isLoading ?? this.isLoading,
      dailySteps: dailySteps ?? this.dailySteps,
    );
  }

  //==========================================================
  // PROGRESS
  //==========================================================

  double get progress {
    if (goal <= 0) {
      return 0.0;
    }

    final double value = steps / goal;

    return value.clamp(0.0, 1.0);
  }

  //==========================================================
  // REMAINING STEPS
  //==========================================================

  int get remainingSteps {
    final int remaining = goal - steps;

    return remaining > 0 ? remaining : 0;
  }

  //==========================================================
  // PERCENTAGE
  //==========================================================

  int get percentage {
    return (progress * 100).round();
  }

  //==========================================================
  // GOAL COMPLETED
  //==========================================================

  bool get goalCompleted {
    return steps >= goal;
  }
}
