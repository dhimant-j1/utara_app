// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_requests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RoomRequestsStore on _RoomRequestsStore, Store {
  late final _$roomRequestsAtom =
      Atom(name: '_RoomRequestsStore.roomRequests', context: context);

  @override
  ObservableList<RoomRequest> get roomRequests {
    _$roomRequestsAtom.reportRead();
    return super.roomRequests;
  }

  @override
  set roomRequests(ObservableList<RoomRequest> value) {
    _$roomRequestsAtom.reportWrite(value, super.roomRequests, () {
      super.roomRequests = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_RoomRequestsStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_RoomRequestsStore.errorMessage', context: context);

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

  late final _$fetchRoomRequestsAsyncAction =
      AsyncAction('_RoomRequestsStore.fetchRoomRequests', context: context);

  @override
  Future<void> fetchRoomRequests({String? status, String? userId}) {
    return _$fetchRoomRequestsAsyncAction
        .run(() => super.fetchRoomRequests(status: status, userId: userId));
  }

  late final _$checkInCheckOutAsyncAction =
      AsyncAction('_RoomRequestsStore.checkInCheckOut', context: context);

  @override
  Future<void> checkInCheckOut({RoomRequest? req}) {
    return _$checkInCheckOutAsyncAction
        .run(() => super.checkInCheckOut(req: req));
  }

  @override
  String toString() {
    return '''
roomRequests: ${roomRequests},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
