# Plan: Create the Settings Screen

This document outlines the plan to build a fully functional and styled settings screen based on the provided HTML design.

## Part 1: Create the Basic Structure and UI Widgets

1.  **Create New Files:**
    *   I will create a new file for the settings page itself: `lib/features/settings/presentation/pages/settings_page.dart`.
    *   I will also create placeholder files for the corresponding cubit and state: `lib/features/settings/presentation/cubit/settings_cubit.dart` and `lib/features/settings/presentation/cubit/settings_state.dart`.
2.  **Build the Page Layout:**
    *   In `settings_page.dart`, I will create a `StatelessWidget` for the page.
    *   The root widget will be a `Scaffold` with a dark background color (`#1a1a1a`) to match your design.
    *   The body will contain a `ListView` to hold the different setting cards, ensuring the page is scrollable.
3.  **Create Reusable "Card" Widget:**
    *   I will create a private reusable widget, `_SettingsCard`, that mimics the look of the `<div class="card">` from your HTML (darker background, rounded corners, padding). This will make the layout code clean and consistent.
4.  **Create Custom Form Widgets:**
    *   I will create two private reusable widgets to match your design's form elements:
        *   `_SettingsToggleRow`: A widget for rows containing a label and a custom-styled toggle switch.
        *   `_SettingsTextFieldRow`: A widget for rows containing a label and a custom-styled text input field.

## Part 2: Implement the Full UI

1.  **Assemble the Page:** Using the reusable widgets from Part 1, I will build out the full settings page in `settings_page.dart`.
2.  **Translate Sections:** I will translate each section from your HTML into a `_SettingsCard` containing the appropriate widgets:
    *   **File Rules:** This card will contain two `_SettingsTextFieldRow`s for excluded extensions/folders and one `_SettingsToggleRow` for showing hidden files.
    *   **Token Limit:** A `_SettingsCard` with a `_SettingsTextFieldRow` for the token count.
    *   **Content Options:** A `_SettingsCard` with a `_SettingsToggleRow` for stripping comments.
    *   **Theme Preferences:** A `_SettingsCard` containing a row with a label and a styled `DropdownButton` for theme selection.
    *   **App Behavior & Reset:** The final cards for the token warning and the "Reset to defaults" button.
3.  **Styling:** I will use the app's `MdTheme` for consistency where possible, but also apply the specific dark-theme colors, fonts, and spacing from your HTML's CSS to ensure the final result closely matches your design.

## Part 3: Add State Management (Placeholder)

1.  **Settings Model:** I will define a basic `SettingsModel` class that holds all the values for the settings (e.g., `bool showHiddenFiles`, `String theme`, etc.).
2.  **Cubit and State:** I will flesh out the `SettingsCubit` and `SettingsState` created in Part 1. The cubit will be responsible for managing the `SettingsModel`. For now, it will just hold a default set of values.
3.  **Connect UI to State:** I will wrap the settings page with a `BlocProvider` for the new `SettingsCubit` and use a `BlocBuilder` to ensure the UI can react to state changes (though there won't be any logic to change the state yet).

## Part 4: Add Navigation

1.  **Add Navigation Route:** I will add a new route for the settings page so it can be navigated to.
2.  **Add Entry Point:** I will add a temporary entry point to the new page. A common place is an `IconButton` in the `AppBar` of the main `FileExplorerPage`. I will add a settings icon there to open the new screen.

## Widget Hierarchy

This is a simplified view of the widget tree for the settings page.

```
SettingsPage
└── BlocProvider<SettingsCubit>
    └── Scaffold
        ├── AppBar (title: "Settings")
        └── BlocBuilder<SettingsCubit, SettingsState>
            └── ListView
                ├── _SettingsCard (title: "File Inclusion / Exclusion Rules")
                │   ├── _SettingsTextFieldRow (label: "Exclude files with these extensions")
                │   ├── _SettingsTextFieldRow (label: "Exclude folders or files by name")
                │   └── _SettingsToggleRow (label: "Show hidden files/folders")
                │
                ├── _SettingsCard (title: "Token Limit Awareness")
                │   └── _SettingsTextFieldRow (label: "Set Max Token Count (optional)")
                │
                ├── _SettingsCard (title: "Content Options")
                │   └── _SettingsToggleRow (label: "Strip comments from code?")
                │
                ├── _SettingsCard (title: "Language & Theme Preferences")
                │   └── Row
                │       ├── Text (label: "Theme")
                │       └── DropdownButton
                │
                ├── _SettingsCard (title: "App Behavior & Performance")
                │   └── _SettingsToggleRow (label: "Warn if export exceeds X tokens")
                │
                └── _SettingsCard (title: "Reset Settings")
                    └── TextButton (label: "Reset to defaults")

```
This hierarchy shows how reusable components like `_SettingsCard`, `_SettingsTextFieldRow`, and `_SettingsToggleRow` will be composed to build the screen efficiently.
