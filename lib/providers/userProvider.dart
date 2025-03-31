import 'package:firststep/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = ChangeNotifierProvider<User>((ref) {
  return User(
    id: '-1',
    name: '0',
    email: '0',
    lastLogin: DateTime.now(), // DateTime.now().subtract(Duration(days: 1)),
    courseCount: 0,
  );
});
