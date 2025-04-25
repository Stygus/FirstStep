import 'package:firststep/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = ChangeNotifierProvider<User>((ref) {
  return User(
    id: '-1',
    nickname: 'DefaultNickname',
    email: 'default@example.com',
    lastLoginDate:
        DateTime.now(), // DateTime.now().subtract(Duration(days: 1)),
    role: 'user',
  );
});
