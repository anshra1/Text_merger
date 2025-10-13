// import 'package:flutter/material.dart';
// import 'package:theme_ui_widgets/theme_ui_widgets.dart';

// /// [AppFlutterThemeData] converts design tokens defined in [AppThemeData]
// /// to Flutter's native [ThemeData] format.
// ///
// /// REFINEMENTS:
// /// 1. SINGLE SOURCE OF TRUTH: Component themes now reference the generated
// ///    `colorScheme` object, ensuring consistency.
// /// 2. INTERACTIVE STATES: Hover states are now implemented for buttons using
// ///    `WidgetStateProperty` and your hover tokens.
// /// 3. MATERIAL 3 SURFACES: Your layer tokens are fully mapped to M3's
// ///    `surfaceContainer` properties for enhanced depth.
// class AppFlutterThemeData {
//   const AppFlutterThemeData._(); // Prevent instantiation

//   static ThemeData toFlutterTheme(
//      {required AppThemeData tokens,
//     required Brightness brightness,
//     String? fontFamily,
//   }) {
//     // Keep direct token references for clarity and for areas where ColorScheme
//     // doesn't have a direct mapping (e.g., custom hover colors).
//     final text = tokens.textColorScheme;
//     final fill = tokens.fillColorScheme;
//     final border = tokens.borderColorScheme;
//     final surface = tokens.surfaceColorScheme;
//     final background = tokens.backgroundColorScheme;
//     final icon = tokens.iconColorScheme;
//     final spacing = tokens.spacing;
//     final radius = tokens.borderRadius;
//     // AppThemeData already contains the correct font family from user choice
//     final textStyle = tokens.textStyle;

//     // --- 1. DEFINE THE CORE COLOR SCHEME ---
//     // This becomes the single source of truth for most color properties.
//     final colorScheme = ColorScheme(
//       brightness: brightness,
//       primary: fill.themeThick,
//       onPrimary: text.onFill,
//       primaryContainer: fill.themeSelect,
//       onPrimaryContainer: text.primary,

//       // For semantic purposes, we can map secondary to a neutral or brand color.
//       // Here, we'll map it to a neutral fill for this example.
//       secondary: fill.primary,
//       onSecondary: text.primary,
//       secondaryContainer: fill.primaryHover,
//       onSecondaryContainer: text.primary,

//       // Tertiary is often used for less prominent actions or accents.
//       tertiary: fill.infoLight,
//       onTertiary: text.primary,
//       tertiaryContainer: fill.primaryHover,
//       onTertiaryContainer: text.primary,

//       error: border.errorThick,
//       onError: text.onFill,
//       errorContainer: fill.errorLight,
//       onErrorContainer: text.error,

//       // --- REFINEMENT: Mapped all surface layers for M3 depth ---
//       surface: surface.primary,
//       onSurface: text.primary,
//       surfaceDim: surface.overlay,
//       surfaceBright: surface.layer01, // Brightest surface
//       surfaceContainerLowest: surface.layer04, // Deepest layer
//       surfaceContainerLow: surface.layer03,
//       surfaceContainer: surface.layer02,
//       surfaceContainerHigh: surface.layer01,
//       surfaceContainerHighest: surface.layer01, // Most prominent layer

//       onSurfaceVariant: text.secondary,
//       outline: border.primary,
//       outlineVariant: border.primaryHover,
//       shadow: Colors.black.withValues(alpha: 0.1),
//       scrim: surface.overlay,
//       inverseSurface: surface.inverse,
//       onInverseSurface: text.onFill,
//       inversePrimary: text.onFill, // Primary color on an inverse surface
//     );

//     return ThemeData(
//       useMaterial3: true,
//       brightness: brightness,
//       fontFamily: textStyle.bodyMedium.fontFamily,
//       colorScheme: colorScheme,
//       scaffoldBackgroundColor: background.primary,
//       canvasColor: colorScheme.surface,
//       dividerColor: colorScheme.outline,
//       disabledColor: text.quaternary,

//       // --- REFINEMENT: Text colors now reference the ColorScheme ---
//       textTheme: TextTheme(
//         displayLarge: textStyle.displayLarge
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         displayMedium: textStyle.displayMedium
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         displaySmall: textStyle.displaySmall
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         headlineLarge: textStyle.headlineLarge
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         headlineMedium: textStyle.headlineMedium
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         headlineSmall: textStyle.headlineSmall
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         titleLarge: textStyle.titleLarge
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         titleMedium: textStyle.titleMedium
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         titleSmall: textStyle.titleSmall
//             .standard(color: colorScheme.onSurfaceVariant, family: fontFamily),
//         bodyLarge: textStyle.bodyLarge
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         bodyMedium: textStyle.bodyMedium
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         bodySmall: textStyle.bodySmall
//             .standard(color: colorScheme.onSurfaceVariant, family: fontFamily),
//         labelLarge: textStyle.labelLarge
//             .standard(color: colorScheme.onSurface, family: fontFamily),
//         labelMedium: textStyle.labelMedium
//             .standard(color: colorScheme.onSurfaceVariant, family: fontFamily),
//         labelSmall: textStyle.labelSmall
//             .standard(color: colorScheme.tertiary, family: fontFamily),
//       ),

