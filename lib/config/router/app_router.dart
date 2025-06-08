import 'package:epale_app/config/router/app_router_notifier.dart';
import 'package:epale_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:epale_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:epale_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:epale_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:epale_app/features/auth/presentation/screens/check_auth_status_screen.dart';
import 'package:epale_app/features/chat/presentation/screens/chat_list_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    refreshListenable: goRouterNotifier,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/signup',
        builder: (context, state) {
          return const SignUpScreen();
        },
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) {
          return const SignInScreen();
        },
      ),

      // Main Routes
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const ChatListScreen();
        },
      ),

      GoRoute(
        path: '/chat/:profileId',
        builder: (context, state) {
          return ChatScreen(
            profileId: state.pathParameters['profileId'] ?? 'no-id',
          );
        },
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.fullPath;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/signin' || isGoingTo == '/signup') {
          return null;
        }

        return '/signin';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/signin' ||
            isGoingTo == '/signup' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
