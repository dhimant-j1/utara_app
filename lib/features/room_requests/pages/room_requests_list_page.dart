import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:utara_app/core/models/room_request.dart';
import 'package:utara_app/features/room_requests/stores/room_requests_store.dart';
import 'package:utara_app/features/room_requests/repository/room_request_repository.dart';
import 'package:utara_app/utils/const.dart';

import 'package:utara_app/features/room_requests/pages/edit_room_request_dialog.dart';

import '../../../core/di/service_locator.dart';

class RoomRequestsListPage extends StatelessWidget {
  const RoomRequestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<RoomRequestsStore>(
      create: (_) =>
          RoomRequestsStore(RoomRequestRepository(getIt()))
            ..fetchRoomRequests(),
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
          child: Column(
            children: [
              Observer(
                builder: (context) => _buildFilterRow(
                  context,
                  Provider.of<RoomRequestsStore>(context),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Observer(
                      builder: (context) {
                        final store = Provider.of<RoomRequestsStore>(context);

                        if (store.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (store.errorMessage != null) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: ${store.errorMessage}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
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

                        if (store.filteredRequests.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.inbox,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No room requests found',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, RoomRequestsStore store) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final dateTimeFormat = DateFormat('MMM dd, yyyy h:mm a');

    return ListView.separated(
      itemCount: store.filteredRequests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final req = store.filteredRequests[index];
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildInfoRow(
                  context,
                  Icons.calendar_today,
                  'Check-in: ${dateFormat.format(req.checkInDate.toLocal())}',
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  context,
                  Icons.calendar_today,
                  'Check-out: ${dateTimeFormat.format(req.checkOutDate.toLocal())}',
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  context,
                  Icons.email,
                  'Email: ${req.user?.email}',
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  context,
                  Icons.phone,
                  'Phone: ${req.user?.phone}',
                ),
                const SizedBox(height: 4),
                _buildInfoRow(context, Icons.person, 'Name: ${req.user?.name}'),
                const SizedBox(height: 4),
                _buildInfoRow(
                  context,
                  Icons.person,
                  'User Name: ${req.user?.userName}',
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  context,
                  Icons.person,
                  'User Type: ${req.user?.userType}',
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  context,
                  Icons.person,
                  'Reference: ${req.reference}',
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  context,
                  Icons.person,
                  'Special Requests: ${req.specialRequests}',
                ),
                const SizedBox(height: 4),
                if (req.chitthiUrl != null && req.chitthiUrl!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildViewChitthiButton(context, req.chitthiUrl!),
                ],
                if (req.status == RequestStatus.approved) ...[
                  const SizedBox(height: 8),
                  _buildEditRequestButton(context, store, req),
                ],
                const SizedBox(height: 4),
                _buildStatusChip(context, req.status.name),
                _buildCheckInCheckOut(context, store, req),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'This request has already been ${req.status.name.toLowerCase()}',
                    ),
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

  Widget _buildCheckInCheckOut(
    BuildContext context,
    RoomRequestsStore store,
    RoomRequest req,
  ) {
    return req.status != RequestStatus.approved
        ? SizedBox.shrink()
        : ((req.assignment?.checkedIn ?? false) &&
              (req.assignment?.checkedOut ?? false))
        ? Column(
            children: [
              const SizedBox(height: 4),
              _buildInfoRow(
                context,
                Icons.calendar_month,
                'Checked-in At: ${DateFormat("dd MMM yyyy h:mm a").format(req.assignment?.checkedInAt ?? DateTime.now())}',
              ),
              const SizedBox(height: 4),
              _buildInfoRow(
                context,
                Icons.calendar_month,
                'Checked-out At: ${DateFormat("dd MMM yyyy h:mm a").format(req.assignment?.checkedOutAt ?? DateTime.now())}',
              ),
            ],
          )
        : Column(
            children: [
              Visibility(
                visible: req.assignment?.checkedInAt != null,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    _buildInfoRow(
                      context,
                      Icons.calendar_month,
                      'Checked-in At: ${DateFormat("dd MMM yyyy h:mm a").format(req.assignment?.checkedInAt ?? DateTime.now())}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {
                  store.isLoading ? null : store.checkInCheckOut(req: req);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Center(
                  child: store.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          req.assignment?.checkedIn ?? false
                              ? "Check Out"
                              : "Check In",
                        ),
                ),
              ),
            ],
          );
  }

  Widget _buildGridView(BuildContext context, RoomRequestsStore store) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final dateTimeFormat = DateFormat('MMM dd, yyyy h:mm a');

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: store.filteredRequests.length,
      itemBuilder: (context, index) {
        final req = store.filteredRequests[index];
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
                      'This request has already been ${req.status.name.toLowerCase()}',
                    ),
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context,
                    Icons.calendar_today,
                    'Check-in: ${dateFormat.format(req.checkInDate.toLocal())}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    context,
                    Icons.calendar_today,
                    'Check-out: ${dateTimeFormat.format(req.checkOutDate.toLocal())}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    context,
                    Icons.email,
                    'Email: ${req.user?.email}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    context,
                    Icons.phone,
                    'Phone: ${req.user?.phone}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    context,
                    Icons.person,
                    'Name: ${req.user?.name}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    context,
                    Icons.person,
                    'User Name: ${req.user?.userName}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    context,
                    Icons.person,
                    'User Type: ${req.user?.userType}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    context,
                    Icons.person,
                    'Reference: ${req.reference}',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    context,
                    Icons.person,
                    'Special Requests: ${req.specialRequests}',
                  ),
                  if (req.chitthiUrl != null && req.chitthiUrl!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildViewChitthiButton(context, req.chitthiUrl!),
                  ],
                  if (req.status == RequestStatus.approved) ...[
                    const SizedBox(height: 4),
                    _buildEditRequestButton(context, store, req),
                  ],
                  const Spacer(),
                  _buildStatusChip(context, req.status.name),
                  _buildCheckInCheckOut(context, store, req),
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

  Widget _buildViewChitthiButton(BuildContext context, String chitthiUrl) {
    return OutlinedButton.icon(
      onPressed: () => _showChitthiDialog(context, chitthiUrl),
      icon: const Icon(Icons.image, size: 18),
      label: const Text('View Chitthi'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        side: const BorderSide(color: Colors.deepPurple),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  Widget _buildEditRequestButton(
    BuildContext context,
    RoomRequestsStore store,
    RoomRequest req,
  ) {
    return OutlinedButton.icon(
      onPressed: () async {
        final result = await showDialog<RoomRequest>(
          context: context,
          builder: (context) => EditRoomRequestDialog(roomRequest: req),
        );
        if (result != null) {
          store.fetchRoomRequests();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Room request updated successfully.'),
              ),
            );
          }
        }
      },
      icon: const Icon(Icons.edit, size: 18),
      label: const Text('Edit Request'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        side: const BorderSide(color: Colors.blue),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  void _showChitthiDialog(BuildContext context, String chitthiUrl) {
    final imageUrl = '${Const.baseUrl}$chitthiUrl';
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chitthi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        print("loadingProgress: $loadingProgress");
                        print("imageUrl: $imageUrl");
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 300,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 8),
                                Text('Failed to load image'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context, RoomRequestsStore store) {
    final filters = ['all', 'pending', 'approved', 'rejected'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: filters.map((filter) {
        final isSelected = store.selectedFilter == filter;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            onPressed: () => store.setFilter(filter),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
              foregroundColor: isSelected ? Colors.white : Colors.black,
            ),
            child: Text(filter[0].toUpperCase() + filter.substring(1)),
          ),
        );
      }).toList(),
    );
  }
}
