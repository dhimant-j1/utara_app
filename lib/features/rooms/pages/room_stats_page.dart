import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../repository/room_repository.dart';
import '../../../core/di/service_locator.dart';

class RoomStatsPage extends StatefulWidget {
  const RoomStatsPage({super.key});

  @override
  State<RoomStatsPage> createState() => _RoomStatsPageState();
}

class _RoomStatsPageState extends State<RoomStatsPage> {
  final RoomRepository _repository = getIt<RoomRepository>();
  Map<String, dynamic>? _stats;
  String? _error;
  bool _isLoading = true;

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
      setState(() {
        _stats = stats;
        _error = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Statistics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadStats,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadStats,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room Overview',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatsCards(),
                        const SizedBox(height: 24),
                        _buildOccupancyChart(),
                        const SizedBox(height: 24),
                        _buildDetailedStats(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatsCards() {
    final totalRooms = _stats?['total_rooms'] ?? 0;
    final occupiedRooms = _stats?['occupied_rooms'] ?? 0;
    final availableRooms = _stats?['available_rooms'] ?? 0;
    final occupancyRate = totalRooms > 0 ? (occupiedRooms / totalRooms * 100) : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isWide ? 1.2 : 1.0,
          children: [
            _buildStatCard(
              'Total Rooms',
              totalRooms.toString(),
              Icons.meeting_room,
              Colors.blue,
            ),
            _buildStatCard(
              'Occupied',
              occupiedRooms.toString(),
              Icons.person,
              Colors.red,
            ),
            _buildStatCard(
              'Available',
              availableRooms.toString(),
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatCard(
              'Occupancy Rate',
              '${occupancyRate.toStringAsFixed(1)}%',
              Icons.analytics,
              Colors.orange,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOccupancyChart() {
    final totalRooms = _stats?['total_rooms'] ?? 0;
    final occupiedRooms = _stats?['occupied_rooms'] ?? 0;
    final availableRooms = _stats?['available_rooms'] ?? 0;

    if (totalRooms == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No room data available'),
          ),
        ),
      );
    }

    final occupiedPercentage = (occupiedRooms / totalRooms);
    final availablePercentage = (availableRooms / totalRooms);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room Occupancy',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  if (occupiedPercentage > 0)
                    Expanded(
                      flex: (occupiedPercentage * 100).round(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10),
                            bottomLeft: const Radius.circular(10),
                            topRight: availablePercentage == 0 ? const Radius.circular(10) : Radius.zero,
                            bottomRight: availablePercentage == 0 ? const Radius.circular(10) : Radius.zero,
                          ),
                        ),
                      ),
                    ),
                  if (availablePercentage > 0)
                    Expanded(
                      flex: (availablePercentage * 100).round(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topLeft: occupiedPercentage == 0 ? const Radius.circular(10) : Radius.zero,
                            bottomLeft: occupiedPercentage == 0 ? const Radius.circular(10) : Radius.zero,
                            topRight: const Radius.circular(10),
                            bottomRight: const Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Occupied', Colors.red, occupiedRooms, occupiedPercentage),
                _buildLegendItem('Available', Colors.green, availableRooms, availablePercentage),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count, double percentage) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$count (${(percentage * 100).toStringAsFixed(1)}%)',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Total Rooms', _stats?['total_rooms']?.toString() ?? '0'),
            _buildDetailRow('Occupied Rooms', _stats?['occupied_rooms']?.toString() ?? '0'),
            _buildDetailRow('Available Rooms', _stats?['available_rooms']?.toString() ?? '0'),
            const Divider(),
            _buildDetailRow(
              'Occupancy Rate',
              '${(_stats?['total_rooms'] != null && _stats!['total_rooms'] > 0 ? (_stats!['occupied_rooms'] / _stats!['total_rooms'] * 100) : 0.0).toStringAsFixed(1)}%',
            ),
            _buildDetailRow(
              'Availability Rate',
              '${(_stats?['total_rooms'] != null && _stats!['total_rooms'] > 0 ? (_stats!['available_rooms'] / _stats!['total_rooms'] * 100) : 0.0).toStringAsFixed(1)}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}