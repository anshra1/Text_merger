import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:text_merger/core/pages/page_not_found.dart';
import 'package:text_merger/core/routes/route_name.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/file_explorer/pages/file_explorer_page.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/settings/pages/settings_page.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/workspace/pages/workspace_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  static final GlobalKey<NavigatorState> mainMenuNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'main_menu',
  );

  // Expose the root navigator key for global services
  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  static final GoRouter router = GoRouter(
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: PageNotFoundScreen(onPressed: () {}),
    ),
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutesName.workspaceSelector,
    routes: [
      GoRoute(
        path: RoutesName.pageNotFound,
        name: RoutesName.pageNotFound,
        pageBuilder: (_, state) {
          return _buildTransition(
            child: PageNotFoundScreen(onPressed: () {}),
            state: state,
          );
        },
      ),

      GoRoute(
        path: RoutesName.workspaceSelector,
        name: RoutesName.workspaceSelector,
        pageBuilder: (_, state) {
          return _buildTransition(
            child: const WorkspaceSelectorPage(),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RoutesName.fileExplorer,
        name: RoutesName.fileExplorer,
        pageBuilder: (_, state) {
          return _buildTransition(
            child: FileExplorerPage(workspaceData: state.extra!),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RoutesName.settings,
        name: RoutesName.settings,
        pageBuilder: (_, state) {
          return _buildTransition(
            child: const SettingsPage(),
            state: state,
          );
        },
      ),
    ],
  );

  static Page<void> _buildTransition({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: kThemeAnimationDuration,
      reverseTransitionDuration: kThemeAnimationDuration,
    );
  }
}
