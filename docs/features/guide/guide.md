# Guide: Using the MDTheme System

This guide explains how to use the custom `MDTheme` system to ensure consistent and maintainable styling across the application.

---

## 1. What is `MDTheme`?

`MDTheme` is our project's custom theme provider. It replaces Flutter's default `Theme.of(context)` and acts as the **single source of truth** for all design tokens, including:

- Colors (`SystemTokens`)
- Typography (`TypographyTokens`)
- Shapes (`ShapeTokens`)
- Spacing (`SpacingTokens`)
- Elevation (`ElevationTokens`)


Using `MDTheme` ensures that all widgets in the app adhere to a centralized and consistent design system.

---

## 2. Setup: Providing the Theme

To make the theme available to all widgets, you must wrap a top-level widget (usually your `MaterialApp`) with the `MdTheme` widget. 

The `MdTheme` widget requires a `data` property, which must be an instance of `MdThemeToken`. You will typically create a light and dark theme token to be used based on the device's brightness.

**Example (`main.dart`):**

```dart
// Define your light and dark theme tokens
final mdThemeTokenLight = MdThemeToken(sys: systemTokensLight);
final mdThemeTokenDark = MdThemeToken(sys: systemTokensDark);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a builder to get the context for brightness
    return Builder(builder: (context) {
      final brightness = MediaQuery.platformBrightnessOf(context);
      final isDarkMode = brightness == Brightness.dark;

      // Provide the correct theme token based on brightness
      return MdTheme(
        data: isDarkMode ? mdThemeTokenDark : mdThemeTokenLight,
        child: MaterialApp(
          // It's recommended to also set the MaterialApp theme for
          // widgets that might not be fully integrated with MdTheme yet.
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          home: const MyHomePage(),
        ),
      );
    });
  }
}
```

---

## 3. Accessing Theme Data in Widgets

Once the theme is provided, any widget further down the tree can access the theme data using the static method `MdTheme.of(context)`.

This call, made within a widget's `build` method, returns the `MdThemeToken` instance currently in scope.

**Example:**

```dart
@override
Widget build(BuildContext context) {
  // 1. Get the theme token.
  final md = MdTheme.of(context);

  // 2. Use the token to style your widget.
  return Container(
    color: md.sys.background,
    padding: EdgeInsets.all(md.space.medium(context)),
    child: Text(
      'Hello, Themed World!',
      style: md.typ.getBodyLarge(context),
    ),
  );
}
```

---

## 4. Accessing Specific Token Values

Once you have the `md` object, you can access all design tokens through its properties. Here are examples for each category:

### Colors (`.sys.color`)

Provides the entire app color scheme.

```dart
// Primary color roles
md.sys.primary;            // Primary color
md.sys.onPrimary;          // Color for text/icons on primary
md.sys.primaryContainer;   // Container color for primary elements
md.sys.onPrimaryContainer; // Color for text/icons on primary container

// Secondary color roles
md.sys.secondary;          // Secondary color
md.sys.onSecondary;        // Color for text/icons on secondary
md.sys.secondaryContainer; // Container color for secondary elements
md.sys.onSecondaryContainer;// Color for text/icons on secondary container

// Tertiary color roles
md.sys.tertiary;           // Tertiary color
md.sys.onTertiary;         // Color for text/icons on tertiary
md.sys.tertiaryContainer;  // Container color for tertiary elements
md.sys.onTertiaryContainer;// Color for text/icons on tertiary container

// Surface and background roles
md.sys.surface;            // Surface color for cards, sheets
md.sys.onSurface;          // Color for text/icons on surface
md.sys.surfaceVariant;     // A variant of the surface color
md.sys.onSurfaceVariant;   // Color for text/icons on surface variant
md.sys.background;         // Screen background color
md.sys.onBackground;       // Color for text/icons on background
md.sys.inverseSurface;     // An inverse-colored surface for prominent elements
md.sys.inverseOnSurface;   // Color for text/icons on inverse surface
md.sys.inversePrimary;     // An inverse-colored primary for prominent elements
md.sys.surfaceTint;        // A tint color applied to surfaces

// Surface container colors
md.sys.surfaceContainer;         // Default surface container color
md.sys.surfaceContainerLow;      // Lower emphasis surface container
md.sys.surfaceContainerHigh;     // Higher emphasis surface container
md.sys.surfaceContainerHighest;  // Highest emphasis surface container

// Outline and border roles
md.sys.outline;            // Outline color for components
md.sys.outlineVariant;     // A variant of the outline color

// Error roles
md.sys.error;              // Color for errors
md.sys.onError;            // Color for text/icons on error
md.sys.errorContainer;     // Container color for error elements
md.sys.onErrorContainer;   // Color for text/icons on error container

// Scrim roles
md.sys.scrim;              // Scrim color to obscure content

// Extended semantic colors
md.sys.success;            // Color for success states
md.sys.onSuccess;          // Color for text/icons on success
md.sys.successContainer;   // Container color for success elements
md.sys.onSuccessContainer; // Color for text/icons on success container
md.sys.warning;            // Color for warning states
md.sys.onWarning;          // Color for text/icons on warning
md.sys.warningContainer;   // Container color for warning elements
md.sys.onWarningContainer; // Color for text/icons on warning container
md.sys.info;               // Color for info states
md.sys.onInfo;             // Color for text/icons on info
md.sys.infoContainer;      // Container color for info elements
md.sys.onInfoContainer;    // Color for text/icons on info container
```

