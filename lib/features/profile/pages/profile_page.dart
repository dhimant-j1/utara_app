import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../core/stores/auth_store.dart';
import '../../../core/models/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = GetIt.instance<AuthStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Observer(
        builder: (_) {
          final user = authStore.currentUser;

          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: 800), // Adjust max width as needed
                    child: Column(
                      children: [
                        // Profile Header
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  user.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Chip(
                                  label: Text(_getRoleDisplayName(user.role)),
                                  backgroundColor: _getRoleColor(user.role),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                ),
                                if (user.isImportant) ...[
                                  const SizedBox(height: 8),
                                  const Chip(
                                    label: Text('Important User'),
                                    backgroundColor: Colors.orange,
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Profile Information
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profile Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                _ProfileInfoItem(
                                  icon: Icons.badge,
                                  label: 'User ID',
                                  value: user.id,
                                ),
                                const Divider(),
                                _ProfileInfoItem(
                                  icon: Icons.badge,
                                  label: 'User Name',
                                  value: user.username.isNotEmpty
                                      ? user.username
                                      : 'N/A',
                                ),
                                const Divider(),
                                _ProfileInfoItem(
                                  icon: Icons.email,
                                  label: 'Email',
                                  value: user.email,
                                ),
                                const Divider(),
                                _ProfileInfoItem(
                                  icon: Icons.phone,
                                  label: 'Phone Number',
                                  value: user.phoneNumber,
                                ),
                                const Divider(),
                                _ProfileInfoItem(
                                  icon: Icons.admin_panel_settings,
                                  label: 'Role',
                                  value: _getRoleDisplayName(user.role),
                                ),
                                const Divider(),
                                _ProfileInfoItem(
                                  icon: Icons.calendar_today,
                                  label: 'Member Since',
                                  value: DateFormat('MMM dd, yyyy')
                                      .format(user.createdAt),
                                ),
                                const Divider(),
                                _ProfileInfoItem(
                                  icon: Icons.update,
                                  label: 'Last Updated',
                                  value: DateFormat('MMM dd, yyyy - HH:mm')
                                      .format(user.updatedAt),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Actions
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Actions',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                ListTile(
                                  leading: const Icon(Icons.dashboard),
                                  title: const Text('Go to Dashboard'),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  onTap: () => context.go('/dashboard'),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.logout,
                                      color: Colors.red),
                                  title: const Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      color: Colors.red),
                                  onTap: () =>
                                      _showLogoutDialog(context, authStore),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.staff:
        return 'Staff';
      case UserRole.user:
        return 'User';
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return Colors.purple;
      case UserRole.staff:
        return Colors.blue;
      case UserRole.user:
        return Colors.green;
    }
  }

  void _showLogoutDialog(BuildContext context, AuthStore authStore) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authStore.logout();
              if (context.mounted) {
                context.go('/auth/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
