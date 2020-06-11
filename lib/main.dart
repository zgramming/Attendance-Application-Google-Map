import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:provider/provider.dart';

import './src/app.dart';
import './src/providers/absen_provider.dart';
import './src/providers/maps_provider.dart';
import './src/providers/user_provider.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(
          create: (_) => GlobalProvider(),
        ),
        ChangeNotifierProvider<AbsenProvider>(
          create: (_) => AbsenProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<MapsProvider>(
          create: (_) => MapsProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
