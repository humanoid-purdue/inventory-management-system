// user.dart
class User {
  String uid;
  String email;
  bool isAdmin;
  List<String> checkedOutItems;

  User({
    required this.uid,
    required this.email,
    this.isAdmin = false,
    List<String>? checkedOutItems,
  }) : checkedOutItems = checkedOutItems ?? [];

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, isAdmin: $isAdmin, checkedOutItems: $checkedOutItems)';
  }
}
