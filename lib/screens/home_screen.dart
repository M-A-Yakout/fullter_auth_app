import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'dart:math';

// Settings Provider
final settingsProvider = StateNotifierProvider<SettingsController, AppSettings>((ref) {
  return SettingsController();
});

// App Settings Model
class AppSettings {
  final bool isDarkMode;
  final bool enableNotifications;
  final String language;

  AppSettings({
    this.isDarkMode = false,
    this.enableNotifications = true,
    this.language = 'English',
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? enableNotifications,
    String? language,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      language: language ?? this.language,
    );
  }
}

// Settings Controller
class SettingsController extends StateNotifier<AppSettings> {
  SettingsController() : super(AppSettings());

  void toggleDarkMode(bool value) {
    state = state.copyWith(isDarkMode: value);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(enableNotifications: value);
  }

  void changeLanguage(String language) {
    state = state.copyWith(language: language);
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final settingsController = ref.watch(settingsProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final currentUser = authService.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6366F1),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {
                authService.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // User Profile Header with gradient
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profile Avatar with status indicator
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: Color(0xFFF3F4F6),
                          child: Icon(
                            Icons.person_rounded,
                            size: 50,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // User Info
                  Text(
                    currentUser?.username ?? 'Welcome, Guest',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentUser?.email ?? 'Please log in to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Metrics and Quick Actions
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions & Metrics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildMetricCard(
                          context,
                          icon: Icons.analytics_rounded,
                          title: 'Total Logins',
                          value: '${Random().nextInt(1000)}',
                          color: const Color(0xFF6366F1),
                        ),
                        _buildMetricCard(
                          context,
                          icon: Icons.access_time_rounded,
                          title: 'Active Time',
                          value: '${Random().nextInt(24)} hrs',
                          color: const Color(0xFF8B5CF6),
                        ),
                        _buildSettingsCard(
                          context,
                          icon: Icons.settings_rounded,
                          title: 'Settings',
                          settings: settings,
                          onDarkModeToggle: (value) {
                            settingsController.toggleDarkMode(value);
                          },
                          onNotificationsToggle: (value) {
                            settingsController.toggleNotifications(value);
                          },
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.help_rounded,
                          title: 'Help Center',
                          subtitle: 'Get support',
                          color: const Color(0xFF10B981),
                          onTap: () {
                            _showFeatureSnackBar(context, 'Help Center');
                          },
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.security_rounded,
                          title: 'Security',
                          subtitle: 'Privacy settings',
                          color: const Color(0xFFEF4444),
                          onTap: () {
                            _showFeatureSnackBar(context, 'Security');
                          },
                        ),
                        _buildMenuCard(
                          context,
                          icon: Icons.account_circle_rounded,
                          title: 'Profile',
                          subtitle: 'Manage account',
                          color: const Color(0xFFEC4899),
                          onTap: () {
                            _showFeatureSnackBar(context, 'Profile');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Metric Card with interactive design
  Widget _buildMetricCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Optional: Add interaction for metrics
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 40),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Settings Card with toggles
  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required AppSettings settings,
    required ValueChanged<bool> onDarkModeToggle,
    required ValueChanged<bool> onNotificationsToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF10B981), size: 30),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF10B981),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSettingsToggle(
                'Dark Mode',
                settings.isDarkMode,
                onDarkModeToggle,
              ),
              const SizedBox(height: 8),
              _buildSettingsToggle(
                'Notifications',
                settings.enableNotifications,
                onNotificationsToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Settings Toggle Widget
  Widget _buildSettingsToggle(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF10B981),
        ),
      ],
    );
  }

  // Existing menu card method remains the same
  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 40),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to show feature unavailable snackbar
  void _showFeatureSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature is not available yet'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}