import 'package:mobx/mobx.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';
import 'package:utara_app/core/models/room_request.dart';

part 'process_room_request_store.g.dart';

class ProcessRoomRequestStore = _ProcessRoomRequestStore
    with _$ProcessRoomRequestStore;

abstract class _ProcessRoomRequestStore with Store {
  final RoomRequestRepository repository;

  _ProcessRoomRequestStore(this.repository);

  @observable
  bool isProcessing = false;

  @observable
  String? errorMessage;

  @observable
  RoomRequest? processedRequest;

  @action
  Future<void> processRoomRequest({
    required String requestId,
    required String status, // 'APPROVED' or 'REJECTED'
    String? roomId,
  }) async {
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
