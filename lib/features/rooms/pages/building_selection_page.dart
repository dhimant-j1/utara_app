import 'package:flutter/material.dart';
import 'package:utara_app/core/di/service_locator.dart';
import 'package:utara_app/features/rooms/repository/room_repository.dart';
import 'package:utara_app/features/rooms/pages/floor_selection_page.dart';

class BuildingSelectionPage extends StatefulWidget {
  const BuildingSelectionPage({super.key});

  @override
  State<BuildingSelectionPage> createState() => _BuildingSelectionPageState();
}

class _BuildingSelectionPageState extends State<BuildingSelectionPage> {
  final RoomRepository _roomRepository = getIt<RoomRepository>();
  List<String> _buildings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBuildings();
  }

  Future<void> _loadBuildings() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await _roomRepository.getBuildings();
      setState(() {
        _buildings = List<String>.from(response['buildings'] ?? []);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onBuildingSelected(String building) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FloorSelectionPage(building: building),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Building'),
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
                        'Error loading buildings',
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
                        onPressed: _loadBuildings,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildings.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No buildings found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
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
                            'Choose a building to view rooms:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _buildings.length,
                              itemBuilder: (context, index) {
                                final building = _buildings[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.business,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      building,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_ios),
                                    onTap: () => _onBuildingSelected(building),
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
