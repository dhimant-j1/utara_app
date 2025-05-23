import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../../core/stores/auth_store.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = GetIt.instance<AuthStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  context.go('/profile');
                  break;
                case 'logout':
                  await authStore.logout();
                  if (context.mounted) {
                    context.go('/auth/login');
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Observer(
        builder: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${authStore.currentUser?.name ?? 'User'}!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Role: ${_getRoleDisplayName(authStore.currentUser?.role)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Main Actions Grid
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // Rooms
                  _DashboardCard(
                    icon: Icons.hotel,
                    title: 'Rooms',
                    subtitle: 'Browse available rooms',
                    onTap: () => context.go('/rooms'),
                  ),

                  // Room Requests
                  _DashboardCard(
                    icon: Icons.book_online,
                    title: 'Room Requests',
                    subtitle: authStore.canProcessRequests 
                        ? 'Manage room requests'
                        : 'My room requests',
                    onTap: () => context.go('/room-requests'),
                  ),

                  // Food Passes
                  _DashboardCard(
                    icon: Icons.restaurant,
                    title: 'Food Passes',
                    subtitle: authStore.canManageFoodPasses 
                        ? 'Manage food passes'
                        : 'My food passes',
                    onTap: () => context.go('/food-passes'),
                  ),

                  // Create Room Request
                  _DashboardCard(
                    icon: Icons.add_box,
                    title: 'Request Room',
                    subtitle: 'Create new room request',
                    onTap: () => context.go('/room-requests/create'),
                  ),
                ],
              ),

              // Admin/Staff Only Section
              if (authStore.canManageRooms) ...[
                const SizedBox(height: 32),
                Text(
                  'Management',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    // Create Room
                    _DashboardCard(
                      icon: Icons.add_home,
                      title: 'Create Room',
                      subtitle: 'Add new room',
                      onTap: () => context.go('/rooms/create'),
                    ),

                    // Room Statistics
                    _DashboardCard(
                      icon: Icons.analytics,
                      title: 'Room Stats',
                      subtitle: 'View room statistics',
                      onTap: () => context.go('/rooms/stats'),
                    ),

                    // Generate Food Passes
                    _DashboardCard(
                      icon: Icons.qr_code,
                      title: 'Generate Passes',
                      subtitle: 'Create food passes',
                      onTap: () => context.go('/food-passes/generate'),
                    ),

                    // Scan Food Pass
                    _DashboardCard(
                      icon: Icons.qr_code_scanner,
                      title: 'Scan Pass',
                      subtitle: 'Scan food passes',
                      onTap: () => context.go('/food-passes/scan'),
                    ),
                  ],
                ),
              ],

              // Admin Only Section
              if (authStore.isAdmin) ...[
                const SizedBox(height: 32),
                Text(
                  'Administration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    // Create User Account
                    _DashboardCard(
                      icon: Icons.person_add,
                      title: 'Create User',
                      subtitle: 'Add new user account',
                      onTap: () => context.go('/auth/signup'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getRoleDisplayName(dynamic role) {
    if (role == null) return 'Unknown';
    return role.toString().split('.').last.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    ).trim();
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 