//       iconTheme: IconThemeData(color: icon.primary, size: 24),
//       primaryIconTheme: IconThemeData(color: colorScheme.onPrimary, size: 24),

//       // --- REFINEMENT: Switched to ButtonStyle and implemented hover states ---
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ButtonStyle(
//           backgroundColor: WidgetStateProperty.resolveWith((states) {
//             if (states.contains(WidgetState.hovered)) return fill.themeThickHover;
//             if (states.contains(WidgetState.disabled)) {
//               return colorScheme.onSurface.withValues(alpha: 0.12);
//             }
//             return colorScheme.primary; // Default
//           }),
//           foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
//           shape: WidgetStateProperty.all(
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.m)),
//           ),
//           padding: WidgetStateProperty.all(
//             EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.l),
//           ),
//           textStyle: WidgetStateProperty.all(textStyle.labelLarge.standard()),
//           elevation: WidgetStateProperty.all(2),
//           overlayColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.1)),
//         ),
//       ),

//       textButtonTheme: TextButtonThemeData(
//         style: ButtonStyle(
//           foregroundColor: WidgetStateProperty.resolveWith((states) {
//             if (states.contains(WidgetState.hovered)) return text.actionHover;
//             return text.action; // Default from your tokens
//           }),
//           overlayColor: WidgetStateProperty.resolveWith((states) {
//             if (states.contains(WidgetState.hovered)) return fill.primaryHover;
//             return Colors.transparent;
//           }),
//           shape: WidgetStateProperty.all(
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.m)),
//           ),
//           padding: WidgetStateProperty.all(
//             EdgeInsets.symmetric(horizontal: spacing.l, vertical: spacing.m),
//           ),
//           textStyle: WidgetStateProperty.all(textStyle.labelLarge.standard()),
//         ),
//       ),

//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: ButtonStyle(
//           foregroundColor: WidgetStateProperty.resolveWith((states) {
//             if (states.contains(WidgetState.hovered)) return colorScheme.primary;
//             return colorScheme.onSurface;
//           }),
//           backgroundColor: WidgetStateProperty.resolveWith((states) {
//             if (states.contains(WidgetState.hovered)) {
//               return colorScheme.primary.withValues(alpha: 0.05);
//             }
//             return Colors.transparent;
//           }),
//           side: WidgetStateProperty.resolveWith((states) {
//             if (states.contains(WidgetState.focused) ||
//                 states.contains(WidgetState.pressed)) {
//               return BorderSide(color: colorScheme.primary, width: 2);
//             }
//             if (states.contains(WidgetState.hovered)) {
//               return BorderSide(color: colorScheme.outlineVariant);
//             }
//             return BorderSide(color: colorScheme.outline);
//           }),
//           shape: WidgetStateProperty.all(
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.m)),
//           ),
//           padding: WidgetStateProperty.all(
//             EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.l),
//           ),
//           textStyle: WidgetStateProperty.all(textStyle.labelLarge.standard()),
//         ),
//       ),

//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: colorScheme.primary,
//         foregroundColor: colorScheme.onPrimary,
//         hoverColor: fill.themeThickHover,
//         elevation: 6,
//         focusElevation: 8,
//         hoverElevation: 8,
//         highlightElevation: 12,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.l)),
//       ),

//       // --- REFINEMENT: Using ColorScheme and surface containers for consistency ---
//       appBarTheme: AppBarTheme(
//         backgroundColor: colorScheme.surface, // Use a base surface color
//         foregroundColor: colorScheme.onSurface,
//         elevation: 0,
//         scrolledUnderElevation: 2,
//         shadowColor: colorScheme.shadow,
//         centerTitle: false,
//         titleTextStyle: textStyle.titleLarge.standard(color: colorScheme.onSurface),
//         iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
//         actionsIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
//       ),

