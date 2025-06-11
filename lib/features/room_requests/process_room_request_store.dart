import 'package:mobx/mobx.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';
import 'package:utara_app/features/rooms/repository/rooms_repository.dart';
import 'package:utara_app/core/models/room_request.dart';
import 'package:utara_app/core/models/room.dart';

part 'process_room_request_store.g.dart';

class ProcessRoomRequestStore = _ProcessRoomRequestStore
    with _$ProcessRoomRequestStore;

abstract class _ProcessRoomRequestStore with Store {
  final RoomRequestRepository repository;
  final RoomsRepository roomsRepository;

  _ProcessRoomRequestStore(this.repository)
      : roomsRepository = RoomsRepository();

  @observable
  bool isProcessing = false;

  @observable
  bool isLoadingRooms = false;

  @observable
  String? errorMessage;

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
    if (status == 'APPROVED' && roomId == null && selectedRoom != null) {
      roomId = selectedRoom!.id;
    }

    isProcessing = true;
    errorMessage = null;
    try {
      final result = await repository.processRoomRequest(
        requestId: requestId,
        status: status,
        roomId: roomId,
      );
      processedRequest = result;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isProcessing = false;
    }
  }
}
