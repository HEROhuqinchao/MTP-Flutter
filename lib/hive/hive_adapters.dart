import 'package:hive_ce/hive.dart';
import 'package:mtp/src/data/models/chat/message.dart';
import 'package:mtp/src/data/models/chat/model.dart';
import 'package:mtp/src/data/models/chat/session.dart';
import 'package:mtp/src/data/models/role.dart';
import 'package:mtp/src/data/models/settings.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<ChatMessage>(),
  AdapterSpec<Session>(),
  AdapterSpec<ChatModel>(),
  AdapterSpec<Role>(),
  AdapterSpec<Settings>(),
])
// Annotations must be on some element
// ignore: unused_element
void _() {}
