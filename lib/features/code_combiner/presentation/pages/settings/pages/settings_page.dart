import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_system/material_design_system.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_merger/core/di/di.dart';
import 'package:text_merger/core/theme/cubit/theme_cubit.dart';
import 'package:text_merger/core/theme/cubit/theme_state.dart' as CoreThemeState;
import 'package:text_merger/features/code_combiner/presentation/cubits/file_explorer_cubit.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/file_explorer_state.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/settings/cubit/settings_cubit.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/settings/cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(prefs: sl<SharedPreferences>())..init(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final md = MdTheme.of(context);
    final settingsCubit = context.read<SettingsCubit>();
    final themeCubit = context.read<ThemeCubit>();

    return Scaffold(
      backgroundColor: md.sys.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: md.sys.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          final settings = settingsState.settings;
          return BlocBuilder<ThemeCubit, CoreThemeState.ThemeState>(
            builder: (context, themeState) {
              return ListView(
                padding: EdgeInsets.all(md.space.medium(context)),
                children: [
                  BlocBuilder<FileExplorerCubit, FileExplorerState>(
                    builder: (context, fileExplorerState) {
                      final fileExplorerCubit = context.read<FileExplorerCubit>();
                      final filterSettings = fileExplorerCubit.currentFilterSettings;
                      final blockedFoldersAndFiles = [
                        ...filterSettings.blockedFolderNames,
                        ...filterSettings.blockedFileNames,
                      ].join(', ');

                      return _SettingsCard(
                        title: 'File Inclusion / Exclusion Rules',
                        children: [
                          _SettingsTextFieldRow(
                            label: 'Exclude files with these extensions',
                            value: filterSettings.blockedExtensions.join(', '),
                            onChanged: fileExplorerCubit.updateBlockedExtensions,
                            hintText: 'e.g., .exe, .dll, .png, .jpg (comma-separated)',
                          ),
                          SizedBox(height: md.space.large(context)),
                          _SettingsTextFieldRow(
                            label: 'Exclude folders or files by name',
                            value: blockedFoldersAndFiles,
                            onChanged: fileExplorerCubit.updateBlockedFoldersAndFiles,
                            hintText:
                                'e.g., node_modules, .git, package-lock.json (comma-separated)',
                          ),
                          SizedBox(height: md.space.large(context)),
                          _SettingsToggleRow(
                            label: 'Show hidden files/folders',
                            value: filterSettings.includeHiddenFiles,
                            onChanged: fileExplorerCubit.toggleIncludeHiddenFiles,
                          ),
                        ],
                      );
                    },
                  ),
                  _SettingsCard(
                    title: 'Token Limit Awareness',
                    children: [
                      _SettingsTextFieldRow(
                        label: 'Set Max Token Count (optional)',
                        value: settings.maxTokenCount.toString(),
                        onChanged: settingsCubit.updateMaxTokenCount,
                        isNumeric: true,
                      ),
                    ],
                  ),
                  _SettingsCard(
                    title: 'Content Options',
                    children: [
                      _SettingsToggleRow(
                        label: 'Strip comments from code?',
                        value: settings.stripComments,
                        onChanged: settingsCubit.toggleStripComments,
                      ),
                    ],
                  ),
                  _SettingsCard(
                    title: 'Language & Theme Preferences',
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Theme', style: md.typ.getBodyMedium(context)),
                          SizedBox(
                            width: 150,
                            child: DropdownButtonFormField<ThemeMode>(
                              initialValue: themeState.themeMode,
                              items: const [
                                DropdownMenuItem(
                                  value: ThemeMode.system,
                                  child: Text('System'),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.light,
                                  child: Text('Light'),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.dark,
                                  child: Text('Dark'),
                                ),
                              ],
                              onChanged: (mode) {
                                if (mode != null) {
                                  themeCubit.setThemeMode(mode);
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: md.sys.surfaceContainerHighest,
                                border: OutlineInputBorder(
                                  borderRadius: md.sha.borderRadiusSmall,
                                  borderSide: BorderSide(color: md.sys.outline),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              dropdownColor: md.sys.surfaceContainerHighest,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _SettingsCard(
                    title: 'App Behavior & Performance',
                    children: [
                      _SettingsToggleRow(
                        label: 'Warn if export exceeds X tokens',
                        value: settings.warnOnTokenLimit,
                        onChanged: settingsCubit.toggleWarnOnTokenLimit,
                      ),
                    ],
                  ),
                  _SettingsCard(
                    title: 'Reset Settings',
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: settingsCubit.resetToDefaults,
                          child: Text(
                            'Reset to defaults',
                            style: md.typ
                                .getLabelLarge(context)
                                .copyWith(color: md.sys.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final md = MdTheme.of(context);
    return Card(
      color: md.sys.surfaceContainer,
      elevation: md.elevation.level1,
      shape: md.sha.shapeMedium,
      margin: EdgeInsets.only(bottom: md.space.large(context)),
      child: Padding(
        padding: md.space.allMedium(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: md.typ.getTitleMedium(context),
            ),
            SizedBox(height: md.space.medium(context)),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  const _SettingsToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final md = MdTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: md.typ.getBodyMedium(context)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: md.sys.primary,
          inactiveTrackColor: md.sys.surfaceVariant,
        ),
      ],
    );
  }
}

class _SettingsTextFieldRow extends StatefulWidget {
  const _SettingsTextFieldRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.isNumeric = false,
    this.hintText,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final bool isNumeric;
  final String? hintText;

  @override
  State<_SettingsTextFieldRow> createState() => _SettingsTextFieldRowState();
}

class _SettingsTextFieldRowState extends State<_SettingsTextFieldRow> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onChanged(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _SettingsTextFieldRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final md = MdTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: md.typ.getBodySmall(context)),
        SizedBox(height: md.space.small(context)),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: widget.isNumeric ? TextInputType.number : TextInputType.text,
          style: md.com.textField.textStyle,
          onEditingComplete: () {
            widget.onChanged(_controller.text);
            _focusNode.unfocus();
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: md.sys.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: md.sha.borderRadiusSmall,
              borderSide: BorderSide.none,
            ),
            hintText: widget.hintText,
            hintStyle: md.typ
                .getBodyMedium(context)
                .copyWith(
                  color: md.sys.onSurfaceVariant.withOpacity(0.6),
                ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: md.space.medium(context),
              vertical: md.space.small(context),
            ),
          ),
        ),
      ],
    );
  }
}
