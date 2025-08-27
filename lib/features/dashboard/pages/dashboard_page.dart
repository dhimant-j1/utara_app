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
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  context.push('/profile');
                  break;
                case 'logout':
                  await authStore.logout();
                  if (context.mounted) {
                    context.push('/auth/login');
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back, ${authStore.currentUser?.name ?? 'User'}!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Role: ${_getRoleDisplayName(authStore.currentUser?.role)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Main Actions Grid
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ResponsiveGrid(
                      crossAxisCount: isWide ? 4 : 2,
                      children: [
                        _DashboardCard(
                          icon: Icons.hotel,
                          title: 'Rooms',
                          subtitle: 'Browse available rooms',
                          onTap: () => context.push('/rooms'),
                        ),
                        _DashboardCard(
                          icon: Icons.book_online,
                          title: 'Room Requests',
                          subtitle: authStore.canProcessRequests
                              ? 'Manage room requests'
                              : 'My room requests',
                          onTap: () => context.push('/room-requests'),
                        ),
                        _DashboardCard(
                          icon: Icons.restaurant,
                          title: 'Food Passes',
                          subtitle: authStore.canManageFoodPasses
                              ? 'Manage food passes'
                              : 'My food passes',
                          onTap: () => context.push(
                              '/food-passes/user/${authStore.currentUser?.id}'),
                        ),
                        /*_DashboardCard(
                          icon: Icons.add_box,
                          title: 'Request Room',
                          subtitle: 'Create new room request',
                          onTap: () => context.push('/room-requests/create'),
                        ),*/
                      ],
                    ),

                    // Admin/Staff Only Section
                    if (authStore.canManageRooms) ...[
                      const SizedBox(height: 40),
                      Text(
                        'Management',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ResponsiveGrid(
                        crossAxisCount: isWide ? 4 : 2,
                        children: [
                          _DashboardCard(
                            icon: Icons.add_home,
                            title: 'Create Room',
                            subtitle: 'Add new room',
                            onTap: () => context.push('/rooms/create'),
                          ),
                          _DashboardCard(
                            icon: Icons.analytics,
                            title: 'Room Stats',
                            subtitle: 'View room statistics',
                            onTap: () => context.push('/rooms/stats'),
                          ),
                          _DashboardCard(
                            icon: Icons.qr_code,
                            title: 'Generate Passes',
                            subtitle: 'Create food passes',
                            onTap: () => context.push('/food-passes/generate'),
                          ),
                          _DashboardCard(
                            icon: Icons.qr_code_scanner,
                            title: 'Scan Pass',
                            subtitle: 'Scan food passes',
                            onTap: () => context.push('/food-passes/scan'),
                          ),
                        ],
                      ),
                    ],

                    // Admin Only Section
                    if (authStore.isAdmin) ...[
                      const SizedBox(height: 40),
                      Text(
                        'Administration',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ResponsiveGrid(
                        crossAxisCount: isWide ? 4 : 2,
                        children: [
                          _DashboardCard(
                            icon: Icons.person_add,
                            title: 'Create User',
                            subtitle: 'Add new user account',
                            onTap: () => context.push('/users/create'),
                          ),
                          _DashboardCard(
                            icon: Icons.upload_file,
                            title: 'Bulk Upload Rooms',
                            subtitle: 'Upload rooms via CSV',
                            onTap: () => context.push('/rooms/bulk-upload'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getRoleDisplayName(dynamic role) {
    if (role == null) return 'Unknown';
    return role
        .toString()
        .split('.')
        .last
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
        )
        .trim();
  }
}

class ResponsiveGrid extends StatelessWidget {
  final int crossAxisCount;
  final List<Widget> children;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.crossAxisCount,
    required this.children,
    this.spacing = 20,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth =
            (width - (crossAxisCount - 1) * spacing) / crossAxisCount;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(children.length, (index) {
            return SizedBox(
              width: itemWidth,
              child: children[index],
            );
          }),
        );
      },
    );
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: Theme.of(context).primaryColor.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
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
