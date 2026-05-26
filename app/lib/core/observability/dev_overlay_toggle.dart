import 'package:flutter/foundation.dart';
import 'package:sport_manager_mobile/env.dart';

/// In-memory toggle for the Talker dev overlay. Defaults to `Env.isDev`; in
/// prod builds the trigger on the profile screen flips it at runtime. Not
/// persisted — every cold start re-reads `Env.isDev`.
final ValueNotifier<bool> devOverlayEnabled = ValueNotifier<bool>(Env.isDev);
