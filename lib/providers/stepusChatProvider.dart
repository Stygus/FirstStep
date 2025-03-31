import 'package:firststep/models/stepus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stepusChatProvider = ChangeNotifierProvider((ref) {
  return Stepus();
});
