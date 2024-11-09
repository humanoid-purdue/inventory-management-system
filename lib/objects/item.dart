import 'package:cloud_firestore/cloud_firestore.dart';
import 'log.dart';  // Ensure you're importing the log.dart file

class Item {
  final String name;
  final String bin;
  final String building;
  final int quantity;
  final List<Log> logs;  // Store a list of Log objects
  final String uid; // Store the document UID (item ID)

  Item({
    required this.name,
    required this.bin,
    required this.building,
    required this.quantity,
    required this.logs,
    required this.uid, // Initialize UID
  });

  // Factory constructor to create an Item from Firestore data
  factory Item.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Item(
      name: data['name'] ?? '',
      bin: data['bin'] ?? '',
      building: data['building'] ?? '',
      quantity: data['quantity'] ?? 0,
      logs: (data['logs'] as List<dynamic>)
          .map((log) => Log.fromFirestore(log as Map<String, dynamic>))
          .toList(),
      uid: doc.id,  // Store the document ID (UID)
    );
  }

  // Optional: toJson method to send data back to Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bin': bin,
      'building': building,
      'quantity': quantity,
      'logs': logs.map((log) => log.toJson()).toList(),
    };
  }
}
