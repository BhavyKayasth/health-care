import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:geolocator/geolocator.dart';

import '../chat/screens/chat_screen.dart';
import '../common/widgets/app_bottom_navigation.dart';
import '../home/screens/home_screen.dart';
import '../location/controller/location_controller.dart';
import '../location/controller/location_state.dart';
import '../nearby/screens/nearby_screen.dart';
import '../profile/screens/profile_screen.dart';
import '../schedule/screens/schedule_screen.dart';
import '../step_counter/controller/step_controller.dart';

final mainTabProvider =
StateProvider<String>((ref) => "home");

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with WidgetsBindingObserver {

  //----------------------------------------------------------
  // PREVENT MULTIPLE LOCATION DIALOGS
  //----------------------------------------------------------

  bool _locationDialogShowing = false;

  //----------------------------------------------------------
  // PREVENT INITIAL CUSTOM LOCATION DIALOG
  //----------------------------------------------------------

  bool _permissionWasAlreadyGranted = false;

  //----------------------------------------------------------
  // PREVENT MULTIPLE APP INITIALIZATIONS
  //----------------------------------------------------------

  bool _appInitialized = false;

  //----------------------------------------------------------
  // TRACK WHEN INITIALIZATION IS ACTUALLY COMPLETE
  //----------------------------------------------------------

  bool _initializationComplete = false;

  //----------------------------------------------------------
  // INITIALIZATION
  //----------------------------------------------------------

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    //--------------------------------------------------------
    // GLOBAL LOCATION LISTENER
    //--------------------------------------------------------

    ref.listenManual<LocationState>(
      locationControllerProvider,
          (previous, next) {
        if (!mounted) {
          return;
        }

        //----------------------------------------------------
        // IGNORE LOADING STATE
        //----------------------------------------------------

        if (next.isLoading) {
          return;
        }

        //----------------------------------------------------
        // LOCATION ON → OFF
        //
        // Permission must still be granted.
        //----------------------------------------------------

        if (previous?.serviceEnabled == true &&
            next.serviceEnabled == false &&
            next.permissionGranted) {
          _showLocationOffDialog();
        }
      },
    );

    //--------------------------------------------------------
    // START APP INITIALIZATION AFTER FIRST FRAME
    //--------------------------------------------------------

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  //----------------------------------------------------------
  // INITIALIZE APP
  //----------------------------------------------------------

  Future<void> _initializeApp() async {
    if (_appInitialized || !mounted) {
      return;
    }

    _appInitialized = true;

    //--------------------------------------------------------
    // LOCATION CONTROLLER
    //--------------------------------------------------------

    final locationController =
    ref.read(locationControllerProvider.notifier);

    //--------------------------------------------------------
    // CHECK LOCATION PERMISSION BEFORE INITIALIZATION
    //--------------------------------------------------------

    try {
      final permission =
      await Geolocator.checkPermission();

      _permissionWasAlreadyGranted =
          permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse;

      //------------------------------------------------------
      // INITIALIZE LOCATION FIRST
      //------------------------------------------------------

      await locationController.initialize();

      if (!mounted) {
        return;
      }

      //------------------------------------------------------
      // INITIALIZE STEP COUNTER AFTER LOCATION FLOW
      //------------------------------------------------------
      //
      // Android only allows one runtime permission request
      // at a time, so location is completed first.
      //------------------------------------------------------

      await ref
          .read(stepControllerProvider.notifier)
          .initialize();

      if (!mounted) {
        return;
      }

      //------------------------------------------------------
      // FINAL LOCATION STATE
      //------------------------------------------------------

      final locationState =
      ref.read(locationControllerProvider);

      //------------------------------------------------------
      // MARK INITIALIZATION AS COMPLETE
      //------------------------------------------------------

      _initializationComplete = true;

      //------------------------------------------------------
      // SHOW CUSTOM GPS DIALOG ONLY IF:
      //
      // Permission was already granted before initialization
      // AND Location is currently OFF.
      //------------------------------------------------------

      if (_permissionWasAlreadyGranted &&
          locationState.permissionGranted &&
          !locationState.serviceEnabled &&
          !locationState.isLoading) {
        _showLocationOffDialog();
      }
    } catch (e, stackTrace) {
      debugPrint(
        'APP INITIALIZATION ERROR: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      //------------------------------------------------------
      // Even if initialization failed, allow lifecycle
      // checks to run afterward.
      //------------------------------------------------------

      _initializationComplete = true;
    }
  }

  //----------------------------------------------------------
  // APP LIFECYCLE
  //----------------------------------------------------------

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {
    super.didChangeAppLifecycleState(state);

    //--------------------------------------------------------
    // DO NOT CHECK LOCATION WHILE APP IS STILL INITIALIZING
    //--------------------------------------------------------

    if (state == AppLifecycleState.resumed &&
        _initializationComplete) {
      _checkLocationAfterResume();
    }
  }

  //----------------------------------------------------------
  // CHECK LOCATION AFTER RETURNING TO APP
  //----------------------------------------------------------

  Future<void> _checkLocationAfterResume() async {
    if (!mounted || !_initializationComplete) {
      return;
    }

    final controller =
    ref.read(locationControllerProvider.notifier);

    //--------------------------------------------------------
    // RE-CHECK LOCATION
    //--------------------------------------------------------

    await controller.checkLocation();

    if (!mounted) {
      return;
    }

    final locationState =
    ref.read(locationControllerProvider);

    //--------------------------------------------------------
    // SHOW CUSTOM DIALOG ONLY WHEN:
    //
    // Permission granted
    // AND GPS is OFF
    //--------------------------------------------------------

    if (locationState.permissionGranted &&
        !locationState.serviceEnabled &&
        !locationState.isLoading) {
      _showLocationOffDialog();
    }
  }

  //----------------------------------------------------------
  // LOCATION OFF DIALOG
  //----------------------------------------------------------

  Future<void> _showLocationOffDialog() async {
    //--------------------------------------------------------
    // PREVENT MULTIPLE DIALOGS
    //--------------------------------------------------------

    if (_locationDialogShowing) {
      return;
    }

    //--------------------------------------------------------
    // CHECK WIDGET
    //--------------------------------------------------------

    if (!mounted) {
      return;
    }

    //--------------------------------------------------------
    // GET LATEST LOCATION STATE
    //--------------------------------------------------------

    final locationState =
    ref.read(locationControllerProvider);

    //--------------------------------------------------------
    // LOCATION ALREADY ON
    //--------------------------------------------------------

    if (locationState.serviceEnabled) {
      return;
    }

    //--------------------------------------------------------
    // PERMISSION NOT GRANTED
    //
    // Android handles the permission dialog.
    //--------------------------------------------------------

    if (!locationState.permissionGranted) {
      return;
    }

    //--------------------------------------------------------
    // CHECK ACTUAL GPS STATUS
    //--------------------------------------------------------

    final bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!mounted || serviceEnabled) {
      return;
    }

    //--------------------------------------------------------
    // MARK DIALOG AS SHOWING
    //--------------------------------------------------------

    _locationDialogShowing = true;

    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(
              'Turn On Location',
            ),
            content: const Text(
              'Location is turned off. '
                  'Please turn on Location to use nearby hospitals, '
                  'pharmacies and emergency services.',
            ),
            actions: [
              //------------------------------------------------
              // EXIT
              //------------------------------------------------

              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Exit'),
              ),

              //------------------------------------------------
              // ENABLE
              //------------------------------------------------

              ElevatedButton(
                onPressed: () async {
                  //------------------------------------------------
                  // CLOSE DIALOG FIRST
                  //------------------------------------------------

                  Navigator.of(dialogContext).pop();

                  //------------------------------------------------
                  // OPEN ANDROID LOCATION SETTINGS
                  //------------------------------------------------

                  await ref
                      .read(
                    locationControllerProvider.notifier,
                  )
                      .openLocationSettings();

                  //------------------------------------------------
                  // When the user returns, lifecycle callback
                  // checks the location again.
                  //------------------------------------------------
                },
                child: const Text('Enable'),
              ),
            ],
          );
        },
      );
    } finally {
      _locationDialogShowing = false;
    }
  }

  //----------------------------------------------------------
  // BUILD
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final activeTab =
    ref.watch(mainTabProvider);

    Widget screen;

    switch (activeTab) {
      case "chat":
        screen = const ChatScreen();
        break;

      case "nearby":
        screen = const NearbyScreen();
        break;

      case "appointments":
        screen = const ScheduleScreen();
        break;

      case "profile":
        screen = const ProfilePage();
        break;

      case "home":
      default:
        screen = const HomeScreen();
    }

    return Scaffold(
      body: screen,
      bottomNavigationBar: AppBottomNavigation(
        activeTab: activeTab,
        onTabChanged: (tab) {
          ref
              .read(mainTabProvider.notifier)
              .state = tab;
        },
      ),
    );
  }

  //----------------------------------------------------------
  // DISPOSE
  //----------------------------------------------------------

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}