import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/contacts.dart';
import 'contact_form_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({Key? key}) : super(key: key);

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final data = await DatabaseHelper.instance.getContacts();
    setState(() {
      contacts = data;
    });
  }

  void _deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    _loadContacts();
  }

  void _navigateToForm({Contact? contact}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactFormScreen(contact: contact),
      ),
    );
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KYTMO - Adress')),
      body: contacts.isEmpty
          ? const Center(child: Text('Aucun contact'))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text('${contact.phone} • ${contact.email}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToForm(contact: contact),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteContact(contact.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
