import 'package:flutter/material.dart';
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/features/rooms/repository/room_repository.dart';
import 'package:utara_app/features/rooms/pages/room_list_page.dart';

class FloorSelectionPage extends StatefulWidget {
  final String building;

  const FloorSelectionPage({
    super.key,
    required this.building,
  });

  @override
  State<FloorSelectionPage> createState() => _FloorSelectionPageState();
}

class _FloorSelectionPageState extends State<FloorSelectionPage> {
  final RoomRepository _roomRepository = getIt<RoomRepository>();
  List<int> _floors = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFloors();
  }

  Future<void> _loadFloors() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _roomRepository.getFloors(widget.building);
      setState(() {
        _floors = List<int>.from(response['floors'] ?? []);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onFloorSelected(int floor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomListPage(
          building: widget.building,
          floor: floor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Floor - ${widget.building}'),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading floors',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadFloors,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _floors.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.layers_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No floors found for ${widget.building}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose a floor in ${widget.building}:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _floors.length,
                              itemBuilder: (context, index) {
                                final floor = _floors[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.layers,
                                      color: Colors.green,
                                    ),
                                    title: Text(
                                      'Floor $floor',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_ios),
                                    onTap: () => _onFloorSelected(floor),
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
