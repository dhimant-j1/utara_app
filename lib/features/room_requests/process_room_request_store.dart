import 'package:mobx/mobx.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';
import 'package:utara_app/features/rooms/repository/rooms_repository.dart';
import 'package:utara_app/features/food_passes/repository/food_pass_repository.dart';
import 'package:utara_app/core/models/room_request.dart';
import 'package:utara_app/core/models/room.dart';

part 'process_room_request_store.g.dart';

class ProcessRoomRequestStore = _ProcessRoomRequestStore
    with _$ProcessRoomRequestStore;

abstract class _ProcessRoomRequestStore with Store {
  final RoomRequestRepository repository;
  final RoomsRepository roomsRepository;
  final FoodPassRepository foodPassRepository;

  _ProcessRoomRequestStore(this.repository)
      : roomsRepository = RoomsRepository(),
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

  @action
  Future<void> fetchAvailableRooms(String preferredType) async {
    isLoadingRooms = true;
    errorMessage = null;
    try {
      final rooms =
          await roomsRepository.fetchAvailableRooms(type: preferredType);
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
      if (status == 'APPROVED' && result.userId.isNotEmpty) {
        await _generateFoodPasses(result);
      }
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
      final memberNames = List.generate(request.numberOfPeople, (index) {
        if (index == 0)
          return 'Guest-${request.userId}'; // First guest uses user ID
        return 'Guest-${request.userId}-${index + 1}'; // Additional guests get numbered
      });

      final result = await foodPassRepository.generateFoodPasses(
        userId: request.userId,
        memberNames: memberNames,
        startDate: request.checkInDate,
        endDate: request.checkOutDate,
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
