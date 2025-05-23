import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../repository/room_repository.dart';
import '../../../core/di/service_locator.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  final RoomRepository _repository = getIt<RoomRepository>();
  List<Map<String, dynamic>>? _rooms;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _repository.getRooms();
      setState(() {
        _rooms = rooms;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.meeting_room,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room ${room['room_number']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      Text('Floor: ${room['floor']}'),
                      Text('Type: ${room['type']}'),
                      Text('AC: ${room['has_ac'] ? 'Yes' : 'No'}'),
                      Text('Geyser: ${room['has_geyser'] ? 'Yes' : 'No'}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Room details coming soon')),
                );
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveList(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final padding = isWide
        ? EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15)
        : EdgeInsets.zero;

    return Padding(
      padding: padding,
      child: ListView.builder(
        itemCount: _rooms!.length,
        itemBuilder: (context, index) => _buildRoomCard(_rooms![index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRooms,
          ),
        ],
      ),
      body: _error != null
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
                    onPressed: _loadRooms,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            )
          : _rooms == null
              ? const Center(child: CircularProgressIndicator())
              : _rooms!.isEmpty
                  ? const Center(
                      child: Text('No rooms found'),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadRooms,
                      child: _buildResponsiveList(context),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/rooms/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
