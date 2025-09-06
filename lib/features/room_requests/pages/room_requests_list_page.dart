import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:utara_app/features/room_requests/stores/room_requests_store.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';

class RoomRequestsListPage extends StatelessWidget {
  const RoomRequestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<RoomRequestsStore>(
      create: (_) =>
          RoomRequestsStore(RoomRequestRepository())..fetchRoomRequests(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Room Requests'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Observer(
                builder: (context) {
                  final store = Provider.of<RoomRequestsStore>(context);

                  if (store.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (store.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${store.errorMessage}',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => store.fetchRoomRequests(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (store.roomRequests.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.inbox, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No room requests found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  // Grid view for larger screens, list view for smaller screens
                  return constraints.maxWidth > 600
                      ? _buildGridView(context, store)
                      : _buildListView(context, store);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, RoomRequestsStore store) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return ListView.separated(
      itemCount: store.roomRequests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final req = store.roomRequests[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: req.isPending
                  ? Colors.orange[100]
                  : req.isApproved
                      ? Colors.green[100]
                      : Colors.red[100],
              child: Icon(
                Icons.meeting_room,
                color: req.isPending
                    ? Colors.orange
                    : req.isApproved
                        ? Colors.green
                        : Colors.red,
              ),
            ),
            title: Text(
              'Request by: ${req.name}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildInfoRow(context, Icons.calendar_today,
                    'Check-in: ${dateFormat.format(req.checkInDate.toLocal())}'),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.calendar_today,
                    'Check-out: ${dateFormat.format(req.checkOutDate.toLocal())}'),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.email, 'Email: ${req.user.email}'),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.phone, 'Phone: ${req.user.phone}'),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.person, 'Name: ${req.user.name}'),
                const SizedBox(height: 4),
                _buildInfoRow(
                    context, Icons.person, 'User Name: ${req.user.userName}'),
                const SizedBox(height: 4),
                _buildInfoRow(
                    context, Icons.person, 'User Type: ${req.user.userType}'),
                const SizedBox(height: 4),
                _buildStatusChip(context, req.status.name),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              // Only allow processing if the request is still pending
              if (req.isPending) {
                context
                    .push('/room-requests/${req.id}/process', extra: req)
                    .then((value) {
                  store.fetchRoomRequests();
                });
              } else {
                // Show a snackbar informing the user that the request is already processed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'This request has already been ${req.status.name.toLowerCase()}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, RoomRequestsStore store) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: store.roomRequests.length,
      itemBuilder: (context, index) {
        final req = store.roomRequests[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Only allow processing if the request is still pending
              if (req.isPending) {
                context
                    .push('/room-requests/${req.id}/process', extra: req)
                    .then((v) {
                  store.fetchRoomRequests();
                });
              } else {
                // Show a snackbar informing the user that the request is already processed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'This request has already been ${req.status.name.toLowerCase()}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: req.isPending
                            ? Colors.orange[100]
                            : req.isApproved
                                ? Colors.green[100]
                                : Colors.red[100],
                        child: Icon(
                          Icons.meeting_room,
                          color: req.isPending
                              ? Colors.orange
                              : req.isApproved
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Request by: ${req.name}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(context, Icons.calendar_today,
                      'Check-in: ${dateFormat.format(req.checkInDate.toLocal())}'),
                  const SizedBox(height: 4),
                  _buildInfoRow(context, Icons.calendar_today,
                      'Check-out: ${dateFormat.format(req.checkOutDate.toLocal())}'),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      context, Icons.email, 'Email: ${req.user.email}'),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      context, Icons.phone, 'Phone: ${req.user.phone}'),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      context, Icons.person, 'Name: ${req.user.name}'),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      context, Icons.person, 'User Name: ${req.user.userName}'),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                      context, Icons.person, 'User Type: ${req.user.userType}'),
                  const Spacer(),
                  _buildStatusChip(context, req.status.name),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'approved':
        chipColor = Colors.green;
        break;
      case 'rejected':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      backgroundColor: chipColor,
      label: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
