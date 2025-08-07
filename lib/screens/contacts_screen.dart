import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:permission_handler/permission_handler.dart';
import '../models/contact_model.dart';
import '../services/storage_service.dart';
import '../l10n/app_localizations.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _emergencyContacts = [];
  List<contacts.Contact> _deviceContacts = [];
  bool _isLoading = true;
  bool _hasContactPermission = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Check permissions
    _hasContactPermission = await _checkContactPermission();
    
    // Load saved contacts
    final storageService = Provider.of<StorageService>(context, listen: false);
    _emergencyContacts = await storageService.getEmergencyContacts();
    
    // Load device contacts if permission granted
    if (_hasContactPermission) {
      await _loadDeviceContacts();
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<bool> _checkContactPermission() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }
    return status.isGranted;
  }
  
  Future<void> _loadDeviceContacts() async {
    final l10n = AppLocalizations.of(context);
    try {
      _deviceContacts = await contacts.FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
    } catch (e) {
      print('${l10n.contactsLoadError}: $e');
    }
  }
  
  Future<void> _saveContacts() async {
    final l10n = AppLocalizations.of(context);
    final storageService = Provider.of<StorageService>(context, listen: false);
    await storageService.saveEmergencyContacts(_emergencyContacts);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.contactsSavedSuccessfully)),
    );
  }
  
  void _addManualContact() {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addContactManually),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: relationController,
                decoration: InputDecoration(
                  labelText: l10n.relationshipHint,
                  border: const OutlineInputBorder(),
                ),
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
              if (nameController.text.isNotEmpty && 
                  phoneController.text.isNotEmpty) {
                setState(() {
                  _emergencyContacts.add(
                    Contact(
                      name: nameController.text,
                      phoneNumber: phoneController.text,
                      relation: relationController.text,
                      priority: _emergencyContacts.length + 1,
                      type: ContactType.emergency,
                      isEmergencyContact: true,
                    ),
                  );
                });
                _saveContacts();
                Navigator.pop(context);
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }
  
  void _showDeviceContactPicker() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                l10n.selectContact,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: _deviceContacts.length,
                itemBuilder: (context, index) {
                  final contact = _deviceContacts[index];
                  String? phoneNumber;
                  
                  if (contact.phones.isNotEmpty) {
                    phoneNumber = contact.phones.first.number;
                  }
                  
                  return ListTile(
                    leading: contact.photo != null
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                          )
                        : CircleAvatar(
                            child: Text(
                              contact.displayName.isNotEmpty
                                  ? contact.displayName[0]
                                  : '?',
                            ),
                          ),
                    title: Text(contact.displayName),
                    subtitle: phoneNumber != null
                        ? Text(phoneNumber)
                        : Text(l10n.noPhoneNumber),
                    onTap: () {
                      if (phoneNumber != null) {
                        _addContactFromDevice(contact, phoneNumber);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.contactHasNoPhone),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _addContactFromDevice(contacts.Contact contact, String phoneNumber) {
    final l10n = AppLocalizations.of(context);
    final relationController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.setRelationship),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${l10n.adding}: ${contact.displayName}'),
              const SizedBox(height: 16),
              TextField(
                controller: relationController,
                decoration: InputDecoration(
                  labelText: l10n.relationshipHint,
                  border: const OutlineInputBorder(),
                ),
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
              setState(() {
                _emergencyContacts.add(
                  Contact(
                    name: contact.displayName,
                    phoneNumber: phoneNumber,
                    relation: relationController.text,
                    priority: _emergencyContacts.length + 1,
                    type: ContactType.emergency,
                    isEmergencyContact: true,
                  ),
                );
              });
              _saveContacts();
              Navigator.pop(context);
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }
  
  void _removeContact(int index) {
    setState(() {
      _emergencyContacts.removeAt(index);
      // Update priority order
      for (int i = 0; i < _emergencyContacts.length; i++) {
        _emergencyContacts[i] = Contact(
          id: _emergencyContacts[i].id,
          name: _emergencyContacts[i].name,
          phoneNumber: _emergencyContacts[i].phoneNumber,
          email: _emergencyContacts[i].email,
          relation: _emergencyContacts[i].relation,
          type: _emergencyContacts[i].type,
          isEmergencyContact: _emergencyContacts[i].isEmergencyContact,
          priority: i + 1,
        );
      }
    });
    _saveContacts();
  }
  
  void _reorderContacts(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final contact = _emergencyContacts.removeAt(oldIndex);
      _emergencyContacts.insert(newIndex, contact);
      
      // Update priority order
      for (int i = 0; i < _emergencyContacts.length; i++) {
        _emergencyContacts[i] = Contact(
          id: _emergencyContacts[i].id,
          name: _emergencyContacts[i].name,
          phoneNumber: _emergencyContacts[i].phoneNumber,
          email: _emergencyContacts[i].email,
          relation: _emergencyContacts[i].relation,
          type: _emergencyContacts[i].type,
          isEmergencyContact: _emergencyContacts[i].isEmergencyContact,
          priority: i + 1,
        );
      }
    });
    _saveContacts();
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emergencyContacts),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(l10n),
                    Expanded(
                      child: _buildContactsList(l10n),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_hasContactPermission)
            FloatingActionButton(
              heroTag: 'contactPicker',
              onPressed: _showDeviceContactPicker,
              backgroundColor: Colors.green,
              mini: true,
              child: const Icon(Icons.contacts),
            ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addManual',
            onPressed: _addManualContact,
            tooltip: l10n.addContactTooltip,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.emergencyContacts,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.addEmergencyContacts}. ${l10n.dragToReorder}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade800),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.dragToReorder,
                    style: TextStyle(color: Colors.orange.shade800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactsList(AppLocalizations l10n) {
    if (_emergencyContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noEmergencyContacts,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addEmergencyContacts,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _emergencyContacts.length,
      onReorder: _reorderContacts,
      itemBuilder: (context, index) {
        final contact = _emergencyContacts[index];
        return Card(
          key: Key('contact_${contact.phoneNumber}'),
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              contact.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.phoneNumber),
                if (contact.relation.isNotEmpty) 
                  Text('${l10n.relation}: ${contact.relation}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removeContact(index),
            ),
            isThreeLine: contact.relation.isNotEmpty,
          ),
        );
      },
    );
  }
}
