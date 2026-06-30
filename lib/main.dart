import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'core/constants/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar fully transparent - no black bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  // Portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Init provider — no Firebase init needed (REST API use ho raha hai)
  final provider = AppStateProvider();
  try {
    await provider.init();
  } catch (e) {
    debugPrint('Provider init failed: $e');
  }

  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const TezDropApp(),
    ),
  );
}

class TezDropApp extends StatelessWidget {
  const TezDropApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    return MaterialApp(
      title: 'TezDrop ⚡',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
