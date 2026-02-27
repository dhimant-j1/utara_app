import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utara_app/utils/const.dart';
import '../../../core/stores/auth_store.dart';
import 'package:utara_app/features/rooms/repository/room_repository.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';
import 'package:utara_app/core/models/room_request.dart';

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
                              backgroundColor: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
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
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Role: ${_getRoleDisplayName(authStore.currentUser?.role)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (authStore.canManageRooms) ...[
                      const SizedBox(height: 32),
                      const _RoomStatsSummary(),
                      const SizedBox(height: 32),
                      const _TodaysCheckouts(),
                    ],
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
                            '/food-passes/user/${authStore.currentUser?.id}',
                          ),
                        ),
                        _DashboardCard(
                          icon: Icons.add_box,
                          title: 'Request Room',
                          subtitle: 'Create new room request',
                          onTap: () => context.push('/room-requests/create'),
                        ),
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
                            onTap: () async {
                              final url = Uri.parse(Const.baseUrl);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                          ),
                          _DashboardCard(
                            icon: Icons.supervised_user_circle_sharp,
                            title: 'Manage Users',
                            subtitle: 'Manage Users type',
                            onTap: () => context.push('/users/manage'),
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
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
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
            return SizedBox(width: itemWidth, child: children[index]);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: Theme.of(context).primaryColor.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.grey[600]),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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

class _RoomStatsSummary extends StatefulWidget {
  const _RoomStatsSummary({Key? key}) : super(key: key);

  @override
  State<_RoomStatsSummary> createState() => _RoomStatsSummaryState();
}

class _RoomStatsSummaryState extends State<_RoomStatsSummary> {
  final _repository = GetIt.instance<RoomRepository>();
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final stats = await _repository.getRoomStats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Failed to load stats: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              IconButton(
                onPressed: _loadStats,
                icon: const Icon(Icons.refresh, color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    final totalRooms = _stats?['total_rooms'] ?? 0;
    final occupiedRooms = _stats?['occupied_rooms'] ?? 0;
    final availableRooms = _stats?['available_rooms'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Room Overview',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadStats,
              tooltip: 'Refresh stats',
            ),
          ],
        ),
        const SizedBox(height: 16),
        ResponsiveGrid(
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 1,
          children: [
            _MiniStatCard(
              title: 'Total Rooms',
              value: totalRooms.toString(),
              icon: Icons.meeting_room,
              color: Colors.blue,
            ),
            _MiniStatCard(
              title: 'Occupied',
              value: occupiedRooms.toString(),
              icon: Icons.person,
              color: Colors.red,
            ),
            _MiniStatCard(
              title: 'Available',
              value: availableRooms.toString(),
              icon: Icons.check_circle,
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodaysCheckouts extends StatefulWidget {
  const _TodaysCheckouts({Key? key}) : super(key: key);

  @override
  State<_TodaysCheckouts> createState() => _TodaysCheckoutsState();
}

class _TodaysCheckoutsState extends State<_TodaysCheckouts> {
  final _repository = GetIt.instance<RoomRequestRepository>();
  List<RoomRequest> _requests = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCheckouts();
  }

  Future<void> _loadCheckouts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final requests = await _repository.fetchRoomRequests(
        status: 'APPROVED',
        checkoutToday: true,
      );
      if (mounted) {
        setState(() {
          _requests = requests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Failed to load today\'s checkouts: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              IconButton(
                onPressed: _loadCheckouts,
                icon: const Icon(Icons.refresh, color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Checkouts (${_requests.length})',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadCheckouts,
              tooltip: 'Refresh list',
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_requests.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No checkouts scheduled for today.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final req = _requests[index];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.meeting_room,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  req.room != null
                                      ? 'Room ${req.room!.roomNumber}'
                                      : 'Room Pending',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            'Name: ${req.user?.name ?? req.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total People: ${req.numberOfPeople.total}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          OutlinedButton(
                            onPressed: () {
                              context
                                  .push(
                                    '/room-requests/${req.id}/process',
                                    extra: req,
                                  )
                                  .then((_) {
                                    _loadCheckouts();
                                  });
                            },
                            child: const Text('View Request'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