### Typography (`.typ`)

Provides `TextStyle` objects for all text styles. To get the final responsive `TextStyle`, you must call the appropriate `get...()` method, passing the `context`.

```dart
// Correct way to get a TextStyle
style: md.typ.getDisplayLarge(context),      // Largest display text
style: md.typ.getDisplayMedium(context),     // Medium display text
style: md.typ.getDisplaySmall(context),      // Smallest display text
style: md.typ.getHeadlineLarge(context),     // Large headline
style: md.typ.getHeadlineMedium(context),    // Medium headline
style: md.typ.getHeadlineSmall(context),     // Small headline
style: md.typ.getTitleLarge(context),        // Large title
style: md.typ.getTitleMedium(context),       // Medium title
style: md.typ.getTitleSmall(context),        // Small title
style: md.typ.getBodyLarge(context),         // Large body text
style: md.typ.getBodyMedium(context),        // Medium body text
style: md.typ.getBodySmall(context),         // Small body text
style: md.typ.getLabelLarge(context),        // Large label (e.g., for buttons)
style: md.typ.getLabelMedium(context),       // Medium label
style: md.typ.getLabelSmall(context),        // Small label
```

### Shapes (`.sha`)

Provides `ShapeBorder` and `BorderRadius` objects for defining component shapes.

```dart
// --- Raw Corner Radius Values (doubles) ---
md.sha.cornerExtraSmall; // 4.0
md.sha.cornerSmall;      // 8.0
md.sha.cornerMedium;     // 12.0
md.sha.cornerLarge;      // 16.0
md.sha.cornerExtraLarge; // 28.0
md.sha.cornerFull;       // 999.0 (for circular shapes)

// --- BorderRadius Objects ---
// Use these for properties like `borderRadius` in a `BoxDecoration`.

// Symmetrical (all corners)
md.sha.borderRadiusExtraSmall; // BorderRadius.circular(4.0)
md.sha.borderRadiusSmall;
md.sha.borderRadiusMedium;
md.sha.borderRadiusLarge;
md.sha.borderRadiusExtraLarge;
md.sha.borderRadiusFull;

// Directional (e.g., top corners only)
md.sha.borderRadiusTopLarge;     // BorderRadius.vertical(top: Radius.circular(16.0))
md.sha.borderRadiusBottomMedium; // BorderRadius.vertical(bottom: Radius.circular(12.0))
md.sha.borderRadiusLeftSmall;    // BorderRadius.horizontal(left: Radius.circular(8.0))
md.sha.borderRadiusRightExtraLarge; // BorderRadius.horizontal(right: Radius.circular(28.0))
// (Available for Top, Bottom, Left, and Right in all sizes except Full)

// --- ShapeBorder Objects (RoundedRectangleBorder) ---
// Use these for properties like `shape` in `Card`, `Material`, etc.

// Symmetrical (all corners)
md.sha.shapeExtraSmall; // RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
md.sha.shapeSmall;
md.sha.shapeMedium;
md.sha.shapeLarge;
md.sha.shapeExtraLarge;
md.sha.shapeFull;

// Directional (e.g., top corners only)
md.sha.shapeTopLarge;     // RoundedRectangleBorder with top-only radius
md.sha.shapeBottomMedium; // RoundedRectangleBorder with bottom-only radius
md.sha.shapeLeftSmall;    // RoundedRectangleBorder with left-only radius
md.sha.shapeRightExtraLarge; // RoundedRectangleBorder with right-only radius
// (Available for Top, Bottom, Left, and Right in all sizes except Full)
```

