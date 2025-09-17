import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../repository/room_repository.dart';
import '../../../core/di/service_locator.dart';

class RoomListPage extends StatefulWidget {
  final String? building;
  final int? floor;

  const RoomListPage({
    super.key,
    this.building,
    this.floor,
  });

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  final RoomRepository _repository = getIt<RoomRepository>();
  List<Map<String, dynamic>>? _rooms;
  String? _error;
  bool _isLoading = false;

  // Filter parameters
  int? _selectedFloor;
  String? _selectedBuilding;
  String? _selectedType;
  bool? _isVisible;
  bool? _isOccupied;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    // Initialize filters with passed parameters
    if (widget.floor != null) {
      _selectedFloor = widget.floor;
    }
    if (widget.building != null) {
      _selectedBuilding = widget.building;
    }
    _loadRooms();
  }

  String getRoomType(String typeCode) {
    switch (typeCode) {
      case 'SHREEHARIPLUS':
        return 'Shree Hari Plus';
      case 'SHREEHARI':
        return 'Shree Hari';
      case 'SARJUPLUS':
        return 'Sarju Plus';
      case 'SARJU':
        return 'Sarju';
      case 'NEELKANTHPLUS':
        return 'Neelkanth Plus';
      case 'NEELKANTH':
        return 'Neelkanth';
      default:
        return typeCode;
    }
  }

  Future<void> _loadRooms() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final rooms = await _repository.getRooms(
        floor: _selectedFloor,
        building: _selectedBuilding,
        type: _selectedType,
        isVisible: _isVisible,
        isOccupied: _isOccupied,
      );
      setState(() {
        _rooms = rooms;
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

  void _clearFilters() {
    setState(() {
      _selectedFloor = null;
      _selectedType = null;
      _isVisible = null;
      _isOccupied = null;
    });
    _loadRooms();
  }

  bool get _hasActiveFilters {
    return _selectedFloor != null || _selectedType != null || _isVisible != null || _isOccupied != null;
  }

  Future<void> _deleteRoom(Map<String, dynamic> room) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Delete Room'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete room ${room['room_number']}?'),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Deleting room...'),
            ],
          ),
        ),
      );

      try {
        await _repository.deleteRoom(room['id']);
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Room ${room['room_number']} deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadRooms(); // Refresh the list
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete room: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
                      Text('Type: ${getRoomType(room['type'])}'),
                      Text('AC: ${room['has_ac'] ? 'Yes' : 'No'}'),
                      Text('Geyser: ${room['has_geyser'] ? 'Yes' : 'No'}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.go('/rooms/${room['id']}');
                      },
                      child: const Text('View'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/rooms/${room['id']}/edit').then((result) {
                          if (result == true) {
                            _loadRooms();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Edit'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _deleteRoom(room),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: room['is_occupied'] == true ? Colors.red.shade100 : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        room['is_occupied'] == true ? 'Occupied' : 'Available',
                        style: TextStyle(
                          color: room['is_occupied'] == true ? Colors.red.shade700 : Colors.green.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (room['is_visible'] != true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Hidden',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveList(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final padding =
        isWide ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15) : EdgeInsets.zero;

    return Padding(
      padding: padding,
      child: ListView.builder(
        itemCount: _rooms!.length,
        itemBuilder: (context, index) => _buildRoomCard(_rooms![index]),
      ),
    );
  }

  Widget _buildFilterSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showFilters ? null : 0,
      child: _showFilters
          ? Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        if (_hasActiveFilters)
                          TextButton(
                            onPressed: _clearFilters,
                            child: const Text('Clear All'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: 150,
                          child: DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'Floor',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedFloor,
                            items: List.generate(10, (index) => index + 1)
                                .map((floor) => DropdownMenuItem(
                                      value: floor,
                                      child: Text('Floor $floor'),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedFloor = value;
                              });
                              _loadRooms();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Room Type',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedType,
                            items: const [
                              DropdownMenuItem(
                                value: 'SHREEHARIPLUS',
                                child: Text('Shree Hari Plus'),
                              ),
                              DropdownMenuItem(
                                value: 'SHREEHARI',
                                child: Text('Shree Hari'),
                              ),
                              DropdownMenuItem(
                                value: 'SARJUPLUS',
                                child: Text('Sarju Plus'),
                              ),
                              DropdownMenuItem(
                                value: 'SARJU',
                                child: Text('Sarju'),
                              ),
                              DropdownMenuItem(
                                value: 'NEELKANTHPLUS',
                                child: Text('Neelkanth Plus'),
                              ),
                              DropdownMenuItem(
                                value: 'NEELKANTH',
                                child: Text('Neelkanth'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value;
                              });
                              _loadRooms();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: DropdownButtonFormField<bool>(
                            decoration: const InputDecoration(
                              labelText: 'Visibility',
                              border: OutlineInputBorder(),
                            ),
                            value: _isVisible,
                            items: const [
                              DropdownMenuItem(
                                value: true,
                                child: Text('Visible'),
                              ),
                              DropdownMenuItem(
                                value: false,
                                child: Text('Hidden'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _isVisible = value;
                              });
                              _loadRooms();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: DropdownButtonFormField<bool>(
                            decoration: const InputDecoration(
                              labelText: 'Occupancy',
                              border: OutlineInputBorder(),
                            ),
                            value: _isOccupied,
                            items: const [
                              DropdownMenuItem(
                                value: false,
                                child: Text('Available'),
                              ),
                              DropdownMenuItem(
                                value: true,
                                child: Text('Occupied'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _isOccupied = value;
                              });
                              _loadRooms();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.building != null && widget.floor != null
                ? 'Rooms - ${widget.building} Floor ${widget.floor}'
                : 'Rooms'),
            if (_hasActiveFilters) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Filtered',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.building != null && widget.floor != null) {
              // If we came from building/floor selection, go back to building selection
              Navigator.pop(context);
            } else {
              // Otherwise go to dashboard
              context.go('/dashboard');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list : Icons.filter_list_outlined),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRooms,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _error != null
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
                : _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _rooms == null
                        ? const Center(child: CircularProgressIndicator())
                        : _rooms!.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.meeting_room_outlined,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text('No rooms found'),
                                    if (_hasActiveFilters) ...[
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: _clearFilters,
                                        child: const Text('Clear filters'),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadRooms,
                                child: _buildResponsiveList(context),
                              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/rooms/create').then((v) {
          _loadRooms();
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
