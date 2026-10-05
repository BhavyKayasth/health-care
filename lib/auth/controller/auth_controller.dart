import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

///--------------------------------------------------------------
/// Provider
///--------------------------------------------------------------

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>(
      (ref) => AuthController(),
);

///--------------------------------------------------------------
/// State
///--------------------------------------------------------------

@immutable
class AuthState {
  final bool isLogin;
  final bool isPasswordVisible;
  final bool isLoading;

  const AuthState({
    required this.isLogin,
    required this.isPasswordVisible,
    required this.isLoading,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLogin: true,
      isPasswordVisible: false,
      isLoading: false,
    );
  }

  AuthState copyWith({
    bool? isLogin,
    bool? isPasswordVisible,
    bool? isLoading,
  }) {
    return AuthState(
      isLogin: isLogin ?? this.isLogin,
      isPasswordVisible:
      isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

///--------------------------------------------------------------
/// Controller
///--------------------------------------------------------------

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.initial()) {
    _initializeGoogleSignIn();
  }

  /// Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Google Sign In
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Form Key
  final formKey = GlobalKey<FormState>();

  /// Text Controllers
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool _googleInitialized = false;

  ///--------------------------------------------------------------
  /// Initialize Google Sign In
  ///--------------------------------------------------------------

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _googleInitialized = true;
    } catch (e) {
      debugPrint(
        'Google Sign-In initialization failed: $e',
      );
    }
  }

  ///--------------------------------------------------------------
  /// Change Login / Signup
  ///--------------------------------------------------------------

  void switchToLogin() {
    state = state.copyWith(
      isLogin: true,
      isPasswordVisible: false,
    );

    formKey.currentState?.reset();
  }

  void switchToSignup() {
    state = state.copyWith(
      isLogin: false,
      isPasswordVisible: false,
    );

    formKey.currentState?.reset();
  }

  ///--------------------------------------------------------------
  /// Password Visibility
  ///--------------------------------------------------------------

  void togglePasswordVisibility() {
    state = state.copyWith(
      isPasswordVisible:
      !state.isPasswordVisible,
    );
  }

  ///--------------------------------------------------------------
  /// Loading
  ///--------------------------------------------------------------

  void setLoading(bool value) {
    state = state.copyWith(
      isLoading: value,
    );
  }

  ///--------------------------------------------------------------
  /// EMAIL LOGIN / SIGNUP
  ///--------------------------------------------------------------

  Future<String?> authenticateWithEmail() async {
    final email =
    emailController.text.trim();

    final password =
    passwordController.text.trim();

    final name =
    nameController.text.trim();

    // -----------------------------------------
    // Basic validation
    // -----------------------------------------

    if (!state.isLogin && name.isEmpty) {
      return 'Please enter your full name.';
    }

    if (email.isEmpty) {
      return 'Please enter your email address.';
    }

    if (!email.contains('@') ||
        !email.contains('.')) {
      return 'Please enter a valid email address.';
    }

    if (password.isEmpty) {
      return 'Please enter your password.';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    try {
      setLoading(true);

      UserCredential credential;

      // =========================================
      // SIGNUP
      // =========================================

      if (!state.isLogin) {
        credential =
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = credential.user;

        if (user != null) {
          // Save the user's name into Firebase Auth.
          await user.updateDisplayName(name);

          // Reload so displayName is immediately available.
          await user.reload();
        }
      }

      // =========================================
      // LOGIN
      // =========================================

      else {
        credential =
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      setLoading(false);

      return null;
    } on FirebaseAuthException catch (e) {
      setLoading(false);

      return _firebaseErrorMessage(e);
    } catch (e) {
      setLoading(false);

      return 'Something went wrong. Please try again.';
    }
  }

  ///--------------------------------------------------------------
  /// GOOGLE LOGIN / SIGNUP
  ///--------------------------------------------------------------

  Future<String?> signInWithGoogle() async {
    try {
      setLoading(true);

      // Make sure initialization completed.
      if (!_googleInitialized) {
        await _initializeGoogleSignIn();
      }

      if (!_googleInitialized) {
        setLoading(false);

        return 'Google Sign-In could not be initialized.';
      }

      // -----------------------------------------
      // Open Google account picker
      // -----------------------------------------

      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();

      // -----------------------------------------
      // Get Google authentication data
      // -----------------------------------------

      final GoogleSignInAuthentication
      googleAuth =
          googleUser.authentication;

      // -----------------------------------------
      // Create Firebase credential
      // -----------------------------------------

      final credential =
      GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // -----------------------------------------
      // Sign in / create Firebase account
      // -----------------------------------------

      final UserCredential userCredential =
      await _auth.signInWithCredential(
        credential,
      );

      // -----------------------------------------
      // Get Firebase user
      // -----------------------------------------

      final user = userCredential.user;

      // Google normally provides displayName.
      // If Firebase doesn't have one yet, save
      // the Google name manually.
      if (user != null &&
          (user.displayName == null ||
              user.displayName!.trim().isEmpty) &&
          googleUser.displayName!.trim().isNotEmpty) {
        await user.updateDisplayName(
          googleUser.displayName,
        );

        await user.reload();
      }

      setLoading(false);

      return null;
    } on FirebaseAuthException catch (e) {
      setLoading(false);

      return _firebaseErrorMessage(e);
    } on GoogleSignInException catch (e) {
      setLoading(false);

      debugPrint(
        'Google Sign-In error: $e',
      );

      return 'Google Sign-In was cancelled or failed.';
    } catch (e) {
      setLoading(false);

      debugPrint(
        'Google Sign-In error: $e',
      );

      return 'Unable to sign in with Google.';
    }
  }

  ///--------------------------------------------------------------
  /// Current Firebase User
  ///--------------------------------------------------------------

  User? get currentUser =>
      _auth.currentUser;

  ///--------------------------------------------------------------
  /// Current User Name
  ///--------------------------------------------------------------

  String get currentUserName {
    final user = _auth.currentUser;

    if (user == null) {
      return 'User';
    }

    final name =
    user.displayName?.trim();

    if (name != null &&
        name.isNotEmpty) {
      return name;
    }

    return 'User';
  }

  ///--------------------------------------------------------------
  /// Firebase Error Messages
  ///--------------------------------------------------------------

  String _firebaseErrorMessage(
      FirebaseAuthException e,
      ) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Your password is too weak.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase.';

      default:
        return e.message ??
            'Authentication failed. Please try again.';
    }
  }

  ///--------------------------------------------------------------
  /// Sign Out
  ///--------------------------------------------------------------

  Future<void> signOut() async {
    await _auth.signOut();

    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Google may already be signed out.
    }
  }

  ///--------------------------------------------------------------
  /// Clear Form
  ///--------------------------------------------------------------

  void clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  ///--------------------------------------------------------------
  /// Dispose
  ///--------------------------------------------------------------

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}