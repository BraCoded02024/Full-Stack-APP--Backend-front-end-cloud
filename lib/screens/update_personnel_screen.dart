import 'package:flutter/material.dart';
import '../models/personnel.dart';
import '../services/api_service.dart';
import '../config/app_colors.dart';
import 'edit_personnel_screen.dart';

class UpdatePersonnelScreen extends StatefulWidget {
  const UpdatePersonnelScreen({super.key});

  @override
  State<UpdatePersonnelScreen> createState() => _UpdatePersonnelScreenState();
}

class _UpdatePersonnelScreenState extends State<UpdatePersonnelScreen> {
  final _apiService = ApiService();
  List<Personnel> _personnelList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPersonnel();
  }

  Future<void> _loadPersonnel() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final personnel = await _apiService.getAllPersonnel();
      setState(() {
        _personnelList = personnel;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load personnel';
        _isLoading = false;
      });
    }
  }

  void _navigateToEdit(Personnel personnel) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPersonnelScreen(personnel: personnel),
      ),
    );

    if (result == true) {
      _loadPersonnel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Personnel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPersonnel,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadPersonnel,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_personnelList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No personnel found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add some personnel first',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPersonnel,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _personnelList.length,
        itemBuilder: (context, index) {
          final personnel = _personnelList[index];
          return _buildPersonnelCard(personnel);
        },
      ),
    );
  }

  Widget _buildPersonnelCard(Personnel personnel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToEdit(personnel),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.button3,
                radius: 28,
                child: Text(
                  personnel.name.isNotEmpty 
                      ? personnel.name[0].toUpperCase() 
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personnel.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      personnel.department,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          personnel.number,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.edit_outlined,
                color: AppColors.button3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
