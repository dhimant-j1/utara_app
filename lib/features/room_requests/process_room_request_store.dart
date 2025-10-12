import 'package:mobx/mobx.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';
import 'package:utara_app/features/rooms/repository/rooms_repository.dart';
import 'package:utara_app/features/rooms/repository/room_repository.dart';
import 'package:utara_app/features/food_passes/repository/food_pass_repository.dart';
import 'package:utara_app/core/models/room_request.dart';
import 'package:utara_app/core/models/room.dart';
import 'package:utara_app/core/di/service_locator.dart';

part 'process_room_request_store.g.dart';

class ProcessRoomRequestStore = _ProcessRoomRequestStore
    with _$ProcessRoomRequestStore;

abstract class _ProcessRoomRequestStore with Store {
  final RoomRequestRepository repository;
  final RoomsRepository roomsRepository;
  final RoomRepository roomRepository;
  final FoodPassRepository foodPassRepository;

  _ProcessRoomRequestStore(this.repository)
    : roomsRepository = RoomsRepository(),
      roomRepository = getIt<RoomRepository>(),
      foodPassRepository = FoodPassRepository();

  @observable
  bool isProcessing = false;

  @observable
  bool isLoadingRooms = false;

  @observable
  bool isGeneratingFoodPasses = false;

  @observable
  String? errorMessage;

  @observable
  String? foodPassMessage;

  @observable
  RoomRequest? processedRequest;

  @observable
  ObservableList<Room> availableRooms = ObservableList<Room>();

  @observable
  Room? selectedRoom;

  @observable
  String? selectedBuilding;

  @observable
  int? selectedFloor;

  @observable
  ObservableList<String> buildings = ObservableList<String>();

  @observable
  ObservableList<int> floors = ObservableList<int>();

  @observable
  bool isLoadingBuildings = false;

  @observable
  bool isLoadingFloors = false;

  @action
  Future<void> fetchBuildings() async {
    isLoadingBuildings = true;
    try {
      final response = await roomRepository.getBuildings();
      buildings = ObservableList.of(
        List<String>.from(response['buildings'] ?? []),
      );
    } catch (e) {
      errorMessage = 'Failed to load buildings: $e';
    } finally {
      isLoadingBuildings = false;
    }
  }

  @action
  Future<void> fetchFloors(String building) async {
    isLoadingFloors = true;
    try {
      final response = await roomRepository.getFloors(building);
      floors = ObservableList.of(List<int>.from(response['floors'] ?? []));
    } catch (e) {
      errorMessage = 'Failed to load floors: $e';
    } finally {
      isLoadingFloors = false;
    }
  }

  @action
  void setBuilding(String? building) {
    selectedBuilding = building;
    selectedFloor = null;
    floors.clear();
    if (building != null) {
      fetchFloors(building);
    }
    fetchAvailableRooms('STANDARD');
  }

  @action
  void setFloor(int? floor) {
    selectedFloor = floor;
    fetchAvailableRooms('STANDARD');
  }

  @action
  Future<void> fetchAvailableRooms(String preferredType) async {
    isLoadingRooms = true;
    errorMessage = null;
    try {
      final rooms = await roomsRepository.fetchAvailableRooms(
        // type: preferredType,
        building: selectedBuilding,
        floor: selectedFloor,
      );
      availableRooms = ObservableList.of(rooms);
    } catch (e) {
      errorMessage = 'Failed to load available rooms: $e';
    } finally {
      isLoadingRooms = false;
    }
  }

  @action
  void selectRoom(Room room) {
    selectedRoom = room;
  }

  @action
  Future<void> processRoomRequest({
    required String requestId,
    required String status,
    String? roomId,
  }) async {
    isProcessing = true;
    errorMessage = null;
    foodPassMessage = null;

    try {
      if (status == 'APPROVED' && roomId == null && selectedRoom != null) {
        roomId = selectedRoom!.id;
      }

      final result = await repository.processRoomRequest(
        requestId: requestId,
        status: status,
        roomId: roomId,
      );
      processedRequest = result;

      // Generate food passes if request is approved
      /* if (status == 'APPROVED' && result.userId.isNotEmpty) {
        await _generateFoodPasses(result);
      } */
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isProcessing = false;
    }
  }

  Future<void> _generateFoodPasses(RoomRequest request) async {
    isGeneratingFoodPasses = true;
    try {
      // Generate member names based on number of people
      final memberNames = List.generate(request.numberOfPeople.total, (index) {
        if (index == 0)
          return 'Guest-${request.name}'; // First guest uses user ID
        return 'Guest-${request.name}-${index + 1}'; // Additional guests get numbered
      });

      final result = await foodPassRepository.generateFoodPasses(
        userId: request.userId,
        memberNames: memberNames,
        startDate: request.checkInDate,
        endDate: request.checkOutDate,
        diningHall:
            'Default Hall', // TODO: Get from room request or configuration
        colorCode: '#FF0000', // TODO: Get from room request or configuration
      );
      foodPassMessage =
          'Generated ${result['total_passes']} food passes for ${request.numberOfPeople} guests';
    } catch (e) {
      errorMessage = 'Request approved but failed to generate food passes: $e';
    } finally {
      isGeneratingFoodPasses = false;
    }
  }
}
