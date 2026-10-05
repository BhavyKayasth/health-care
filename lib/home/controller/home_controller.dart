import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  final String activeTab;
  final bool showMenu;
  final bool showHealthScore;
  final bool showHealthTracker;
  final bool showDoctorCallList;
  final bool showSubscriptionPage;
  final bool hasSubscription;

  const HomeState({
    this.activeTab = 'home',
    this.showMenu = false,
    this.showHealthScore = false,
    this.showHealthTracker = false,
    this.showDoctorCallList = false,
    this.showSubscriptionPage = false,
    this.hasSubscription = false,
  });

  HomeState copyWith({
    String? activeTab,
    bool? showMenu,
    bool? showHealthScore,
    bool? showHealthTracker,
    bool? showDoctorCallList,
    bool? showSubscriptionPage,
    bool? hasSubscription,
  }) {
    return HomeState(
      activeTab:
      activeTab ?? this.activeTab,
      showMenu:
      showMenu ?? this.showMenu,
      showHealthScore:
      showHealthScore ??
          this.showHealthScore,
      showHealthTracker:
      showHealthTracker ??
          this.showHealthTracker,
      showDoctorCallList:
      showDoctorCallList ??
          this.showDoctorCallList,
      showSubscriptionPage:
      showSubscriptionPage ??
          this.showSubscriptionPage,
      hasSubscription:
      hasSubscription ??
          this.hasSubscription,
    );
  }
}

// ============================================================
// HOME CONTROLLER
// ============================================================

class HomeController
    extends StateNotifier<HomeState> {
  HomeController()
      : super(const HomeState());

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  void changeTab(String tab) {
    if (tab.trim().isEmpty) {
      return;
    }

    state = state.copyWith(
      activeTab: tab,
      showMenu: false,
    );
  }

  // ==========================================================
  // POPUP MENU
  // ==========================================================

  void toggleMenu() {
    state = state.copyWith(
      showMenu: !state.showMenu,
    );
  }

  void closeMenu() {
    state = state.copyWith(
      showMenu: false,
    );
  }

  // ==========================================================
  // HEALTH SCORE
  // ==========================================================

  void openHealthScore() {
    state = state.copyWith(
      showHealthScore: true,
      showHealthTracker: false,
      showDoctorCallList: false,
      showSubscriptionPage: false,
    );
  }

  void closeHealthScore() {
    state = state.copyWith(
      showHealthScore: false,
    );
  }

  // ==========================================================
  // HEALTH TRACKER
  // ==========================================================

  void openHealthTracker() {
    state = state.copyWith(
      showHealthTracker: true,
      showHealthScore: false,
      showDoctorCallList: false,
      showSubscriptionPage: false,
    );
  }

  void closeHealthTracker() {
    state = state.copyWith(
      showHealthTracker: false,
    );
  }

  // ==========================================================
  // SUBSCRIPTION
  // ==========================================================

  void openSubscription() {
    state = state.copyWith(
      showSubscriptionPage: true,
      showHealthScore: false,
      showHealthTracker: false,
      showDoctorCallList: false,
    );
  }

  void closeSubscription() {
    state = state.copyWith(
      showSubscriptionPage: false,
    );
  }

  // ==========================================================
  // PAYMENT SUCCESS
  // ==========================================================

  void activateSubscription() {
    state = state.copyWith(
      hasSubscription: true,
      showSubscriptionPage: false,
      showDoctorCallList: true,
    );
  }

  // ==========================================================
  // DOCTOR DIRECTORY
  // ==========================================================

  void openDoctorDirectory() {
    state = state.copyWith(
      showDoctorCallList: true,
      showHealthScore: false,
      showHealthTracker: false,
      showSubscriptionPage: false,
    );
  }

  void closeDoctorDirectory() {
    state = state.copyWith(
      showDoctorCallList: false,
    );
  }

  // ==========================================================
  // RESET OPEN PAGES
  // ==========================================================

  void closeAllPages() {
    state = state.copyWith(
      showMenu: false,
      showHealthScore: false,
      showHealthTracker: false,
      showDoctorCallList: false,
      showSubscriptionPage: false,
    );
  }
}

// ============================================================
// PROVIDER
// ============================================================

final homeControllerProvider =
StateNotifierProvider<
    HomeController,
    HomeState>(
      (ref) => HomeController(),
);