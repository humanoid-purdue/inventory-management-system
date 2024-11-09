import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  final int action;
  final String user;
  final DateTime date;
  final bool approved;

  Log({
    required this.action,
    required this.user,
    required this.date,
    required this.approved,
  });

  // Factory constructor to create a Log object from Firestore data
  factory Log.fromFirestore(Map<String, dynamic> data) {
    return Log(
      action: data['action'] as int,
      user: data['user'] as String,
      date: (data['date'] as Timestamp).toDate(),
      approved: data['approved'] as bool,
    );
  }

  // Optional: toJson method if you need to send data back to Firestore
  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'user': user,
      'date': Timestamp.fromDate(date), // Converting DateTime to Timestamp
      'approved': approved,
    };
  }
}