### Spacing (`.space`)

Provides responsive spacing values and `EdgeInsets` helpers. **Always pass the `context`** to get the correct value for the current screen size.

```dart
// --- Raw Double Values ---
md.space.extraSmall(context);           // Extra small spacing
md.space.small(context);                // Small spacing
md.space.medium(context);               // Medium spacing
md.space.large(context);                // Large spacing
md.space.extraLarge(context);           // Extra large spacing
md.space.extraExtraLarge(context);      // 2x extra large spacing
md.space.extraExtraExtraLarge(context); // 3x extra large spacing

// --- EdgeInsets Helpers ---

// EdgeInsets.all()
md.space.allExtraSmall(context); // EdgeInsets.all(extraSmall)
md.space.allSmall(context);      // EdgeInsets.all(small)
md.space.allMedium(context);     // EdgeInsets.all(medium)
md.space.allLarge(context);      // EdgeInsets.all(large)
md.space.allExtraLarge(context); // EdgeInsets.all(extraLarge)

// EdgeInsets.symmetric(horizontal: ...)
md.space.hExtraSmall(context); // EdgeInsets.symmetric(horizontal: extraSmall)
md.space.hSmall(context);      // EdgeInsets.symmetric(horizontal: small)
md.space.hMedium(context);     // EdgeInsets.symmetric(horizontal: medium)
md.space.hLarge(context);      // EdgeInsets.symmetric(horizontal: large)
md.space.hExtraLarge(context); // EdgeInsets.symmetric(horizontal: extraLarge)

// EdgeInsets.symmetric(vertical: ...)
md.space.vExtraSmall(context); // EdgeInsets.symmetric(vertical: extraSmall)
md.space.vSmall(context);      // EdgeInsets.symmetric(vertical: small)
md.space.vMedium(context);     // EdgeInsets.symmetric(vertical: medium)
md.space.vLarge(context);      // EdgeInsets.symmetric(vertical: large)
md.space.vExtraLarge(context); // EdgeInsets.symmetric(vertical: extraLarge)
```

### Elevation (`.elevation`)

Provides raw `double` values for elevation levels and a helper to generate `BoxShadow` lists.

```dart
// --- Raw Double Values ---
// Use these for properties like `elevation` on a `Material` widget.
md.elevation.level0; // 0.0 - No elevation
md.elevation.level1; // 1.0
md.elevation.level2; // 3.0
md.elevation.level3; // 6.0
md.elevation.level4; // 8.0
md.elevation.level5; // 12.0 - Highest elevation

// --- BoxShadow Generator ---
// Use this to apply shadows in a `BoxDecoration`.
Container(
  decoration: BoxDecoration(
    boxShadow: md.elevation.getShadows(3), // Returns a List<BoxShadow> for level 3
  ),
);
```

### Motion (`.motion`)

Provides standard animation durations and easing curves.

```dart
// --- Durations ---
md.motion.durationShort;  // 100ms - For quick, subtle animations
md.motion.durationMedium; // 250ms - For standard component transitions
md.motion.durationLong;   // 500ms - For large-scale animations

// --- Easing Curves ---
md.motion.curveStandard;   // Curves.easeInOut - For most animations
md.motion.curveDecelerate; // Curves.easeOut - For elements entering the screen
md.motion.curveAccelerate; // Curves.easeIn - For elements exiting the screen

// Example in an AnimatedContainer
AnimatedContainer(
  duration: md.motion.durationMedium,
  curve: md.motion.curveStandard,
  // ... other properties
)
```

