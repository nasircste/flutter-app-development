import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/routes.dart';
import 'constants/app_constants.dart';
import 'services/auth_provider.dart';
import 'services/building_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TheProjectApp());
}

class TheProjectApp extends StatelessWidget {
  const TheProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => BuildingProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF44336),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
