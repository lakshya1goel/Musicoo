import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/userModel.dart';

final authenticated = Provider<String>(
  (ref) {
    return "";
  },
);
