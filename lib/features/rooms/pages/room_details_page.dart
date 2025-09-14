import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../repository/room_repository.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/models/room.dart';

class RoomDetailsPage extends StatefulWidget {
  final String roomId;

  const RoomDetailsPage({
    super.key,
    required this.roomId,
  });

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  final RoomRepository _roomRepository = getIt<RoomRepository>();
  Room? room;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadRoomDetails();
  }

  Future<void> _loadRoomDetails() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      
      final roomData = await _roomRepository.getRoomById(widget.roomId);
      setState(() {
        room = Room.fromJson(roomData);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _deleteRoom() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Delete Room'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete room ${room?.roomNumber}?'),
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
        await _roomRepository.deleteRoom(widget.roomId);
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Room ${room?.roomNumber} deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
           if (room != null) ...[
             IconButton(
               icon: const Icon(Icons.edit),
               onPressed: () {
                 context.push('/rooms/edit/${widget.roomId}').then((result) {
                   if (result == true) {
                     _loadRoomDetails();
                   }
                 });
               },
             ),
             IconButton(
               icon: const Icon(Icons.delete),
               onPressed: _deleteRoom,
             ),
           ],
         ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
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
              'Error loading room details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadRoomDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (room == null) {
      return const Center(
        child: Text('Room not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoomHeader(),
          const SizedBox(height: 24),
          _buildRoomInfo(),
          const SizedBox(height: 24),
          _buildAmenities(),
          const SizedBox(height: 24),
          _buildBeds(),
          if (room!.images?.isNotEmpty == true) ...[
              const SizedBox(height: 24),
              _buildImages(),
            ],
        ],
      ),
    );
  }

  Widget _buildRoomHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.hotel,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room ${room!.roomNumber}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Floor ${room!.floor} • ${room!.type.name}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: room!.isVisible ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                room!.isVisible ? 'Visible' : 'Hidden',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Room Number', room!.roomNumber),
            _buildInfoRow('Floor', room!.floor.toString()),
            _buildInfoRow('Type', room!.type.name),
            _buildInfoRow('Status', room!.isVisible ? 'Visible' : 'Hidden'),
            if (room!.extraAmenities.isNotEmpty)
               _buildInfoRow('Extra Amenities', room!.extraAmenities),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amenities',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildAmenityChip('Geyser', room!.hasGeyser),
                _buildAmenityChip('AC', room!.hasAc),
                _buildAmenityChip(
                  room!.sofaSetQuantity != null
                      ? 'Sofa Set (${room!.sofaSetQuantity})'
                      : 'Sofa Set',
                  room!.hasSofaSet,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityChip(String label, bool available) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: available ? Colors.green[700] : Colors.red[700],
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: available ? Colors.green[50] : Colors.red[50],
      side: BorderSide(
        color: available ? Colors.green[200]! : Colors.red[200]!,
      ),
    );
  }

  Widget _buildBeds() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beds (${room!.beds.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...room!.beds.map((bed) => _buildBedItem(bed)),
          ],
        ),
      ),
    );
  }

  Widget _buildBedItem(Bed bed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bed,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                   '${bed.type.name} (${bed.quantity})',
                   style: const TextStyle(fontWeight: FontWeight.w500),
                 ),
              ],
            ),
          ),
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
             decoration: BoxDecoration(
               color: Colors.blue[100],
               borderRadius: BorderRadius.circular(12),
             ),
             child: Text(
               'Qty: ${bed.quantity}',
               style: TextStyle(
                 color: Colors.blue[700],
                 fontSize: 12,
                 fontWeight: FontWeight.bold,
               ),
             ),
           ),
        ],
      ),
    );
  }

  Widget _buildImages() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
               'Images (${room!.images?.length ?? 0})',
               style: Theme.of(context).textTheme.titleMedium?.copyWith(
                 fontWeight: FontWeight.bold,
               ),
             ),
             const SizedBox(height: 12),
             SizedBox(
               height: 120,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: room!.images?.length ?? 0,
                 itemBuilder: (context, index) {
                   final image = room!.images![index];
                   return Container(
                     margin: const EdgeInsets.only(right: 8),
                     width: 120,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(8),
                       border: Border.all(color: Colors.grey[300]!),
                     ),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(8),
                       child: Image.network(
                         image.url,
                         fit: BoxFit.cover,
                         errorBuilder: (context, error, stackTrace) {
                           return Container(
                             color: Colors.grey[200],
                             child: const Icon(
                               Icons.image_not_supported,
                               color: Colors.grey,
                             ),
                           );
                         },
                       ),
                     ),
                   );
                 },
               ),
             ),
          ],
        ),
      ),
    );
  }
}
