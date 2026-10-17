import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/core/storage/preferences_service.dart';
import 'package:lb_library/core/theme/theme_controller.dart';
import 'package:lb_library/languages/generated/l10n.dart';
import 'package:lb_library/widgets/language_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    this.initialThemeMode,
    this.onThemeChanged,
    this.userName = 'Library User',
    this.email = 'user@example.com',
    this.onLogout,
  });

  final ThemeMode? initialThemeMode;
  final ValueChanged<ThemeMode>? onThemeChanged;
  final String userName;
  final String email;
  final VoidCallback? onLogout;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode _themeMode;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode ?? appThemeController.themeMode;
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    try {
      final enabled = await PreferencesService.instance
          .loadNotificationsEnabled();
      if (!mounted) return;
      setState(() {
        _notificationsEnabled = enabled;
      });
    } on PlatformException catch (error) {
      _showPreferenceError(error);
    } on MissingPluginException catch (error) {
      _showPreferenceError(error);
    } on PreferencesException catch (error) {
      _showPreferenceError(error);
    }
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _primaryColor => Theme.of(context).colorScheme.primary;

  Color get _cardColor => Theme.of(context).cardColor;

  Color get _mutedColor =>
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).settings,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          _buildProfileCard(),
          const SizedBox(height: 24),

          _buildSectionTitle('Account'),
          _buildCard(
            children: [
              _buildTile(
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
                subtitle: 'Manage your profile details',
                onTap: _showPersonalInformation,
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.share_outlined,
                title: 'Share Account',
                subtitle: 'Share your library profile',
                onTap: _shareAccount,
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.history_rounded,
                title: 'Reading History',
                subtitle: 'View your reading activity',
                onTap: () => _showMessage(
                  'Reading History',
                  'Connect this option to your reading history page.',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Appearance'),
          _buildCard(
            children: [
              _buildTile(
                icon: Icons.palette_outlined,
                title: 'Theme',
                subtitle: _themeLabel(_themeMode),
                onTap: _showThemePicker,
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.language_rounded,
                title: S.of(context).language,
                subtitle: appLanguageController.locale.languageCode == 'km'
                    ? 'ខ្មែរ'
                    : 'English',
                onTap: _showLanguagePicker,
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Notifications'),
          _buildCard(
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                secondary: _iconContainer(Icons.notifications_none_rounded),
                title: const Text(
                  'Push Notifications',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Receive reading updates'),
                value: _notificationsEnabled,
                activeThumbColor: _primaryColor,
                onChanged: (value) async {
                  final previousValue = _notificationsEnabled;
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  try {
                    await PreferencesService.instance.saveNotificationsEnabled(
                      value,
                    );
                  } on PlatformException catch (error) {
                    _restoreNotificationPreference(previousValue, error);
                  } on MissingPluginException catch (error) {
                    _restoreNotificationPreference(previousValue, error);
                  } on PreferencesException catch (error) {
                    _restoreNotificationPreference(previousValue, error);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Storage & Privacy'),
          _buildCard(
            children: [
              _buildTile(
                icon: Icons.download_outlined,
                title: 'Downloaded Books',
                subtitle: 'Manage your offline books',
                onTap: () => _showMessage(
                  'Downloaded Books',
                  'Connect this option to your downloaded books page.',
                ),
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.cleaning_services_outlined,
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                onTap: _confirmClearCache,
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy Policy',
                subtitle: 'Learn how your data is used',
                onTap: () => _showMessage(
                  'Privacy Policy',
                  'Add your privacy policy page or website here.',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('About'),
          _buildCard(
            children: [
              _buildTile(
                icon: Icons.info_outline_rounded,
                title: 'About LB Library',
                subtitle: 'Version 1.0.0',
                onTap: () => _showMessage(
                  'LB Library',
                  'Your personal digital library for discovering and '
                      'managing your favorite books.',
                ),
              ),
              _buildDivider(),
              _buildTile(
                icon: Icons.star_outline_rounded,
                title: 'Rate Our App',
                subtitle: 'Tell us what you think',
                onTap: () => _showMessage(
                  'Rate Our App',
                  'Connect this option to your app store listing.',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Logout
          _buildCard(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: _iconContainer(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text('Sign out of your account'),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.red,
                  size: 16,
                ),
                onTap: _confirmLogout,
              ),
            ],
          ),

          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 30,
                  color: _primaryColor.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 8),
                Text(
                  'LB Library',
                  style: TextStyle(
                    color: _mutedColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Read more. Learn more.',
                  style: TextStyle(color: _mutedColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile card
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [_primaryColor, _primaryColor.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back,',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit profile',
            onPressed: _showPersonalInformation,
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: _iconContainer(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: _mutedColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 15,
        color: _mutedColor,
      ),
      onTap: onTap,
    );
  }

  Widget _iconContainer(IconData icon, {Color? color}) {
    final iconColor = color ?? _primaryColor;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 72,
      endIndent: 16,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
      case ThemeMode.system:
        return 'Follow device settings';
    }
  }

  Future<void> _showThemePicker() async {
    // Get the latest theme from your global controller.
    final currentTheme = appThemeController.themeMode;

    final selected = await showModalBottomSheet<ThemeMode>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Theme',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _themeOption(
                  sheetContext,
                  mode: ThemeMode.light,
                  icon: Icons.light_mode_rounded,
                  title: 'Light',
                  currentTheme: currentTheme,
                ),
                _themeOption(
                  sheetContext,
                  mode: ThemeMode.dark,
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark',
                  currentTheme: currentTheme,
                ),
                _themeOption(
                  sheetContext,
                  mode: ThemeMode.system,
                  icon: Icons.settings_brightness_rounded,
                  title: 'System default',
                  currentTheme: currentTheme,
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null || !mounted) return;

    // Update the global app theme.
    try {
      await appThemeController.setThemeMode(selected);
    } on PlatformException catch (error) {
      _showPreferenceError(error);
      return;
    } on MissingPluginException catch (error) {
      _showPreferenceError(error);
      return;
    } on PreferencesException catch (error) {
      _showPreferenceError(error);
      return;
    }

    // Update the selected option displayed on this page.
    setState(() {
      _themeMode = selected;
    });
  }

  Widget _themeOption(
    BuildContext sheetContext, {
    required ThemeMode mode,
    required IconData icon,
    required String title,
    required ThemeMode currentTheme,
  }) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor),
      title: Text(title),
      trailing: currentTheme == mode
          ? Icon(Icons.check_circle_rounded, color: _primaryColor)
          : const Icon(Icons.circle_outlined),
      onTap: () {
        Navigator.pop(sheetContext, mode);
      },
    );
  }

  Future<void> _showLanguagePicker() async {
    final currentLocale = appLanguageController.locale;

    final selected = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(sheetContext).chooseLanguage,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text('English'),
                  trailing: currentLocale.languageCode == 'en'
                      ? Icon(Icons.check_circle_rounded, color: _primaryColor)
                      : null,
                  onTap: () {
                    Navigator.pop(sheetContext, const Locale('en'));
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: const Text('ខ្មែរ (Khmer)'),
                  trailing: currentLocale.languageCode == 'km'
                      ? Icon(Icons.check_circle_rounded, color: _primaryColor)
                      : null,
                  onTap: () {
                    Navigator.pop(sheetContext, const Locale('km'));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null || !mounted) return;

    try {
      await appLanguageController.setLocale(selected);
    } on PlatformException catch (error) {
      _showPreferenceError(error);
    } on MissingPluginException catch (error) {
      _showPreferenceError(error);
    } on PreferencesException catch (error) {
      _showPreferenceError(error);
    }
  }

  // Share account
  Future<void> _shareAccount() async {
    final message =
        'Check out my LB Library account!\n'
        'Name: ${widget.userName}\n'
        'Email: ${widget.email}';

    await Clipboard.setData(ClipboardData(text: message));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account details copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Personal information
  void _showPersonalInformation() {
    _showMessage(
      'Personal Information',
      'Connect this option to your profile editing page.',
    );
  }

  // Clear cache confirmation
  Future<void> _confirmClearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear Cache?'),
          content: const Text('Do you want to clear temporary app files?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      _showMessage(
        'Clear Cache',
        'Connect this action to your cache management service.',
      );
    }
  }

  // Logout confirmation
  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 40),
          title: const Text('Logout?'),
          content: const Text(
            'Are you sure you want to log out of your account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !mounted) return;

    context.goNamed(AppRoute.login);
  }

  void _restoreNotificationPreference(bool value, Object error) {
    if (!mounted) return;
    setState(() {
      _notificationsEnabled = value;
    });
    _showPreferenceError(error);
  }

  void _showPreferenceError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not save app preference: $error')),
    );
  }

  void _showMessage(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
