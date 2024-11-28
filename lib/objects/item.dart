import 'package:cloud_firestore/cloud_firestore.dart';
import 'log.dart';  // Ensure you're importing the log.dart file

class Item {
  final String name;
  final String bin;
  final String location;
  final String uid;
  int quantity;
  final String type; // Store the type of object
  final List<Log> logs;  // Store a list of Log objects
  

  Item({
    required this.name,
    required this.bin,
    required this.location,
    required this.uid,
    required this.quantity,
    required this.type,
    required this.logs,
  });

  // Factory constructor to create an Item from Firestore data
  factory Item.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Item(
      name: data['name'] ?? '',
      bin: data['bin'] ?? '',
      location: data['location'] ?? '',
      quantity: data['quantity'] ?? 0,
      type: data['type'] ?? '', 
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
      'location': location,
      'quantity': quantity,
      'type': type,
      'logs': logs.map((log) => log.toJson()).toList(),
    };
  }
}
