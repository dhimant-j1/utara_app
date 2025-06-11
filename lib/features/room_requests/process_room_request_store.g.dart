// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_room_request_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProcessRoomRequestStore on _ProcessRoomRequestStore, Store {
  late final _$isProcessingAtom =
      Atom(name: '_ProcessRoomRequestStore.isProcessing', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: '_ProcessRoomRequestStore.errorMessage', context: context);

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

  late final _$processedRequestAtom =
      Atom(name: '_ProcessRoomRequestStore.processedRequest', context: context);

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

  late final _$processRoomRequestAsyncAction = AsyncAction(
      '_ProcessRoomRequestStore.processRoomRequest',
      context: context);

  @override
  Future<void> processRoomRequest(
      {required String requestId, required String status, String? roomId}) {
    return _$processRoomRequestAsyncAction.run(() => super.processRoomRequest(
        requestId: requestId, status: status, roomId: roomId));
  }

  @override
  String toString() {
    return '''
isProcessing: ${isProcessing},
errorMessage: ${errorMessage},
processedRequest: ${processedRequest}
    ''';
  }
}
