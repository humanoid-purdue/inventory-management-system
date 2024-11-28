// user.dart
class User {
  String name;
  String uid;
  String email;
  bool isAdmin;
  List<String> checkedOutItems;

  User({
    required this.name,
    required this.uid,
    required this.email,
    this.isAdmin = false,
    List<String>? checkedOutItems,
  }) : checkedOutItems = checkedOutItems ?? [];

  @override
  String toString() {
    return 'User(name: $name, uid: $uid, email: $email, isAdmin: $isAdmin, checkedOutItems: $checkedOutItems)';
  }
}
