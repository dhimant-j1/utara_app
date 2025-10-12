// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_room_request_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProcessRoomRequestStore on _ProcessRoomRequestStore, Store {
  late final _$isProcessingAtom = Atom(
    name: '_ProcessRoomRequestStore.isProcessing',
    context: context,
  );

  @override
  bool get isProcessing {
    _$isProcessingAtom.reportRead();
    return super.isProcessing;
  }

  @override
  set isProcessing(bool value) {
    _$isProcessingAtom.reportWrite(value, super.isProcessing, () {
      super.isProcessing = value;
    });
  }

  late final _$isLoadingRoomsAtom = Atom(
    name: '_ProcessRoomRequestStore.isLoadingRooms',
    context: context,
  );

  @override
  bool get isLoadingRooms {
    _$isLoadingRoomsAtom.reportRead();
    return super.isLoadingRooms;
  }

  @override
  set isLoadingRooms(bool value) {
    _$isLoadingRoomsAtom.reportWrite(value, super.isLoadingRooms, () {
      super.isLoadingRooms = value;
    });
  }

  late final _$isGeneratingFoodPassesAtom = Atom(
    name: '_ProcessRoomRequestStore.isGeneratingFoodPasses',
    context: context,
  );

  @override
  bool get isGeneratingFoodPasses {
    _$isGeneratingFoodPassesAtom.reportRead();
    return super.isGeneratingFoodPasses;
  }

  @override
  set isGeneratingFoodPasses(bool value) {
    _$isGeneratingFoodPassesAtom.reportWrite(
      value,
      super.isGeneratingFoodPasses,
      () {
        super.isGeneratingFoodPasses = value;
      },
    );
  }

  late final _$errorMessageAtom = Atom(
    name: '_ProcessRoomRequestStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$foodPassMessageAtom = Atom(
    name: '_ProcessRoomRequestStore.foodPassMessage',
    context: context,
  );

  @override
  String? get foodPassMessage {
    _$foodPassMessageAtom.reportRead();
    return super.foodPassMessage;
  }

  @override
  set foodPassMessage(String? value) {
    _$foodPassMessageAtom.reportWrite(value, super.foodPassMessage, () {
      super.foodPassMessage = value;
    });
  }

  late final _$processedRequestAtom = Atom(
    name: '_ProcessRoomRequestStore.processedRequest',
    context: context,
  );

  @override
  RoomRequest? get processedRequest {
    _$processedRequestAtom.reportRead();
    return super.processedRequest;
  }

  @override
  set processedRequest(RoomRequest? value) {
    _$processedRequestAtom.reportWrite(value, super.processedRequest, () {
      super.processedRequest = value;
    });
  }

  late final _$availableRoomsAtom = Atom(
    name: '_ProcessRoomRequestStore.availableRooms',
    context: context,
  );

  @override
  ObservableList<Room> get availableRooms {
    _$availableRoomsAtom.reportRead();
    return super.availableRooms;
  }

  @override
  set availableRooms(ObservableList<Room> value) {
    _$availableRoomsAtom.reportWrite(value, super.availableRooms, () {
      super.availableRooms = value;
    });
  }

  late final _$selectedRoomAtom = Atom(
    name: '_ProcessRoomRequestStore.selectedRoom',
    context: context,
  );

  @override
  Room? get selectedRoom {
    _$selectedRoomAtom.reportRead();
    return super.selectedRoom;
  }

  @override
  set selectedRoom(Room? value) {
    _$selectedRoomAtom.reportWrite(value, super.selectedRoom, () {
      super.selectedRoom = value;
    });
  }

  late final _$selectedBuildingAtom = Atom(
    name: '_ProcessRoomRequestStore.selectedBuilding',
    context: context,
  );

  @override
  String? get selectedBuilding {
    _$selectedBuildingAtom.reportRead();
    return super.selectedBuilding;
  }

  @override
  set selectedBuilding(String? value) {
    _$selectedBuildingAtom.reportWrite(value, super.selectedBuilding, () {
      super.selectedBuilding = value;
    });
  }

  late final _$selectedFloorAtom = Atom(
    name: '_ProcessRoomRequestStore.selectedFloor',
    context: context,
  );

  @override
  int? get selectedFloor {
    _$selectedFloorAtom.reportRead();
    return super.selectedFloor;
  }

  @override
  set selectedFloor(int? value) {
    _$selectedFloorAtom.reportWrite(value, super.selectedFloor, () {
      super.selectedFloor = value;
    });
  }

  late final _$buildingsAtom = Atom(
    name: '_ProcessRoomRequestStore.buildings',
    context: context,
  );

  @override
  ObservableList<String> get buildings {
    _$buildingsAtom.reportRead();
    return super.buildings;
  }

  @override
  set buildings(ObservableList<String> value) {
    _$buildingsAtom.reportWrite(value, super.buildings, () {
      super.buildings = value;
    });
  }

  late final _$floorsAtom = Atom(
    name: '_ProcessRoomRequestStore.floors',
    context: context,
  );

  @override
  ObservableList<int> get floors {
    _$floorsAtom.reportRead();
    return super.floors;
  }

  @override
  set floors(ObservableList<int> value) {
    _$floorsAtom.reportWrite(value, super.floors, () {
      super.floors = value;
    });
  }

  late final _$isLoadingBuildingsAtom = Atom(
    name: '_ProcessRoomRequestStore.isLoadingBuildings',
    context: context,
  );

  @override
  bool get isLoadingBuildings {
    _$isLoadingBuildingsAtom.reportRead();
    return super.isLoadingBuildings;
  }

  @override
  set isLoadingBuildings(bool value) {
    _$isLoadingBuildingsAtom.reportWrite(value, super.isLoadingBuildings, () {
      super.isLoadingBuildings = value;
    });
  }

  late final _$isLoadingFloorsAtom = Atom(
    name: '_ProcessRoomRequestStore.isLoadingFloors',
    context: context,
  );

  @override
  bool get isLoadingFloors {
    _$isLoadingFloorsAtom.reportRead();
    return super.isLoadingFloors;
  }

  @override
  set isLoadingFloors(bool value) {
    _$isLoadingFloorsAtom.reportWrite(value, super.isLoadingFloors, () {
      super.isLoadingFloors = value;
    });
  }

  late final _$fetchBuildingsAsyncAction = AsyncAction(
    '_ProcessRoomRequestStore.fetchBuildings',
    context: context,
  );

  @override
  Future<void> fetchBuildings() {
    return _$fetchBuildingsAsyncAction.run(() => super.fetchBuildings());
  }

  late final _$fetchFloorsAsyncAction = AsyncAction(
    '_ProcessRoomRequestStore.fetchFloors',
    context: context,
  );

  @override
  Future<void> fetchFloors(String building) {
    return _$fetchFloorsAsyncAction.run(() => super.fetchFloors(building));
  }

  late final _$fetchAvailableRoomsAsyncAction = AsyncAction(
    '_ProcessRoomRequestStore.fetchAvailableRooms',
    context: context,
  );

  @override
  Future<void> fetchAvailableRooms(String preferredType) {
    return _$fetchAvailableRoomsAsyncAction.run(
      () => super.fetchAvailableRooms(preferredType),
    );
  }

  late final _$processRoomRequestAsyncAction = AsyncAction(
    '_ProcessRoomRequestStore.processRoomRequest',
    context: context,
  );

  @override
  Future<void> processRoomRequest({
    required String requestId,
    required String status,
    String? roomId,
  }) {
    return _$processRoomRequestAsyncAction.run(
      () => super.processRoomRequest(
        requestId: requestId,
        status: status,
        roomId: roomId,
      ),
    );
  }

  late final _$_ProcessRoomRequestStoreActionController = ActionController(
    name: '_ProcessRoomRequestStore',
    context: context,
  );

  @override
  void setBuilding(String? building) {
    final _$actionInfo = _$_ProcessRoomRequestStoreActionController.startAction(
      name: '_ProcessRoomRequestStore.setBuilding',
    );
    try {
      return super.setBuilding(building);
    } finally {
      _$_ProcessRoomRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFloor(int? floor) {
    final _$actionInfo = _$_ProcessRoomRequestStoreActionController.startAction(
      name: '_ProcessRoomRequestStore.setFloor',
    );
    try {
      return super.setFloor(floor);
    } finally {
      _$_ProcessRoomRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectRoom(Room room) {
    final _$actionInfo = _$_ProcessRoomRequestStoreActionController.startAction(
      name: '_ProcessRoomRequestStore.selectRoom',
    );
    try {
      return super.selectRoom(room);
    } finally {
      _$_ProcessRoomRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isProcessing: ${isProcessing},
isLoadingRooms: ${isLoadingRooms},
isGeneratingFoodPasses: ${isGeneratingFoodPasses},
errorMessage: ${errorMessage},
foodPassMessage: ${foodPassMessage},
processedRequest: ${processedRequest},
availableRooms: ${availableRooms},
selectedRoom: ${selectedRoom},
selectedBuilding: ${selectedBuilding},
selectedFloor: ${selectedFloor},
buildings: ${buildings},
floors: ${floors},
isLoadingBuildings: ${isLoadingBuildings},
isLoadingFloors: ${isLoadingFloors}
    ''';
  }
}
