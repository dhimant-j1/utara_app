import 'package:mobx/mobx.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';
import 'package:utara_app/core/models/room_request.dart';

part 'room_requests_store.g.dart';

class RoomRequestsStore = _RoomRequestsStore with _$RoomRequestsStore;

abstract class _RoomRequestsStore with Store {
  final RoomRequestRepository repository;

  _RoomRequestsStore(this.repository);

  @observable
  ObservableList<RoomRequest> roomRequests = ObservableList<RoomRequest>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> fetchRoomRequests({String? status, String? userId}) async {
    isLoading = true;
    errorMessage = null;
    try {
      final requests =
          await repository.fetchRoomRequests(status: status, userId: userId);
      roomRequests = ObservableList.of(requests);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