//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: colorScheme.surfaceContainer,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius.m),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius.m),
//           borderSide: BorderSide(color: colorScheme.outline),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius.m),
//           borderSide: BorderSide(color: colorScheme.primary, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius.m),
//           borderSide: BorderSide(color: colorScheme.error),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(radius.m),
//           borderSide: BorderSide(color: colorScheme.error, width: 2),
//         ),
//         labelStyle: textStyle.bodyMedium.standard(color: colorScheme.onSurfaceVariant),
//         hintStyle: textStyle.bodyMedium.standard(color: text.tertiary),
//         errorStyle: textStyle.bodySmall.standard(color: colorScheme.error),
//         helperStyle: textStyle.bodySmall.standard(color: colorScheme.onSurfaceVariant),
//         contentPadding: EdgeInsets.symmetric(horizontal: spacing.l, vertical: spacing.m),
//       ),

//       chipTheme: ChipThemeData(
//         backgroundColor: colorScheme.surfaceContainer,
//         disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
//         selectedColor: colorScheme.primaryContainer,
//         padding: EdgeInsets.all(spacing.m),
//         labelStyle: textStyle.labelMedium.standard(color: colorScheme.onSurfaceVariant),
//         secondaryLabelStyle:
//             textStyle.labelMedium.standard(color: colorScheme.onPrimaryContainer),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.s)),
//         side: BorderSide(color: colorScheme.outline),
//       ),

//       checkboxTheme: CheckboxThemeData(
//         fillColor: WidgetStateProperty.resolveWith((states) {
//           if (states.contains(WidgetState.selected)) return colorScheme.primary;
//           return Colors.transparent;
//         }),
//         checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
//         side: BorderSide(color: colorScheme.outline, width: 2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.xs)),
//       ),

//       dialogTheme: DialogThemeData(
//         backgroundColor: colorScheme.surfaceContainerHigh, // Use a higher surface
//         elevation: 8,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.l)),
//         titleTextStyle: textStyle.headlineSmall.standard(color: colorScheme.onSurface),
//         contentTextStyle:
//             textStyle.bodyMedium.standard(color: colorScheme.onSurfaceVariant),
//       ),

//       snackBarTheme: SnackBarThemeData(
//         backgroundColor: colorScheme.inverseSurface,
//         contentTextStyle:
//             textStyle.bodyMedium.standard(color: colorScheme.onInverseSurface),
//         actionTextColor: colorScheme.inversePrimary,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.m)),
//         elevation: 6,
//       ),

//       tabBarTheme: TabBarThemeData(
//         labelColor: colorScheme.primary,
//         unselectedLabelColor: colorScheme.onSurfaceVariant,
//         labelStyle: textStyle.labelLarge.standard(),
//         unselectedLabelStyle: textStyle.labelLarge.standard(),
//         indicator: UnderlineTabIndicator(
//           borderSide: BorderSide(color: colorScheme.primary, width: 2),
//         ),
//         indicatorSize: TabBarIndicatorSize.label,
//         dividerColor: colorScheme.outline,
//       ),

//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: colorScheme.surfaceContainer,
//         selectedItemColor: colorScheme.primary,
//         unselectedItemColor: colorScheme.onSurfaceVariant,
//         selectedLabelStyle: textStyle.labelSmall.standard(),
//         unselectedLabelStyle: textStyle.labelSmall.standard(),
//         type: BottomNavigationBarType.fixed,
//         elevation: 8,
//       ),

//       dividerTheme: DividerThemeData(
//         color: colorScheme.outline,
//         thickness: 1,
//         space: spacing.l,
//       ),

//       cardTheme: CardThemeData(
//         color: colorScheme.surfaceContainer,
//         elevation: 1,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(radius.l),
//           side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
//         ),
//         margin: EdgeInsets.all(spacing.m),
//       ),

//       listTileTheme: ListTileThemeData(
//         tileColor: Colors.transparent, // Usually better to have transparent tiles
//         selectedTileColor: colorScheme.primaryContainer,
//         iconColor: colorScheme.onSurfaceVariant,
//         textColor: colorScheme.onSurface,
//         titleTextStyle: textStyle.bodyLarge.standard(),
//         subtitleTextStyle:
//             textStyle.bodyMedium.standard(color: colorScheme.onSurfaceVariant),
//         contentPadding: EdgeInsets.symmetric(horizontal: spacing.l),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.m)),
//       ),

//       progressIndicatorTheme: ProgressIndicatorThemeData(
//         color: colorScheme.primary,
//         linearTrackColor: colorScheme.surfaceContainerHighest,
//         circularTrackColor: colorScheme.surfaceContainerHighest,
//       ),

//       tooltipTheme: TooltipThemeData(
//         decoration: BoxDecoration(
//           color: colorScheme.inverseSurface,
//           borderRadius: BorderRadius.circular(radius.s),
//         ),
//         textStyle: textStyle.bodySmall.standard(color: colorScheme.onInverseSurface),
//         padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
//       ),
//     );
//   }
// }
