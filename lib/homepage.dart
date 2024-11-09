import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'objects/item.dart';
import 'admin_page.dart'; // Import the AdminPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedAction = 'borrow';
  final List<String> actions = ['borrow', 'add', 'use'];
  List<Item> items = [];
  Item? selectedItem;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchItems();
    checkIfAdmin();
  }

  // Fetch items from Firestore
  Future<void> fetchItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('items').get();
    setState(() {
      items = snapshot.docs.map((doc) {
        return Item(
          uid: doc.id,
          name: doc['name'],
          bin: doc['bin'],
          building: doc['building'],
          quantity: doc['quantity'],
          logs: [], // Modify as needed for actual log handling
        );
      }).toList();
      selectedItem = items.isNotEmpty ? items[0] : null;
    });
  }

  // Check if the current user is an admin
  Future<void> checkIfAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        isAdmin = userDoc['isAdmin'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Inventory Management System"),
        actions: [
          if (isAdmin) // Show Admin button if user is admin
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100.0),
            const Center(
              child: Text(
                "Inventory Management System",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 0, 128, 1),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'lib/hrc.png',
              height: 250,
              width: 250,
            ),
            const SizedBox(height: 40),

            // Dropdown to select item
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Item",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButton<Item>(
                      isExpanded: true,
                      value: selectedItem,
                      items: items.map((Item item) {
                        return DropdownMenuItem<Item>(
                          value: item,
                          child: Text(item.name),
                        );
                      }).toList(),
                      onChanged: (Item? newItem) {
                        setState(() {
                          selectedItem = newItem;
                        });
                      },
                      underline: Container(),
                      dropdownColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Dropdown to select action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Action",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedAction,
                      items: actions.map((String action) {
                        return DropdownMenuItem<String>(
                          value: action,
                          child: Text(action),
                        );
                      }).toList(),
                      onChanged: (String? newAction) {
                        setState(() {
                          selectedAction = newAction!;
                        });
                      },
                      underline: Container(),
                      dropdownColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
