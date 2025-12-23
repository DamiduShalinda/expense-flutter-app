import 'package:drift/drift.dart';

import 'open_connection_io.dart'
    if (dart.library.html) 'open_connection_web.dart';

QueryExecutor openConnection() => openConnectionImpl();
