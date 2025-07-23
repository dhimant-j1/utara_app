import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../core/stores/auth_store.dart';
import '../repository/room_repository.dart';

class BulkUploadRoomsPage extends StatefulWidget {
  const BulkUploadRoomsPage({super.key});

  @override
  State<BulkUploadRoomsPage> createState() => _BulkUploadRoomsPageState();
}

class _BulkUploadRoomsPageState extends State<BulkUploadRoomsPage> {
  final _authStore = GetIt.instance<AuthStore>();
  final _roomRepository = GetIt.instance<RoomRepository>();

  File? _selectedFile;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  List<String> _uploadResults = [];

  @override
  void initState() {
    super.initState();
    // Check if current user has admin permission
    if (!_authStore.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You do not have permission to upload rooms'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/dashboard');
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _errorMessage = null;
          _successMessage = null;
          _uploadResults = [];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking file: ${e.toString()}';
      });
    }
  }

  Future<void> _uploadCSV() async {
    if (_selectedFile == null) {
      setState(() => _errorMessage = 'Please select a CSV file first');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
      _uploadResults = [];
    });

    try {
      // Upload CSV file to server
      final result = await _roomRepository.uploadRoomsCSV(_selectedFile!.path);

      setState(() {
        _successMessage = result['message'] ?? 'CSV uploaded successfully!';

        // If the backend returns detailed results, show them
        if (result['results'] != null) {
          _uploadResults = List<String>.from(result['results']);
        }

        // Show summary if available
        if (result['summary'] != null) {
          final summary = result['summary'];
          _successMessage =
              'Upload completed: ${summary['success_count'] ?? 0} rooms created, ${summary['error_count'] ?? 0} errors';
        }

        _selectedFile = null;
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _downloadSampleCSV() {
    // Show sample CSV format dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sample CSV Format'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your CSV file should have the following format:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'room_number,floor,capacity,amenities,description\n'
                  'A101,1,4,WiFi;AC;Projector,Conference room with projector\n'
                  'B202,2,2,WiFi;AC,Small meeting room\n'
                  'C303,3,8,WiFi;AC;Whiteboard,Large conference room',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Notes:\n'
                '• Separate multiple amenities with semicolons (;)\n'
                '• Floor and capacity must be numbers\n'
                '• Room number must be unique',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Upload Rooms'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Row(
                      children: [
                        Icon(Icons.upload_file, size: 32, color: Colors.blue),
                        SizedBox(width: 12),
                        Text(
                          'Bulk Upload Rooms',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Success Message
                    if (_successMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _successMessage!,
                                style: TextStyle(color: Colors.green.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Error Message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Sample CSV Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'CSV Format Requirements',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upload a CSV file with columns: room_number, floor, capacity, amenities, description',
                            style: TextStyle(color: Colors.blue.shade700),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _downloadSampleCSV,
                            child: const Text('View Sample Format'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // File Selection
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.file_upload,
                            size: 48,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          if (_selectedFile != null)
                            Text(
                              'Selected: ${_selectedFile!.path.split('/').last}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          else
                            const Text('No file selected'),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _pickFile,
                            icon: const Icon(Icons.folder_open),
                            label: const Text('Select CSV File'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Upload Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _uploadCSV,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Upload Rooms'),
                    ),

                    // Results
                    if (_uploadResults.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Upload Results:',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          itemCount: _uploadResults.length,
                          itemBuilder: (context, index) {
                            final result = _uploadResults[index];
                            final isError = result.contains('Error');
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                result,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isError ? Colors.red : Colors.green,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