---

## 5. Accessing Component Token Values (`.com`)

Component tokens provide pre-configured styles for specific widgets, making it easy to build a consistent UI. You can access them via `md.com`.

### App Bar (`.com.appBar`)

```dart
md.com.appBar.backgroundColor;    // Default background color for AppBar
md.com.appBar.foregroundColor;    // Default color for icons and text
md.com.appBar.shadowColor;        // Shadow color
md.com.appBar.surfaceTintColor;   // Surface tint color
md.com.appBar.titleTextStyle;     // TextStyle for the title
```

### Buttons (`.com.button`)

```dart
// For ElevatedButton
md.com.button.elevatedButtonBackgroundColor;
md.com.button.elevatedButtonForegroundColor;
md.com.button.elevatedButtonDisabledBackgroundColor;
md.com.button.elevatedButtonDisabledForegroundColor;

// For OutlinedButton
md.com.button.outlinedButtonBorderColor;
md.com.button.outlinedButtonForegroundColor;

// For TextButton
md.com.button.textButtonForegroundColor;

// Common text style for all buttons
md.com.button.textStyle;
```

### Cards (`.com.card`)

```dart
md.com.card.backgroundColor;    // Background color of the card
md.com.card.borderColor;        // Border color for outlined cards
md.com.card.shadowColor;        // Shadow color
md.com.card.surfaceTintColor;   // Surface tint color
md.com.card.titleTextStyle;     // TextStyle for the card's title
md.com.card.subtitleTextStyle;  // TextStyle for the card's subtitle
```

### Chips (`.com.chip`)

```dart
md.com.chip.backgroundColor;    // Background color
md.com.chip.foregroundColor;    // Foreground color for text and icons
md.com.chip.selectedColor;      // Color when the chip is selected
md.com.chip.disabledColor;      // Color when the chip is disabled
md.com.chip.labelStyle;         // TextStyle for the chip's label
```

### Dialogs (`.com.dialog`)

```dart
md.com.dialog.backgroundColor;    // Background color of the dialog
md.com.dialog.surfaceTintColor;   // Surface tint color
md.com.dialog.titleTextStyle;     // TextStyle for the dialog's title
md.com.dialog.contentTextStyle;   // TextStyle for the dialog's content
```

### Floating Action Buttons (`.com.fab`)

```dart
md.com.fab.backgroundColor;    // Background color
md.com.fab.foregroundColor;    // Color for the icon
md.com.fab.focusColor;         // Color for focus highlight
md.com.fab.hoverColor;         // Color for hover highlight
md.com.fab.splashColor;        // Color for the ripple effect
```

### Navigation (`.com.navigation`)

```dart
// For NavigationBar
md.com.navigation.navigationBarBackgroundColor;
md.com.navigation.navigationBarForegroundColor;
md.com.navigation.navigationBarIndicatorColor; // Color of the selected item indicator
md.com.navigation.navigationBarLabelTextStyle;

// For NavigationRail
md.com.navigation.navigationRailBackgroundColor;
md.com.navigation.navigationRailForegroundColor;
md.com.navigation.navigationRailIndicatorColor; // Color of the selected item indicator
md.com.navigation.navigationRailLabelTextStyle;
```

### Surfaces (`.com.surface`)

```dart
md.com.surface.surfaceContainerColor;        // Default surface container color
md.com.surface.surfaceContainerLowColor;     // Lower emphasis surface
md.com.surface.surfaceContainerHighColor;    // Higher emphasis surface
md.com.surface.surfaceContainerHighestColor; // Highest emphasis surface
```

### Text Fields (`.com.textField`)

```dart
md.com.textField.backgroundColor;     // Fill color of the text field
md.com.textField.cursorColor;         // Color of the cursor
md.com.textField.selectionColor;      // Background color of selected text
md.com.textField.selectionHandleColor;// Color of the selection handles
md.com.textField.focusColor;          // Highlight color when focused
md.com.textField.hoverColor;          // Highlight color when hovered
md.com.textField.textStyle;           // TextStyle for the input text
md.com.textField.labelStyle;          // TextStyle for the label/placeholder
```