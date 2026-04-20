import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_flow/features/auth/data/auth_repository.dart';
import 'package:note_flow/features/auth/domain/user_model.dart';

// Repository singleton
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Auth state stream
final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

// Current user (sync)
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value;
});

// Auth actions notifier
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<bool> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signInWithEmailPassword(email: email, password: password);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(_friendlyError(e), st);
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signUpWithEmailPassword(
          email: email, password: password, name: name);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(_friendlyError(e), st);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.signInWithGoogle();
      state = const AsyncValue.data(null);
      return user != null;
    } catch (e, st) {
      state = AsyncValue.error(_friendlyError(e), st);
      return false;
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AsyncValue.data(null);
  }

  Future<bool> sendPasswordReset(String email) async {
    try {
      await _repo.sendPasswordResetEmail(email);
      return true;
    } catch (_) {
      return false;
    }
  }

  void clearError() => state = const AsyncValue.data(null);

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('user-not-found') || msg.contains('wrong-password')) {
      return 'Invalid email or password';
    } else if (msg.contains('email-already-in-use')) {
      return 'An account already exists with this email';
    } else if (msg.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later';
    } else if (msg.contains('network')) {
      return 'Network error. Check your connection';
    }
    return 'Authentication failed. Please try again';
  }
}
