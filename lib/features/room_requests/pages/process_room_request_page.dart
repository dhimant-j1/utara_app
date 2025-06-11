import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:utara_app/features/room_requests/process_room_request_store.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';

class ProcessRoomRequestPage extends StatelessWidget {
  final String requestId;

  const ProcessRoomRequestPage({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<ProcessRoomRequestStore>(
      create: (_) => ProcessRoomRequestStore(RoomRequestRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Process Room Request'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/room-requests'),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Observer(
              builder: (context) {
                final store = Provider.of<ProcessRoomRequestStore>(context);
                // Determine if we should use narrow layout
                final isNarrow = constraints.maxWidth < 600;

                return Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 800,
                        minHeight: constraints.maxHeight,
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.approval,
                                    size: 80,
                                    color: Colors.blueGrey,
                                  ),
                                  const SizedBox(height: 24),
                                  SelectableText(
                                    'Request ID: $requestId',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.blueGrey,
                                        ),
                                  ),
                                  const SizedBox(height: 32),
                                  if (store.errorMessage != null)
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.error_outline,
                                              color: Colors.red),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              store.errorMessage!,
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (store.isProcessing)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 24),
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(height: 16),
                                          Text('Processing request...'),
                                        ],
                                      ),
                                    ),
                                  if (!store.isProcessing &&
                                      store.processedRequest == null)
                                    Flex(
                                      direction: isNarrow
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.check),
                                          label: const Text('Approve Request'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 16,
                                            ),
                                            minimumSize: const Size(180, 50),
                                          ),
                                          onPressed: () {
                                            store.processRoomRequest(
                                              requestId: requestId,
                                              status: 'APPROVED',
                                            );
                                          },
                                        ),
                                        SizedBox(
                                            width: isNarrow ? 0 : 24,
                                            height: isNarrow ? 16 : 0),
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.close),
                                          label: const Text('Reject Request'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 16,
                                            ),
                                            minimumSize: const Size(180, 50),
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
                                  if (store.processedRequest != null)
                                    Column(
                                      children: [
                                        Icon(
                                          store.processedRequest!.isApproved
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color:
                                              store.processedRequest!.isApproved
                                                  ? Colors.green
                                                  : Colors.red,
                                          size: 80,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Request ${store.processedRequest!.isApproved ? 'approved' : 'rejected'} successfully!',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                color: store.processedRequest!
                                                        .isApproved
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 32),
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.list),
                                          label: const Text(
                                              'Back to Request List'),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 16,
                                            ),
                                            minimumSize: const Size(200, 50),
                                          ),
                                          onPressed: () =>
                                              context.go('/room-requests'),
                                        ),
                                      ],
                                    ),
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
