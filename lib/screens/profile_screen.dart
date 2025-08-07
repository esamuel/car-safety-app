import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile_model.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _carModelController;
  late TextEditingController _carColorController;
  late TextEditingController _licensePlateController;
  String _selectedProfileType = 'normal'; // Default
  bool _isLoading = true;
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _carModelController = TextEditingController();
    _carColorController = TextEditingController();
    _licensePlateController = TextEditingController();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    try {
      _profile = await storageService.getDetailedUserProfile();
      _nameController.text = _profile.name;
      _carModelController.text = _profile.carModel;
      _carColorController.text = _profile.carColor;
      _licensePlateController.text = _profile.licensePlate;
      _selectedProfileType = _profile.profileType;
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // If no profile exists, create a new one
      _profile = UserProfile(
        name: '',
        carModel: '',
        carColor: '',
        licensePlate: '',
        profileType: 'normal',
        childProfiles: [],
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final updatedProfile = UserProfile(
        name: _nameController.text,
        carModel: _carModelController.text,
        carColor: _carColorController.text,
        licensePlate: _licensePlateController.text,
        profileType: _selectedProfileType,
        childProfiles: _profile.childProfiles,
      );

      final storageService = Provider.of<StorageService>(context, listen: false);
      await storageService.saveDetailedUserProfile(updatedProfile);

      setState(() {
        _profile = updatedProfile;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileSavedSuccessfully)),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _carModelController.dispose();
    _carColorController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProfileHeader(l10n),
                      const SizedBox(height: 24),
                      _buildPersonalInfoSection(l10n),
                      const SizedBox(height: 24),
                      _buildVehicleInfoSection(l10n),
                      const SizedBox(height: 24),
                      _buildProfileTypeSection(l10n),
                      const SizedBox(height: 24),
                      _buildChildProfilesSection(l10n),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          l10n.saveProfile,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileHeader(AppLocalizations l10n) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue.shade100,
          child: const Icon(
            Icons.person,
            size: 60,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.profileDetails,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.configureProfile,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.personalInfo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.fullName,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterName;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfoSection(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.vehicleDetails,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _carModelController,
              decoration: InputDecoration(
                labelText: l10n.carModel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.directions_car_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterCarModel;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _carColorController,
              decoration: InputDecoration(
                labelText: l10n.carColor,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.color_lens_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterCarColor;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _licensePlateController,
              decoration: InputDecoration(
                labelText: l10n.licenseNumber,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.credit_card),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.enterLicenseNumber;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTypeSection(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileType,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: Text(l10n.normalProfile),
              subtitle: Text(l10n.standardAlerts),
              value: 'normal',
              groupValue: _selectedProfileType,
              onChanged: (value) {
                setState(() {
                  _selectedProfileType = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.strictProfile),
              subtitle: Text(l10n.fasterAlerts),
              value: 'strict',
              groupValue: _selectedProfileType,
              onChanged: (value) {
                setState(() {
                  _selectedProfileType = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.customProfile),
              subtitle: Text(l10n.customSettings),
              value: 'custom',
              groupValue: _selectedProfileType,
              onChanged: (value) {
                setState(() {
                  _selectedProfileType = value!;
                });
              },
            ),
            if (_selectedProfileType == 'custom')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.customSettings,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.customSettingsDescription),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildProfilesSection(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.childProfiles,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _showAddChildDialog(l10n),
                  tooltip: l10n.addChildProfile,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.improveSystemAccuracy,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _profile.childProfiles.isEmpty
                ? Center(
                    child: Text(
                      l10n.noChildProfiles,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _profile.childProfiles.length,
                    itemBuilder: (context, index) {
                      final child = _profile.childProfiles[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            child.name.isNotEmpty 
                                ? child.name[0] 
                                : '?',
                          ),
                        ),
                        title: Text(child.name),
                        subtitle: Text('${l10n.age}: ${child.age}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeChildProfile(index),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _showAddChildDialog(AppLocalizations l10n) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addChildProfileTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.childName,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: l10n.enterAge,
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && ageController.text.isNotEmpty) {
                setState(() {
                  _profile.childProfiles.add(
                    ChildProfile(
                      name: nameController.text,
                      age: int.tryParse(ageController.text) ?? 0,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _removeChildProfile(int index) {
    setState(() {
      _profile.childProfiles.removeAt(index);
    });
  }
}
