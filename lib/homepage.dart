import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'objects/item.dart';
import 'admin_page.dart'; //AdminPage
import 'dart:math';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedAction = 'borrow';
  final List<String> actions = ['borrow', 'use','damaged'];
  List<Item> items = [];
  
  Item? selectedItem;
  bool isAdmin = false; 

  int quantity = 0;

  //controllers for the new item form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController binController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

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
          location: doc['location'],
          quantity: doc['quantity'],
          type: doc['type'],
          logs: [], // Modify as needed for actual log handling
        );
      }).toList();
      // selectedItem = items.isNotEmpty ? items[0] : null;
    });

    print("Fetched items: $items");
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
        if(isAdmin) {
          actions.add('add');
        }
      });
    }
  }

  // Handle item quantity update based on action
  Future<void> quantityUpdate() async {
    if (selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an item and action.")),
      );
      return;
    }

    final selected = selectedItem;
    final currentQuantity = selected?.quantity;

    if (selectedAction == 'add') {

      //Admin adds the quantity
      await updateItemQuantity(selected!, currentQuantity! + quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity successfully updated.')),
        );

    } else {

      if (quantity > currentQuantity!) {
        if (currentQuantity == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient Quantity. Available: 0 .')),
        );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Insufficient Quantity. Available: $currentQuantity.')),
        );
        }
      } else {
        final newQuantity = currentQuantity - quantity;
        await updateItemQuantity(selected!, newQuantity);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checkout successfully completed!')),
        );
      }

    }

    setState(() {
      quantity = 0;
    });

  }

  // Update item quantity in Firestore
  Future<void> updateItemQuantity(Item item, int newQuantity) async {
    await FirebaseFirestore.instance
          .collection('items')
          .doc(item.type)
          .update({'quantity': newQuantity});
    
    setState(() {
      item.quantity = newQuantity;
    });

  }

  //add new item
  Future<void> addNewItem() async {

    if (nameController.text.isEmpty || locationController.text.isEmpty || binController.text.isEmpty
    || quantityController.text.isEmpty || typeController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Required Fields, Cannot be Empty!')),);

      return;

    } 

    try {

      int newQuantity = int.tryParse(quantityController.text) ?? 0;

      //Create new Firestore Document with randomly generated ID
      final newDocRef = FirebaseFirestore.instance.collection('items').doc();
      
      //Create the new item object
      final newItem = Item(
        name: nameController.text, 
        bin: binController.text, 
        location: locationController.text, 
        quantity: newQuantity, 
        type: typeController.text,
        logs: [],
        uid: newDocRef.id,
      );

      //Save the new item to Firestore
      await newDocRef.set(newItem.toJson());

      //Refresh the items list
      await fetchItems();

      //Clear the form fields
      nameController.clear();
      locationController.clear();
      binController.clear();
      typeController.clear();
      quantityController.clear();

      setState(() {
        selectedItem = null;
        selectedAction = 'borrow';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding new item: $e')),
      );
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
                      items: [
                        if (selectedAction == 'add') 
                          const DropdownMenuItem<Item>(
                            value: null, 
                            child: Text('New Item'),
                            ),

                        ...items.map((Item item) {
                        return DropdownMenuItem<Item>(
                          value: item,
                          child: Text(item.name),
                        );
                      }).toList(),
                      ],
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

            const SizedBox(height: 20),

            //Form to add new item

            // ignore: unrelated_type_equality_checks
            if (selectedAction == 'add' && selectedItem == null) 

              Padding(padding: const EdgeInsets.symmetric(horizontal: 40.0), child: Column(children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Item Name'),),
                TextField(controller: binController, decoration: const InputDecoration(labelText: 'Item Bin'),),
                TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Item Bin Location'),),
                TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Item Type'),),
                TextField(controller: quantityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Item Quantity'),),

                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                  addNewItem(); // Call _addNewItem without any arguments
                }, child: const Text('Add Item'))


              ],),),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical:40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.amber[200],
                      hintText: "Enter Quantity",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onChanged: (value) {
                      setState(() {
                        quantity = int.tryParse(value) ?? 0;
                      });
                    },

                  )

                ],


              ),),

              const SizedBox(height: 20),
                ElevatedButton(onPressed: quantityUpdate, child: const Text('Submit')),
                const SizedBox(height: 80)

          ],
        ),
      ),
    );
  }
}
