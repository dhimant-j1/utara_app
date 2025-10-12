import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:utara_app/features/room_requests/process_room_request_store.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';
import 'package:utara_app/features/room_requests/stores/room_requests_store.dart';

import '../../../core/di/service_locator.dart';

class ProcessRoomRequestPage extends StatelessWidget {
  final String requestId;

  const ProcessRoomRequestPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Provider<ProcessRoomRequestStore>(
      create: (_) => ProcessRoomRequestStore(RoomRequestRepository(getIt()))
        ..fetchBuildings()
        ..fetchAvailableRooms('STANDARD'),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Process Room Request'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Observer(
              builder: (context) {
                final store = Provider.of<ProcessRoomRequestStore>(context);
                final roomRequestRepository = RoomRequestsStore(
                  RoomRequestRepository(getIt()),
                );

                return Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 800,
                        minHeight: constraints.maxHeight,
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (!store.isProcessing &&
                                      store.processedRequest == null) ...[
                                    const Text(
                                      'Select Building and Floor',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Building and Floor Filters
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              DropdownButtonFormField<String>(
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: 'Building',
                                                      border:
                                                          OutlineInputBorder(),
                                                      prefixIcon: Icon(
                                                        Icons.business,
                                                      ),
                                                    ),
                                                value: store.selectedBuilding,
                                                items: store.buildings
                                                    .map(
                                                      (building) =>
                                                          DropdownMenuItem(
                                                            value: building,
                                                            child: Text(
                                                              building,
                                                            ),
                                                          ),
                                                    )
                                                    .toList(),
                                                onChanged:
                                                    store.isLoadingBuildings
                                                    ? null
                                                    : (value) {
                                                        if (value != null) {
                                                          store.setBuilding(
                                                            value,
                                                          );
                                                        }
                                                      },
                                              ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: DropdownButtonFormField<int>(
                                            decoration: const InputDecoration(
                                              labelText: 'Floor',
                                              border: OutlineInputBorder(),
                                              prefixIcon: Icon(Icons.layers),
                                            ),
                                            value: store.selectedFloor,
                                            items: store.floors
                                                .map(
                                                  (floor) => DropdownMenuItem(
                                                    value: floor,
                                                    child: Text('Floor $floor'),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged:
                                                store.isLoadingFloors ||
                                                    store.selectedBuilding ==
                                                        null
                                                ? null
                                                : (value) {
                                                    if (value != null) {
                                                      store.setFloor(value);
                                                    }
                                                  },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'Available Rooms',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (store.isLoadingRooms)
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    else if (store.availableRooms.isEmpty)
                                      Center(
                                        child: Column(
                                          children: [
                                            const Icon(
                                              Icons.search_off,
                                              size: 48,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              store.selectedBuilding != null ||
                                                      store.selectedFloor !=
                                                          null
                                                  ? 'No available rooms found with selected filters'
                                                  : 'Please select a building to view available rooms',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                          itemCount:
                                              store.availableRooms.length,
                                          itemBuilder: (context, index) {
                                            final room =
                                                store.availableRooms[index];
                                            final isSelected =
                                                store.selectedRoom?.id ==
                                                room.id;
                                            return Card(
                                              color: isSelected
                                                  ? Colors.blue.shade50
                                                  : null,
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.meeting_room,
                                                  color: isSelected
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  size: 32,
                                                ),
                                                title: Text(
                                                  'Room ${room.roomNumber}',
                                                  style: TextStyle(
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'Floor: ${room.floor}\n'
                                                  'Amenities: ${[if (room.hasAc) 'AC', if (room.hasGeyser) 'Geyser', if (room.hasSofaSet) 'Sofa Set'].join(', ')}',
                                                ),
                                                trailing: isSelected
                                                    ? const Icon(
                                                        Icons.check_circle,
                                                        color: Colors.blue,
                                                      )
                                                    : null,
                                                selected: isSelected,
                                                onTap: () =>
                                                    store.selectRoom(room),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.check),
                                          label: const Text('Approve'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 16,
                                            ),
                                          ),
                                          onPressed: store.selectedRoom == null
                                              ? null
                                              : () {
                                                  store
                                                      .processRoomRequest(
                                                        requestId: requestId,
                                                        status: 'APPROVED',
                                                        roomId: store
                                                            .selectedRoom!
                                                            .id,
                                                      )
                                                      .then((v) {
                                                        roomRequestRepository
                                                            .fetchRoomRequests();
                                                      });
                                                },
                                        ),
                                        const SizedBox(width: 16),
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.close),
                                          label: const Text('Reject'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 16,
                                            ),
                                          ),
                                          onPressed: () {
                                            store.processRoomRequest(
                                              requestId: requestId,
                                              status: 'REJECTED',
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (store.errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Text(
                                        store.errorMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  if (store.isProcessing)
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  if (store.processedRequest != null) ...[
                                    Icon(
                                      store.processedRequest!.isApproved
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      size: 64,
                                      color: store.processedRequest!.isApproved
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      store.processedRequest!.isApproved
                                          ? 'Request Approved'
                                          : 'Request Rejected',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall,
                                      textAlign: TextAlign.center,
                                    ),
                                    if (store.processedRequest!.room !=
                                        null) ...[
                                      const SizedBox(height: 16),
                                      Text(
                                        'Room ${store.processedRequest!.room!.roomNumber} assigned',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                    const SizedBox(height: 24),
                                    /*  if (store.isGeneratingFoodPasses)
                                      const Column(
                                        children: [
                                          Text(
                                            'Generating Food Passes...',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          CircularProgressIndicator(),
                                        ],
                                      ),
                                    if (store.foodPassMessage != null) ...[
                                      const SizedBox(height: 16),
                                      Card(
                                        color: Colors.green.shade50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.restaurant_menu,
                                                  color: Colors.green),
                                              const SizedBox(width: 8),
                                              Text(
                                                store.foodPassMessage!,
                                                style: const TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ], */
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () => context.pop(),
                                      child: const Text('Back to Requests'),
                                    ),
                                  ],
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
      ),
    );
  }
}
