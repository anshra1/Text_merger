import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_system/material_design_system.dart';
import 'package:text_merger/core/di/di.dart';
import 'package:text_merger/core/routes/routes.dart';
import 'package:text_merger/core/theme/cubit/theme_cubit.dart';
import 'package:text_merger/core/theme/cubit/theme_state.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/file_explorer_cubit.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/workspace_cubit.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/settings/cubit/settings_cubit.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => sl<ThemeCubit>(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => sl<SettingsCubit>(),
        ),
        // TODO: Add other providers here as needed
        BlocProvider<WorkspaceCubit>(
          create: (context) {
            final cubit = sl<WorkspaceCubit>();
            return cubit;
          },
        ),

        BlocProvider<FileExplorerCubit>(
          create: (context) {
            final cubit = sl<FileExplorerCubit>();
            return cubit;
          },
        ),
      ],
      child: const AppContainer(),
    );
  }
}

class AppContainer extends StatelessWidget {
  const AppContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        // Determine if dark mode based on theme mode and platform brightness
        final effectiveBrightness = switch (state.themeMode) {
          ThemeMode.dark => Brightness.dark,
          ThemeMode.light => Brightness.light,
          ThemeMode.system => state.platformBrightness,
        };
        final isDark = effectiveBrightness == Brightness.dark;

        // Build SystemTokens from Facebook brand-like seeds
        final seeds = _facebookReferenceTokens();
        final tokens = isDark
            ? const StandardDarkThemeGenerator().generate(seeds: seeds)
            : const StandardLightThemeGenerator().generate(seeds: seeds);

        // Convert to Flutter ColorScheme and ThemeData
        final colorScheme = SystemTokenToColorSchemeConverter.convert(
          tokens,
          effectiveBrightness,
        );

        final theme = ThemeData(
          useMaterial3: true,
          brightness: effectiveBrightness,
          colorScheme: colorScheme,
          fontFamily: state.fontFamily.isEmpty ? null : state.fontFamily,
          scaffoldBackgroundColor: tokens.background,
          canvasColor: tokens.surface,
        );

        return MdTheme(
          data: MdThemeToken(sys: tokens),
          child: MaterialApp.router(
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            title: 'Context for AI',
            theme: theme,
            darkTheme: theme.copyWith(brightness: Brightness.dark),
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  platformBrightness: isDark ? Brightness.dark : Brightness.light,
                  textScaler: TextScaler.noScaling,
                ),
                child: ErrorBoundary(child: child ?? const SizedBox.shrink()),
              );
            },
          ),
        );
      },
    );
  }
}

/// Facebook-like brand seeds for theme generation
ReferenceTokens _facebookReferenceTokens() {
  // TODO: Source of input list not provided. Should I mock or will you supply it?
  // NOTE: Using commonly recognized Facebook palette approximations; please confirm exact brand values.
  return const ReferenceTokens(
    primary: Color(0xFF1877F2), // Facebook Blue
    secondary: Color(0xFF65676B), // Neutral Gray
    tertiary: Color(0xFF385898), // Darker Blue accent
    neutral: Color(0xFFF0F2F5), // Background light
    neutralVariant: Color(0xFFE4E6EB), // Surface variant
    error: Color(0xFFB00020),
    success: Color(0xFF42B72A),
    warning: Color(0xFFF7B928),
    info: Color(0xFF1877F2),
  );
}

class ErrorBoundary extends StatelessWidget {
  const ErrorBoundary({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox.expand(child: child),
    );
  }
}
