import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:note_flow/features/auth/presentation/providers/auth_provider.dart';
import 'package:note_flow/features/auth/presentation/screens/login_screen.dart';
import 'package:note_flow/features/auth/presentation/screens/register_screen.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';
import 'package:note_flow/features/notes/presentation/screens/archived_screen.dart';
import 'package:note_flow/features/notes/presentation/screens/home_screen.dart';
import 'package:note_flow/features/notes/presentation/screens/note_editor_screen.dart';
import 'package:note_flow/features/notes/presentation/screens/search_screen.dart';
import 'package:note_flow/features/notes/presentation/screens/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoading = authState.isLoading;
      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/register';

      if (isLoading) return null;
      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'search',
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: 'archived',
            name: 'archived',
            builder: (context, state) => const ArchivedScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'editor',
            name: 'editor',
            builder: (context, state) {
              final note = state.extra as NoteModel?;
              return NoteEditorScreen(note: note);
            },
          ),
        ],
      ),
    ],
  );
});
