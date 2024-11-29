import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart'; // Import HomePage

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> requests = [];

  // Fetch logs and their related details
  Future<void> fetchRequests() async {
    final snapshot = await FirebaseFirestore.instance.collectionGroup('logs').get();

    List<Map<String, dynamic>> tempRequests = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();

      // Skip logs that are already approved/rejected
      if (data['approved'] == null || data['approved'] == false) {
        // Fetch user details
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(data['user']).get();
        final userName = userDoc.exists
            ? (userDoc.data()?['name'] ?? 'Unknown User')
            : 'Unknown User';

        // Fetch item details
        String itemName = 'Unknown Item';
        int itemQuantity = 0;

        if (data['item'] != null && data['item'] is String) {
          final itemDoc = await FirebaseFirestore.instance.collection('items').doc(data['item']).get();
          if (itemDoc.exists) {
            final itemData = itemDoc.data();
            itemName = itemData?['name'] ?? 'Unknown Item';
            itemQuantity = itemData?['quantity'] ?? 0;
          }
        }

        tempRequests.add({
          'id': doc.id,
          'action': data['action'],
          'user': userName,
          'timestamp': (data['date'] as Timestamp).toDate(),
          'item': itemName,
          'quantity': itemQuantity,
          'docRef': doc.reference,
        });
      }
    }

    setState(() {
      requests = tempRequests;
    });
  }

  // Approve a request
  Future<void> approveRequest(DocumentReference docRef) async {
    try {
      await docRef.update({'approved': true});
      setState(() {
        requests.removeWhere((request) => request['docRef'] == docRef);
      });
      print('Request approved!');
    } catch (e) {
      print('Error approving request: $e');
    }
  }

  // Reject a request
  Future<void> rejectRequest(DocumentReference docRef) async {
    try {
      await docRef.update({'approved': false});
      setState(() {
        requests.removeWhere((request) => request['docRef'] == docRef);
      });
      print('Request rejected!');
    } catch (e) {
      print('Error rejecting request: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: requests.isEmpty
          ? const Center(
              child: Text(
                'No pending requests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: ${request['user']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Item: ${request['item']}', style: const TextStyle(fontSize: 14)),
                        Text('Quantity: ${request['quantity']}', style: const TextStyle(fontSize: 14)),
                        Text('Action: ${request['action']}', style: const TextStyle(fontSize: 14)),
                        Text('Date: ${request['timestamp']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => approveRequest(request['docRef']),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => rejectRequest(request['docRef']),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
